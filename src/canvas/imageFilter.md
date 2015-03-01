利用Canvas实现各种滤镜效果
===

###WebWork###

首先来了解下WebWork的使用，因为处理图像需要大量的运算，而JavaScript是单线程运行的，所以
应该使用WebWork来进行像素级处理

WebWork的使用应该是先创建一个Work
>  var worker = new Worker('ImageWork.js');

然后给它传入一个消息

>  worker.postMessage(object);

使用回调函数来接收数据并展示在主线程上

>  worker.onmessage = function (e) {}

ImageWork.coffee 应该这样实现一个onmessage函数

> onmessage = (e)-> postMessage(doSomething(e.data))

具体就不细讲了，主要看像素应该如何处理

***

###首先应该得到图像的像素，可以如下操作###

1.定义img并给它添加点击事件

     document.getElementById('img').addEventListener('click', function (e) {
            var canvas = document.createElement('canvas'), img = e.target;
            canvas.width = img.width;
            canvas.height = img.height;
            var context = canvas.getContext('2d');
            context.drawImage(img, 0, 0);
            var pixels = context.getImageData(0, 0, img.width, img.height);

      ...
2.传给Work

> var worker = new Worker('oldImage.js');
         worker.postMessage(pixels);

3.像素处理

    ###
    对于得到的pixels进行两次for循环利用 i = (x + y * width) * 4 得到当前索引
    然后imgData[i] 为R通道
    imgData[i+1] 为G通道
    imgData[i+2] 为B通道
    imgData[i+3] 为Alpha通道
    ###

4.展示处理后的img

    worker.onmessage = function (e) {
                var smearedImg = e.data;
                context.putImageData(smearedImg, 0, 0);
                newImg.src = canvas.toDataURL();
                worker.terminate();
                canvas.width = canvas.height = 0;
    }

***

###下面看看具体算法实现###


1.灰度

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


2.黑白效果

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
          为什么用100作比较，设置为128也可以，可以根据效果来调整。
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

3.动态模糊

    onmessage = (e)->
      postMessage(smear(e.data))

    smear = (pixels)->
      data = pixels.data
      width = pixels.width
      height = pixels.height
      #设置n倍大以进行涂抹
      n = 20
      m = n - 1
      for row in [0...height] by 1
        i = row * width * 4 + 4
        col = 1
        for col in [1...width] by 1
          i += 4
          #像素偏移产生动感
          data[i] = (data[i] + data[i - 4] * m) / n
          data[i + 1] = (data[i + 1] + data[i - 3] * m) / n
          data[i + 2] = (data[i + 2] + data[i - 2] * m) / n
          data[i + 3] = (data[i + 3] + data[i - 1] * m) / n

      pixels

4.老照片效果

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
          #参见 http://blog.csdn.net/jia20003/article/details/9142111
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

5.反相

    onmessage = (e)->
      postMessage(doWork(e.data))


    doWork = (pixels)->
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
          #用255 - 当前值即可
          MAX_VALUE = 255
          data[i] = MAX_VALUE - data[i]
          data[i + 1] = MAX_VALUE - data[i + 1]
          data[i + 2] = MAX_VALUE - data[i + 2]
          data[i + 3] = data[i + 3]

      pixels

6.镜像效果(水平反转)

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

7.素描效果，参见 http://www.alloyteam.com/2012/07/convert-picture-to-sketch-by-canvas/

    /**
     * Created by bq on 2015/2/28.
     */

    var onmessage, smear;

    onmessage = function (e) {
        return postMessage(sketch(e.data, 3));
    };

    /**
     * 把图像变成黑白色
     * Y = 0.299R + 0.587G + 0.114B
     * @param  {Array} pixes pix array
     * @return {Array}
     */
    function discolor(pixes) {
        var grayscale;
        for (var i = 0, len = pixes.length; i < len; i += 4) {
            grayscale = pixes[i] * 0.299 + pixes[i + 1] * 0.587 + pixes[i + 2] * 0.114;
            pixes[i] = pixes[i + 1] = pixes[i + 2] = grayscale;
        }
        return pixes;
    }

    /**
     * 把图片反相, 即将某个颜色换成它的补色
     * @param  {Array} pixes pix array
     * @return {Array}
     */
    function invert(pixes) {
        for (var i = 0, len = pixes.length; i < len; i += 4) {
            pixes[i] = 255 - pixes[i]; //r
            pixes[i + 1] = 255 - pixes[i + 1]; //g
            pixes[i + 2] = 255 - pixes[i + 2]; //b
        }
        return pixes;
    }
    /**
     * 颜色减淡,
     * 结果色 = 基色 + (混合色 * 基色) / (255 - 混合色)
     * @param  {Array} basePixes 基色
     * @param  {Array} mixPixes  混合色
     * @return {Array}
     */
    function dodgeColor(basePixes, mixPixes) {
        for (var i = 0, len = basePixes.length; i < len; i += 4) {
            basePixes[i] = basePixes[i] + (basePixes[i] * mixPixes[i]) / (255 - mixPixes[i]);
            basePixes[i + 1] = basePixes[i + 1] + (basePixes[i + 1] * mixPixes[i + 1]) / (255 - mixPixes[i + 1]);
            basePixes[i + 2] = basePixes[i + 2] + (basePixes[i + 2] * mixPixes[i + 2]) / (255 - mixPixes[i + 2]);
        }
        return basePixes;
    }

    /**
     * 高斯模糊
     * @param  {Array} pixes  pix array
     * @param  {Number} width 图片的宽度
     * @param  {Number} height 图片的高度
     * @param  {Number} radius 取样区域半径, 正数, 可选, 默认为 3.0
     * @param  {Number} sigma 标准方差, 可选, 默认取值为 radius / 3
     * @return {Array}
     */
    function gaussBlur(pixes, width, height, radius, sigma) {
        var gaussMatrix = [],
            gaussSum = 0,
            x, y,
            r, g, b, a,
            i, j, k, len;

        radius = Math.floor(radius) || 3;
        sigma = sigma || radius / 3;

        a = 1 / (Math.sqrt(2 * Math.PI) * sigma);
        b = -1 / (2 * sigma * sigma);
        //生成高斯矩阵
        for (i = 0, x = -radius; x <= radius; x++, i++){
            g = a * Math.exp(b * x * x);
            gaussMatrix[i] = g;
            gaussSum += g;

        }
        //归一化, 保证高斯矩阵的值在[0,1]之间
        for (i = 0, len = gaussMatrix.length; i < len; i++) {
            gaussMatrix[i] /= gaussSum;
        }
        //x 方向一维高斯运算
        for (y = 0; y < height; y++) {
            for (x = 0; x < width; x++) {
                r = g = b = a = 0;
                gaussSum = 0;
                for(j = -radius; j <= radius; j++){
                    k = x + j;
                    if(k >= 0 && k < width){//确保 k 没超出 x 的范围
                        //r,g,b,a 四个一组
                        i = (y * width + k) * 4;
                        r += pixes[i] * gaussMatrix[j + radius];
                        g += pixes[i + 1] * gaussMatrix[j + radius];
                        b += pixes[i + 2] * gaussMatrix[j + radius];
                        // a += pixes[i + 3] * gaussMatrix[j];
                        gaussSum += gaussMatrix[j + radius];
                    }
                }
                i = (y * width + x) * 4;
                // 除以 gaussSum 是为了消除处于边缘的像素, 高斯运算不足的问题
                // console.log(gaussSum)
                pixes[i] = r / gaussSum;
                pixes[i + 1] = g / gaussSum;
                pixes[i + 2] = b / gaussSum;
                // pixes[i + 3] = a ;
            }
        }
        //y 方向一维高斯运算
        for (x = 0; x < width; x++) {
            for (y = 0; y < height; y++) {
                r = g = b = a = 0;
                gaussSum = 0;
                for(j = -radius; j <= radius; j++){
                    k = y + j;
                    if(k >= 0 && k < height){//确保 k 没超出 y 的范围
                        i = (k * width + x) * 4;
                        r += pixes[i] * gaussMatrix[j + radius];
                        g += pixes[i + 1] * gaussMatrix[j + radius];
                        b += pixes[i + 2] * gaussMatrix[j + radius];
                        // a += pixes[i + 3] * gaussMatrix[j];
                        gaussSum += gaussMatrix[j + radius];
                    }
                }
                i = (y * width + x) * 4;
                pixes[i] = r / gaussSum;
                pixes[i + 1] = g / gaussSum;
                pixes[i + 2] = b / gaussSum;
                // pixes[i] = r ;
                // pixes[i + 1] = g ;
                // pixes[i + 2] = b ;
                // pixes[i + 3] = a ;
            }
        }
        //end
        return pixes;
    }


    /**
     * 素描
     * @param  {Object} imgData
     * @param  {Number} radius 取样区域半径, 正数, 可选, 默认为 3.0
     * @param  {Number} sigma 标准方差, 可选, 默认取值为 radius / 3
     * @return {Array}
     */
    function sketch(imgData, radius, sigma){
        var pixes = imgData.data,
            width = imgData.width,
            height = imgData.height,
            copyPixes;

        discolor(pixes);//去色
        // 拷贝数组
        copyPixes = Array.prototype.slice.call(pixes, 0);
        invert(copyPixes);//反相
        gaussBlur(copyPixes, width, height, radius, sigma);//高斯模糊
        dodgeColor(pixes, copyPixes);//颜色减淡
        return imgData;
    }

8.浮雕/模糊/马赛克 略。

----------

最后附上Demo下载地址 [下载] (http://bq12345.github.io/src/canvas/filter.7z)



