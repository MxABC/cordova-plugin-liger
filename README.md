liger基于cordova的一个框架，优点在于可以native界面跳转、返回、打开对话框等，传递参数等，这里

将liger代码组织成 cordova插件形式，方便cordova直接集成liger，主要使用liger界面跳转、传递参数功能，其他功能使用cordova插件。


html5开发相关资料


混合(Hybrid)移动应用开发

http://www.cocoachina.com/webapp/20141217/10667.html



1、LigerMobile(界面原生跳转，可作为cordova的一个界面跳转插件即可)
目前看起来的最优选择，一个轻量级的开源hybrid框架，最新的更新时间在2014年底，看起来至少还是有人在维护的。
github的主库地址是
https://github.com/reachlocal/liger
common库：
https://github.com/reachlocal/liger-common
ios库：
https://github.com/reachlocal/liger-ios
android库：
https://github.com/reachlocal/liger-android

http://www.csdn.net/article/2014-09-02/2821513-LigerMobile

2、phonegap/Cordova
这个一个国外的开源框架，也是前一段时间最火的，具体是否可用还有待评估，网站：
http://phonegap.com/

Cordova (科多瓦)
这个是phonegap的核心或开源版本（phonegap商标属于adobe），目前为apache基金会项目，在2012年的新闻中看到这个和phonegap都会存在，并且在很长段时间内代码一致。
http://cordova.apache.org/



4、appcan
国内的一个开源框架，应用的也比较多。不过比较担心国内的框架封装会不太够。另外，appcan提供了IDE、手机端和JS的SDK，做的比较全面。优点是中文的资料会比较多，功能全。缺点可能是封装不足，无法后台和前台js库无法完全脱离，会导致无法更换js库或者与其他js库不兼容。
http://www.appcan.cn/

AppCan是国内Hybrid App混合模式开发的倡导者，AppCan应用引擎支持Hybrid App的开发和运行。并且着重解决了基于HTML5的移动应用"不流畅"和"体验差"的问题。使用AppCan应用引擎提供的Native交互能力，可以让HTML5开发的移动应用基本接近Native App的体验。
与Phonegap支持单一webview使用div为单位开发移动应用不同。AppCan支持多窗口机制，让开发者可以像最传统的网页开发一样，通过页面链接的方式灵活的开发移动应用。基于这种机制，开发者可以开发出大型的移动应用，而不是只能开发简易类型的移动应用。 




5、ionicframework
这是一个前台js库，用于移动设备。据说封装的比较好（http://www.geek521.com/?p=5530），不过实际情况有待确定，可以作为一个移动端前台库的备选
http://ionicframework.com/

http://www.xuebuyuan.com/2184971.html


6、intel appframework
http://app-framework-software.intel.com/index.php
