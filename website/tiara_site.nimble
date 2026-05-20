version       = "0.1.0"
author        = "Tiara Contributors"
description   = "Tiara marketing site (Crown + Basolato + Tiara)"
license       = "MIT"
srcDir        = "src"
bin           = @["website=main"]

requires "nim >= 2.2.6"
requires "crown == 0.5.7"
requires "https://github.com/itsumura-h/nim-basolato#v0.15.0"

task dev, "Crown 開発サーバー":
  exec "crown dev"

task build, "Crown 本番ビルド":
  exec "crown build"
