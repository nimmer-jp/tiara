import std/os
if not existsEnv("HOST"):
  putEnv("HOST", "0.0.0.0")
if not existsEnv("PORT"):
  putEnv("PORT", "8000")
if not existsEnv("DB_SQLITE"):
  putEnv("DB_SQLITE", $true) # "true" or "false"
# putEnv("DB_POSTGRES", $true) # "true" or "false"
# putEnv("DB_MYSQL", $true) # "true" or "false"
# putEnv("DB_MARIADB", $true) # "true" or "false"
if not existsEnv("SESSION_TYPE"):
  putEnv("SESSION_TYPE", "file") # "file" or "redis"
if not existsEnv("SESSION_DB_PATH"):
  putEnv("SESSION_DB_PATH", "./session.db") # Session file path or redis host:port. ex:"127.0.0.1:6379"
if not existsEnv("LIBSASS"):
  putEnv("LIBSASS", $false) # "true" or "false"
