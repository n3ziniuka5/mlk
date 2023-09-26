package mlk

import io.ktor.server.application.*
import mlk.plugins.*

fun main(args: Array<String>) {
    println("application started")
    io.ktor.server.cio.EngineMain.main(args)
}

fun Application.module() {
    //configureSerialization()
    configureDatabases()
    //configureMonitoring()
    //configureHTTP()
    configureRouting()
}
