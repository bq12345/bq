# 编码

本篇主要讲述计算机编码相关的知识，字集码是把字符集中的字符编码为指定集合中某一对象，以便文本在计算机中存储和通过通信网络的传递。主要有 ASCII、ISO西欧系列、DOS字符集、Windows字符集、亚洲字符集、Unicode。

## 编码历史

在计算机存储和传输的所有数据最终形态都是 0 或 1，为了能使传输字符就规定了一个数字对应一个字符，例如对于字母 a 来说，就是存入 97 这个数字，而在读取的时候遇到 97 自然也就知道了它代表的是 a。

为了使得所有的计算机都能知道这个约定，于是 ASCII 最早就被发明出来了，包含控制字符，标点，英文大小写，同时还是留了 128-255 来后续使用。

但是当时候的人们就没想到中文之类的非英文字符的编码问题。

后来计算机传入中国，砖家们发明了 GB212 编码，两个字节存储，通过第一个字节位来判断，如果是 0 代表是 ASCII， 1 代码是汉字。后来又有了些新的扩展 GBK 之类的。

但是其他国家地区就根本不知道这种编码规则，于是就诞生了各种编码，后来 ISO 着手解决这个问题。他们重新搞一个包括了地球上所有文化、所有字母和符号 的编码 --> `Universal Multiple-Octet Coded Character Set`，这就是 Unicode 的来源。


## Unicode


Unicode 目前实际应用的统一码版本对应于 UCS-2 ，使用16位的编码空间。也就是每个字符占用2个字节。这样理论上一共最多可以表示216（即65536）个字符。基本满足各种语言的使用。

## UTF

Unicode只是一个符号集，它只规定了符号的二进制代码，却没有规定这个如何存储传输。而二进制代码应该如何存储Unicode的实现方式不同于编码方式。一个字符的Unicode编码是确定的。但是在实际传输过程中，由于不同系统平台的设计不一定一致，以及出于节省空间的目的，对Unicode编码的实现方式有所不同。Unicode的实现方式称为Unicode转换格式（Unicode Transformation Format，简称为UTF）

## UTF-8

UTF-8（8-bit Unicode Transformation Format）是一种针对Unicode的可变长度字符编码，也是一种前缀码。它可以用来表示Unicode标准中的任何字符，且其编码中的第一个字节仍与ASCII兼容，这使得原来处理ASCII字符的软件无须或只须做少部分修改，即可继续使用。因此，它逐渐成为电子邮件、网页及其他存储或发送文字的应用中，优先采用的编码。

所以一个很明确的二者的区分就是 **UTF-8是Unicode的一种实现方式**。

UTF-8对应使用一至六个字节为每个字符编码，后来又改口了，2003年11月UTF-8被RFC 3629重新规范，只能使用原来Unicode定义的区域，U+0000到U+10FFFF，也就是说最多四个字节

1.128个US-ASCII字符只需一个字节编码（Unicode范围由U+0000至U+007F）。

2.带有附加符号的拉丁文、希腊文、西里尔字母、亚美尼亚语、希伯来文、阿拉伯文、叙利亚文及它拿字母则需要两个字节编码（Unicode范围由U+0080至U+07FF）。

3.其他基本多文种平面（BMP）中的字符（这包含了大部分常用字，如大部分的汉字）使用三个字节编码（Unicode范围由U+0800至U+FFFF）。


## 转换

UTF-8的编码结构长度是根据某单个字符的大小来决定长度有多少。

```text
1个字节：Unicode码为0 - 127
2个字节：Unicode码为128 - 2047
3个字节：Unicode码为2048 - 0xFFFF
4个字节：Unicode码为65536 - 0x1FFFFF

```

如下面的表格所示


<table>
<caption><b>Unicode 和 UTF-8 之间的转换关系表 ( <code>x</code> 字符表示码点占据的位 )</b></caption>
<tbody><tr>
<th>码点的位数</th>
<th>码点起值</th>
<th>码点终值</th>
<th>字节序列</th>
<th>Byte 1</th>
<th>Byte 2</th>
<th>Byte 3</th>
<th>Byte 4</th>
<th>Byte 5</th>
<th>Byte 6</th>
</tr>
<tr>
<th>&nbsp;&nbsp;7</th>
<td>U+0000</td>
<td>U+007F</td>
<td style="text-align: center;">1</td>
<td><code>0xxxxxxx</code></td>
</tr>
<tr>
<th>11</th>
<td>U+0080</td>
<td>U+07FF</td>
<td style="text-align: center;">2</td>
<td><code>110xxxxx</code></td>
<td><code>10xxxxxx</code></td>
</tr>
<tr>
<th>16</th>
<td>U+0800</td>
<td>U+FFFF</td>
<td style="text-align: center;">3</td>
<td><code>1110xxxx</code></td>
<td><code>10xxxxxx</code></td>
<td><code>10xxxxxx</code></td>
</tr>
<tr>
<th>21</th>
<td>U+10000</td>
<td>U+1FFFFF</td>
<td style="text-align: center;">4</td>
<td><code>11110xxx</code></td>
<td><code>10xxxxxx</code></td>
<td><code>10xxxxxx</code></td>
<td><code>10xxxxxx</code></td>
</tr>
<tr>
<th>26</th>
<td>U+200000</td>
<td>U+3FFFFFF</td>
<td style="text-align: center;">5</td>
<td><code>111110xx</code></td>
<td><code>10xxxxxx</code></td>
<td><code>10xxxxxx</code></td>
<td><code>10xxxxxx</code></td>
<td><code>10xxxxxx</code></td>
</tr>
<tr>
<th>31</th>
<td>U+4000000</td>
<td>U+7FFFFFFF</td>
<td style="text-align: center;">6</td>
<td><code>1111110x</code></td>
<td><code>10xxxxxx</code></td>
<td><code>10xxxxxx</code></td>
<td><code>10xxxxxx</code></td>
<td><code>10xxxxxx</code></td>
<td><code>10xxxxxx</code></td>
</tr>
</tbody></table>

