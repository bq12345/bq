onmessage = (e)->
  postMessage(doWork(e.data))


doWork = (pixels)->
  data = pixels.data
  width = pixels.width
  height = pixels.height
  n = 20
  m = n - 1
  for row in [0...height] by 1
    i = row * width * 4
    for col in [0...width] by 1
      MAX_VALUE = 255
      data[i] = MAX_VALUE - data[i]
      data[i + 1] = MAX_VALUE - data[i + 1]
      data[i + 2] = MAX_VALUE - data[i + 2]
      data[i + 3] = data[i + 3]
      i += 4
  pixels