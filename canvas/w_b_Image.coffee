onmessage = (e)->
  postMessage(old(e.data))


old = (pixels)->
  data = pixels.data
  width = pixels.width
  height = pixels.height
  for x in [0...width] by 1
    for y in [0...height] by 1
      i = (x + y * width) * 4
      r = data[i]
      g = data[i + 1]
      b = data[i + 2]
      ###
      算法及原理：
      求RGB平均值Avg ＝ (R + G + B) / 3，如果Avg >= 100，则新的颜色值为R＝G＝B＝255；
      如果Avg < 100，则新的颜色值为R＝G＝B＝0；255就是白色，0就是黑色；
      至于为什么用100作比较，这是一个经验值吧，设置为128也可以，可以根据效果来调整。
      ###
      AVG = (r + g + b) / 3
      if AVG > 100
        data[i] = 255
        data[i + 1] = 255
        data[i + 2] = 255
      else
        data[i] = 0
        data[i + 1] = 0
        data[i + 2] = 0
  pixels