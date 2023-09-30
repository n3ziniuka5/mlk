#!/usr/bin/env bash

if [ -z "$(which inotifywait)" ]; then
  echo "inotifywait not installed."
  echo "In most distros, it is available in the inotify-tools package."
  exit 1
fi

# Cannot store this data in variables because they need to be modified from the subshell
eventTimeFile=$(mktemp)
gradlePidFile=$(mktemp)

eventBufferTimeSeconds=0.5

function killGradle() {
  pid=$(cat $gradlePidFile)
  if [ "$pid" != "" ]; then
    kill $pid
  fi
}
trap killGradle SIGINT SIGTERM SIGQUIT

function gradleRun() {
  killGradle
  ./gradlew run &
  echo $! > $gradlePidFile
}

function onFileChange() {
  sleep $eventBufferTimeSeconds
  if [ "$(cat $eventTimeFile)" -eq "$1" ]; then
    if ./gradlew classes ; then # Check if the build is successful before restarting
        gradleRun
    fi
  fi
}

gradleRun
inotifywait --recursive --monitor \
--event modify,move,create,delete \
 src/main gradlew gradlew.bat gradle.properties build.gradle.kts settings.gradle.kts gradle/wrapper/gradle-wrapper.properties \
| while read changed; do
  eventAt=$(date +"%s%N")
  echo $eventAt > $eventTimeFile
  onFileChange $eventAt & # Run in background to avoid blocking
done
