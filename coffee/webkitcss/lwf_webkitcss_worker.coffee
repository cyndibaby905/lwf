#
# Copyright (C) 2012 GREE, Inc.
#
# This software is provided 'as-is', without any express or implied
# warranty.  In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.
#

if !window? and self?

  unless atob?
    atob = Base64.decode

  self.onmessage = (event) ->
    if typeof self.webkitPostMessage isnt "undefined" and
        typeof event.data is "object"
      data = Loader.loadArrayBuffer(event.data)
      self.webkitPostMessage(data)
    else
      data = event.data
      if data[0] is 'L' and data[1] is 'W' and data[2] is 'F'
        data = Loader.load(data)
      else
        data = (new Zlib.Inflate(atob(data))).decompress()
        if typeof Uint8Array isnt 'undefined' and
            typeof Uint16Array isnt 'undefined' and
            typeof Uint32Array isnt 'undefined'
          data = Loader.loadArrayBuffer(data.buffer)
        else
          data = Loader.loadArray(data)
      if typeof self.webkitPostMessage isnt "undefined"
        self.webkitPostMessage(data)
      else
        self.postMessage(data)
    self.close()

