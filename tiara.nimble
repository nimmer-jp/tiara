version       = "0.1.1"
author        = "Tiara Contributors"
description   = "Pure Nim UI component library for SSR-first applications"
license       = "MIT"
srcDir        = "src"
skipDirs      = @["website", "tests", "docs", "examples"]
installExt    = @["nim", "js"]

requires "nim >= 2.2.0"

task test, "Run Tiara unit tests":
  exec "nim c -r --hints:off --path:src --nimcache:/tmp/tiara-nimcache --out:/tmp/tiara-tests tests/test_components.nim"
