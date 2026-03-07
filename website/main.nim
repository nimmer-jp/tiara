# framework
import basolato
# middleware
import ./app/http/middlewares/session_middleware
import ./app/http/middlewares/auth_middleware
import ./app/http/middlewares/set_headers_middleware
# controller
import ./app/http/controllers/welcome_controller


let routes = @[
  Route.group("", @[
    Route.group("", @[
      Route.get("/", welcome_controller.index),
      Route.get("/docs", welcome_controller.docs),
      Route.get("/components", welcome_controller.components),
      Route.get("/tiara-client", welcome_controller.tiaraClientJs),
    ])
    .middleware(session_middleware.sessionFromCookie)
    .middleware(auth_middleware.checkCsrfToken),

    Route.group("/api", @[
      Route.get("/index", welcome_controller.indexApi),
    ])
    .middleware(set_headers_middleware.setSecureHeaders)
  ])
  .middleware(set_headers_middleware.setCorsHeaders)
]

serve(routes)
