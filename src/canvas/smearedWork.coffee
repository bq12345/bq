onmessage = (e)->
  postMessage(smear(e.data))


smear = (pixels)->
  data = pixels.data
  width = pixels.width
  height = pixels.height
  n = 20
  m = n - 1
  for row in [0...height] by 1
    i = row * width * 4 + 4
    col = 1
    for col in [1...width] by 1
      i += 4
      data[i] = (data[i] + data[i - 4] * m) / n
      data[i + 1] = (data[i + 1] + data[i - 3] * m) / n
      data[i + 2] = (data[i + 2] + data[i - 2] * m) / n
      data[i + 3] = (data[i + 3] + data[i - 1] * m) / n

  pixels