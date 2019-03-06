
![](https://github.com/wdwd2233/Notes/blob/master/Windows/img/XAMPP.png?raw=true)


# XAMPP環境

###  1. XAMPP [下載](https://www.apachefriends.org/zh_tw/index.html)

###  2. XAMPP安裝

1. 警告視窗：預設安裝到C:\XAMPP資料夾中

![XAMPP](https://github.com/wdwd2233/Notes/blob/master/Windows/img/XAMPP%20(1).JPG?raw=true)


2. [Next]

![XAMPP](https://github.com/wdwd2233/Notes/blob/master/Windows/img/XAMPP%20(1).png?raw=true)


3. 選擇要安裝的套件

![XAMPP](https://github.com/wdwd2233/Notes/blob/master/Windows/img/XAMPP%20(2).png?raw=true)


4. 要安裝的資料夾，接受預設的C:\XAMPP資料夾

![XAMPP](https://github.com/wdwd2233/Notes/blob/master/Windows/img/XAMPP%20(3).png?raw=true)


5. 問你想不想知道更多XAMPP的訊息(取消)

![XAMPP](https://github.com/wdwd2233/Notes/blob/master/Windows/img/XAMPP%20(4).png?raw=true)

6. [Next]開始跑進度條

![XAMPP](https://github.com/wdwd2233/Notes/blob/master/Windows/img/XAMPP%20(5).png?raw=true)




## 更改 Apache 預設的根目錄

1. 首先還是先打開 XAMPP 的控制台，點一下在 Apache 那行的按鈕 Config 選擇 “Apache (httpd.conf)”

![XAMPP](https://github.com/wdwd2233/Notes/blob/master/Windows/img/XAMPP%20(6).png?raw=true)

2. 這時候會自動打開一個文件編輯器，然後進行修改：CTRL + F 尋找關鍵字 -> htdocs

* 注意的是 “DocumentRoot” & “<Directory “*:/xampp/htdocs”>” 要同時修改。

![XAMPP](https://github.com/wdwd2233/Notes/blob/master/Windows/img/XAMPP%20(7).png?raw=true)