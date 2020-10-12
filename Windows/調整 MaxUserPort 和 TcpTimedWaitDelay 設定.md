![mahua](mahua-logo.jpg)
##MaHua是什么?
一个在线编辑markdown文档的编辑器

##MaHua有哪些功能？

* 方便的`导入导出`功能
    *  直接把一个markdown的文本文件拖放到当前这个页面就可以了
    *  导出为一个html格式的文件，样式一点也不会丢失
* 编辑和预览`同步滚动`，所见即所得（右上角设置）
* `VIM快捷键`支持，方便vim党们快速的操作 （右上角设置）
* 强大的`自定义CSS`功能，方便定制自己的展示
* 有数量也有质量的`主题`,编辑器和预览区域
* 完美兼容`Github`的markdown语法
* 预览区域`代码高亮`
* 所有选项自动记忆

##有问题反馈
在使用中有任何问题，欢迎反馈给我，可以用以下联系方式跟我交流

* 邮件(dev.hubo#gmail.com, 把#换成@)
* 微信:jserme
* weibo: [@草依山](http://weibo.com/ihubo)
* twitter: [@ihubo](http://twitter.com/ihubo)

##捐助开发者
在兴趣的驱动下,写一个`免费`的东西，有欣喜，也还有汗水，希望你喜欢我的作品，同时也能支持一下。
##感激
感谢以下的项目,排名不分先后

* [ace](http://ace.ajax.org/)
* [jquery](http://jquery.com)

##关于作者

```javascript
var ihubo = {
  nickName  : "草依山",
  site : "http://jser.me"
}
```



<!-- ![](https://github.com/wdwd2233/Notes/blob/master/Windows/img/XAMPP.png?raw=true) -->


## 調整 MaxUserPort  設定

1. MaxUserPort值會控制當應用程式向系統要求任何可用的使用者埠時，所使用的最大端口號碼。
2. 一般來說，短期的埠會配置在1025到65535的範圍內。 埠範圍現在是真正的範圍，具有起始點和端點。 
3. 新的預設開始埠是49152，而預設的結束埠是65535。 除了服務和應用程式使用的知名埠之外，此範圍也是。  
4. 伺服器所使用的埠範圍可以在每部伺服器上修改。
 

#### 可以使用 netsh 命令來調整此範圍，如下所示：
  ##### `此命令會設定 TCP 的動態埠範圍。 [開始] 埠為 [數位]，而 [埠總數] 為 [範圍]。`
        * netsh int ipv4 set dynamicport tcp start=1025 num=64511
        * netsh int ipv4 set dynamicport udp start=10000 num=1000
        * netsh int ipv6 set dynamicport tcp start=10000 num=1000
        * netsh int ipv6 set dynamicport udp start=10000 num=1000


#### 可以使用 netsh 命令來動態埠範圍，如下所示：
    
        * netsh int ipv4 show dynamicport tcp
        * netsh int ipv4 show dynamicport udp
        * netsh int ipv6 show dynamicport tcp
        * netsh int ipv6 show dynamicport udp

## 調整 TcpTimedWaitDelay 設定

1. TcpTimedWaitDelay值會決定在關閉時，連接停留在 TIME_WAIT 狀態的時間長度。 
2. 當連線處於 TIME_WAIT 狀態時，無法重複使用通訊端配對。 這也稱為2MSL 狀態，因為此值應為網路上最大區段存留期的兩倍。 


|Age             | Time                                                                 |
|--------------- | ----                                                                 |
|Value			| TcpTimedWaitDelay														|
|資料類型        | REG_DWORD															|
|擊鍵			| HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters	|
|建議值			| 30																	|
|預設值			| 0x78 （120十進位）													|
