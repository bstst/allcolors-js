fs = require 'fs'
PNG = require('pngjs').PNG

r = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min
  
mr = ->
  r 0, 31
  
mrh = ->
  h(mr() * 7)
  
h = (d) ->
  "0x#{(d).toString 16}"

png = new PNG
  width: 256
  height: 128
  checkCRC: false
  
c = [1..32768]

startx = r 1, 256
starty = r 1, 128

takenX = []
takenY = []

okX = (x) ->
  -1 is takenX.indexOf x

okY = (y) ->
  -1 is takenY.indexOf y

x = 1
y = 1

for r in [0..31]
  for g in [0..31]
    for b in [0..31]
      x++
      if x > 256
        y++
        x = 1
      
      idx = (png.width * y + x) << 2

      png.data[idx] = h(r * 7)
      png.data[idx + 1] = h(g * 7)
      png.data[idx + 2] = h(b * 7)
      png.data[idx + 3] = 0xff

#for y in [1..png.height]
#  for x in [1..png.width]
#    idx = (png.width * y + x) << 2
#    console.log idx
#    png.data[idx] = mrh()
#    png.data[idx + 1] = mrh()
#    png.data[idx + 2] = mrh()
#    png.data[idx + 3] = 0xff
    
png.pack().pipe fs.createWriteStream 'out.png'
