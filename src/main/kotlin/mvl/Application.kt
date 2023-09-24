package mvl

import io.ktor.server.application.*
import mvl.plugins.*

fun main(args: Array<String>) {
    io.ktor.server.cio.EngineMain.main(args)
}

fun Application.module() {
    configureSerialization()
    configureDatabases()
    configureMonitoring()
    configureHTTP()
    configureRouting()
}
