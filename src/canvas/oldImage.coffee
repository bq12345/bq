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
      dr = .393 * r + .769 * g + .189 * b
      dg = .349 * r + .686 * g + .168 * b
      db = .272 * r + .534 * g + .131 * b
      scale = Math.random() * 0.5 + 0.5
      fr = scale * dr + (1 - scale) * r;
      fg = scale * dg + (1 - scale) * g;
      fb = scale * db + (1 - scale) * b;
      data[i] = fr
      data[i + 1] = fg
      data[i + 2] = fb
  pixels