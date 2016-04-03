onmessage = (e)->
  postMessage(smear(e.data))


smear = (pixels)->
  data = pixels.data
  width = pixels.width
  height = pixels.height
  tempCanvasData = Array.prototype.slice.call(data)
  for x in [0...width] by 1
    for y in [0...height] by 1

      idx = (x + y * width) * 4
      #水平对称点
      midx = ((width - 1 - x) + y * width) * 4

      data[midx + 0] = tempCanvasData[idx + 0]
      data[midx + 1] = tempCanvasData[idx + 1]
      data[midx + 2] = tempCanvasData[idx + 2]
      data[midx + 3] = 255

  pixels