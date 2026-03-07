import os
import re

with open('/Users/nakagawa_shota/repo/valit/tiara/src/tiara/client.nim', 'r') as f:
    text = f.read()

# Replace jsNode.matches with jsNode[cstring("matches")]
text = text.replace('jsNode.matches(', 'jsNode.invoke(cstring("matches"), ')
text = text.replace('jsNode.matches', 'jsNode[cstring("matches")]')

text = text.replace('jsNode.closest(', 'jsNode.invoke(cstring("closest"), ')
text = text.replace('jsNode.closest', 'jsNode[cstring("closest")]')

text = text.replace('list.toJs().contains(', 'list.toJs().invoke(cstring("contains"), ')

with open('/Users/nakagawa_shota/repo/valit/tiara/src/tiara/client.nim', 'w') as f:
    f.write(text)
