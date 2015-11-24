onmessage = (e)->
  postMessage(smear(e.data))


smear = (pixels)->
  data = pixels.data
  width = pixels.width
  height = pixels.height
  for x in [0...width] by 1
    for y in [0...height] by 1
      idx = (x + y * width) * 4
      #经典去色公式
      Y = 0.299 * data[idx] + 0.587 * data[idx + 1] + 0.114 * data[idx + 2]
      data[idx] = Y
      data[idx + 1] = Y
      data[idx + 2] = Y
      data[idx + 3] = 255
  pixels