import basolato/view


proc htmlComponent*(value: string): Component =
  result = Component.new()
  result.add(value)
