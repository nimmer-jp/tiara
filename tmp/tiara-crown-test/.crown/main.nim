import crown_env_preserver
import std/[os, strutils]
import basolato except html
import routes

proc crownParsePortEnv(defaultPort: int): int =
  let pref = crown_env_preserver.crownPortBeforeBasolatoEnv
  let s = if pref.len > 0: pref else: getEnv("PORT", "").strip()
  if s.len == 0:
    return defaultPort
  try:
    return parseInt(s)
  except ValueError:
    return defaultPort

when compiles(Settings.new(port = 5000)):
  let port = crownParsePortEnv(5000)
  let hostRaw = getEnv("HOST", "0.0.0.0").strip()
  let host = if hostRaw.len > 0: hostRaw else: "0.0.0.0"
  let settings = Settings.new(host = host, port = port)
  when compiles(Routes.merge(@[])):
    serve(@[routes.routes], settings)
  else:
    serve(routes.routes, settings)
else:
  when compiles(Routes.merge(@[])):
    serve(@[routes.routes])
  else:
    serve(routes.routes)
