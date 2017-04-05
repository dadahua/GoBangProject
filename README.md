# GoBangProject
大华五子棋（已上架），该项目主要用到MutipeerConnectivity框架，用蓝牙或者局域网二人近场五子棋对战。

### 一.项目介绍
#### 1.地址：
iTunes下载 ：[大华五子棋](https://itunes.apple.com/us/app/%E5%A4%A7%E5%8D%8E%E4%BA%94%E5%AD%90%E6%A3%8B/id1217483377?mt=8)

github地址：[GobangProject](https://github.com/dadahua/GoBangProject)

优酷操作视频：[如何操作](http://v.youku.com/v_show/id_XMjY1OTk5MzMzMg==.html?from=s1.8-1-1.2&spm=a2h0k.8191407.0.0)

#### 2.效果图：

![近场五子棋对战.gif](http://upload-images.jianshu.io/upload_images/1352811-b16aa5446c4964c8.gif?imageMogr2/auto-orient/strip)



#### 3.简介：
该项目主要用到[MutipeerConnectivity](https://www.oschina.net/translate/intro-multipeer-connectivity-framework-ios-programming)框架，用**蓝牙**或者**局域网**二人近场五子棋对战。


### 二.思路介绍
大概说下思路，具体看代码实现。
#### 1.画棋盘及落点
这个可以去慕课网看看这个视频:[五子棋](http://www.imooc.com/learn/646)，里面有详细的讲解，我对里面的进行了部分优化。比如怎么判断两点之间到底触摸的哪个点。


#### 2.悔棋，重来
每个点都是一个对象，让后把对象放数组里面，进行删去，或者重置。


#### 3.人机模式
![AI简介.png](http://upload-images.jianshu.io/upload_images/1352811-1d9630f0550e20de.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这里的AI（人工智能）比较简单，这个算法可深可浅，此项目就是比较浅的，深的可以去看[算法](http://blog.csdn.net/onezeros/article/details/5542379)，此项目AI的大体思路是：

- 先便利棋盘上面的点，找到AI的棋子有活四，死四的点，既下一步能形成5个点的落子点，找到就直接在此点落子。

- 如果没找到，就遍历玩家活四，或者死四的点，并在此进行落点进行防守，虽然活四没法防守。

- 然后这两个点都没找到的话，就直接找AI有形成活三，或者死三的点，进行落子进攻。

- 如果没找到，就找用户能形成活三，死三的点进行防守。就这样简单的进行交互。

#### 4.人人模式
人人连机主要用Multipeer Connectivity框架进行近场通讯，现在有黑白玩家想要连接。

- 那么双方必须打开蓝牙或者连接**同一WiFi**，接着至少要有一个设备作为浏览器(browser)，用来搜寻其他设备；

- 第二个设备必须是可发现的，它要声明它在这里，并且它想要与别的设备连接。换句话说，第二个设备需要宣传自己。
一般来说，两个设备都要宣传自己，但至少要有一个能浏览其他设备，从而建立连接。

- 接受邀请后双方建立连接。然后他们就可以基于session会话来传递数据消息数据（包括文本、图像以及可以转换为NSData对象的任何其他数据），流数据，资源数据。

- 此项目只需要传递消息数据即可。收到数据的代理方法默认会是在子线程上面，所以如果要更新UI等操作要用**GCD线程回调到主线程**上面来，否则会造成线程异常的情况。

- 传递的数据有棋子位置，棋子颜色，催促信号，语言文字等。为此我制定了简单的协议来区别这些数据。否则没有一套基本的标准，应用没办法判定这串数据是否是语言文字，还是棋子位置或者信号等。通讯协议表如下表所示。

|数据类型	| 头部|	内容	|例子|
| ------------- |:-------------:| :-------------:|:-------------:|
| 语言文字| 	~| 	文字	| ~你吃饭了吗？| 
| 黑子位置	| black	| 棋子x,y坐标	| black0705
| 白子位置	| white	| 棋子x,y坐标	| white0705
| 催促| 	quikly	| | 	quikly
| 悔棋	| undo	| | 	undo


#### 三.用到的三方和借鉴
感谢下面作者
1.[LLSwitch](https://github.com/lilei644/LLSwitch)
2.[SFDraggableDialogView](https://github.com/kubatruhlar/SFDraggableDialogView)
3.[慕课网五子棋](http://www.imooc.com/learn/646)

#### 四.结语
 如果能对你有帮助，就给个star或赞鼓励下，有什么没明白的欢迎留言交流。
