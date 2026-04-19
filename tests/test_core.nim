import std/unittest
import ../src/tiara

suite "Tiara core macro":
  test "html macro parses variable injection":
    let name = "Tiara"
    let number = 42
    let res = html"""<div>Hello {name}, ans is {number}</div>"""
    check $res == "<div>Hello Tiara, ans is 42</div>"
    
  test "html macro escapes variables by default":
    let script = "<script>alert(1)</script>"
    let res = html"""<span>{script}</span>"""
    check $res == "<span>&lt;script&gt;alert(1)&lt;/script&gt;</span>"
    
  test "html macro does not escape Html type variables":
    let raw = rawHtml("<script>alert(1)</script>")
    let res = html"""<span>{raw}</span>"""
    check $res == "<span><script>alert(1)</script></span>"
    
  test "html macro translates tiara-on attributes":
    let res = html"""<button tiara-on:click="handleClick">Click</button>"""
    check $res == "<button data-tiara-on-click=\"handleClick\">Click</button>"
    
  test "html macro handles escaped braces":
    let res = html"""<style>.foo \{ color: red; \}</style>"""
    check $res == "<style>.foo { color: red; }</style>"

  test "tiaraHtml macro matches html (Crown collision escape hatch)":
    let name = "Tiara"
    let res = tiaraHtml"""<div>{name}</div>"""
    check $res == "<div>Tiara</div>"

proc testClientProc(e: string) {.client.} =
  echo "clicked ", e