英文和英文字符的Unicode码为0 - 127，所以英文在Unicode和UTF-8中的长度和字节都是一致的，只占用1个字节。汉字的Unicode码区间为0x2e80 - 0x9fff, 所以汉字在UTF8中的长度最长为3个字节。

具体转换过程呢？

1.获取汉字的Unicode值，默认JS就是用Unicode编码的，所以通过`charCodeAt`很容易得到了。

2.明确字节数，根据上表通过charCode很容易知道在UTF8中应该占多少字节。

3.填充补码。根据上表将上面得到的Unicode码依次补到x位中去，补位码第一个字节前面有几个1就表示整个UTF-8编码占多少个字节。


## 举例

下面以一个汉字 "白" 的转换说明这个过程


首先通过 charCodeAt 得到 30333，并通过 `'白'.charCodeAt(0).toString(2)`得到其二进制 111011001111101 -> 01110110 01111101

然后发现其在 2048 - 0xFFFF 之间，得到 1110xxxx 10xxxxxx 10xxxxxx -> 1110 0111 10 011001 10 111101

最后就得到了 e7 99 bd 了，可以使用Node来验证下

```js
var buffer = new Buffer('白');
console.log(buffer.length); // => 3
console.log(buffer); // <Buffer e7 99 bd>

```

## 编码实现


```js

'use strict';

// 将字符转化为UTF8编码的字节数据
let toUTF = (str)=> {
    let utf8 = [];
    for (let i = 0; i < str.length; i++) {
        let code = str.charCodeAt(i);
        // ASCII 位于 U+0000~U+007F
        if (0x00 <= code && code <= 0x7f) {
            utf8.push(code);
            // 两个字节的情况 U+0080~U+07FF
        } else if (0x80 <= code && code <= 0x7ff) {
            // 第一个字节是 11000000 |  (00011111 & code 高位)
            utf8.push((192 | (0x1f & (code >> 6))));
            // 第二个字节 10000000 | (00111111 & code) code后6位
            utf8.push((128 | (0x3f & code)));
            // 三个字节
        } else if ((0x800 <= code && code <= 0xd7ff)
            || (0xe000 <= code && code <= 0xffff)) {
            // 依次三个字节的补齐
            utf8.push((224 | (0xf & (code >> 12))));
            utf8.push((128 | (0x3f & (code >> 6))));
            utf8.push((128 | (0x3f & code)))
        }
    }
    for (let i = 0; i < utf8.length; i++) {
        let item = utf8[i];
        item &= 0xff;
        utf8[i] = item.toString(16);
    }
    return utf8;
};

let char = '白';
let buffer = new Buffer(char);

console.log(buffer);
console.log(toUTF(char));

// <Buffer e7 99 bd>
// [ 'e7', '99', 'bd' ]
```

## 解码

```js
let readUTF = (arr)=> {
  // 解码的过程类似，根据补位码第一个字节前面有几个1就表示整个UTF-8编码占多少个字节！这是解码的关键
}
```


## 浏览器中使用

因为根据规范URI中的querystring必须按照UTF8的编码进行传输，而JavaScript是Unicode的，所以浏览器就给我们提供了一个方法，也就是`encodeURI/encodeURIComponent`方法

二者的差别是是否对 URL 编码，使用后者一般是将 URL 作为参数的时候

```js

encodeURI("http://www.google.com/a file with spaces.html") // http://www.google.com/a%20file%20with%20spaces.html

encodeURIComponent("http://www.google.com/a file with spaces.html") // http%3A%2F%2Fwww.google.com%2Fa%20file%20with%20spaces.html

var param1 = encodeURIComponent("http://xyz.com/?a=12&b=55")

var url = "http://domain.com/?param1=" + param1 + "&param2=99" // http://www.domain.com/?param1=http%3A%2F%2Fxyz.com%2F%Ffa%3D12%26b%3D55&param2=99

```

回归正题

```js

let str = '白';
let code = encodeURI(str);
let codeArr = code.slice(1).split('%');
codeArr = codeArr.map(item=>parseInt(item, 16));

console.log(codeArr); // => [231, 153, 189]

```

解析回来用 `decodeURI/decodeURIComponent` 就可以了。

以上可以帮助大家了解到编码的原理，并且清楚转化过程，各种实现，谢谢~
