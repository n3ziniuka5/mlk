package mlk

import io.ktor.server.application.*
import io.ktor.util.logging.KtorSimpleLogger
import mlk.plugins.*

private val log = KtorSimpleLogger("main")

fun main(args: Array<String>) {
    log.info("application started")
    io.ktor.server.cio.EngineMain.main(args)
}

fun Application.module() {
    //configureSerialization()
    configureDatabases()
    //configureMonitoring()
    //configureHTTP()
    configureRouting()
}
