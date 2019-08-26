
# 利用tar備份linux系統詳解【轉】

備份Windows系統需要用Ghost，備份linux顯然要簡單的多，用tar命令就可以搞定。

### 用tar備份的特點：
* 保留權限
* 適合備份整個目錄
* 可以選擇不同的壓縮方式
* 如果選擇不壓縮還能實現增量備份，部份還原，參考man tar 

### 命令格式：
tar [- cxtzjvfpPN]壓縮文檔的名稱欲備份目錄

#### 參數：
* -c ：建立一個壓縮文件的參數指令(create的意思)；
* -x ：解開一個壓縮文件的參數指令！
* -t ：查看tarfile裡面的文件！
* `注意：在參數中，c/x/t僅能存在一個！不可同時存在！因為不可能同時壓縮與解壓縮。`
* -z ：是否同時具有gzip的屬性？亦即是否需要用gzip壓縮？
* -j ：是否同時具有bzip2的屬性？亦即是否需要用bzip2壓縮？
* -v ：壓縮的過程中顯示文件！這個常用，但不建議用在背景執行過程！
* -f ：使用檔名，請留意，在f之後要立即接檔名喔！不要再加參數！
* -p ：使用原文件的原來屬性（屬性不會依據使用者而變）
* -P ：（大寫）可以使用絕對路徑來壓縮！
* -N ：（大寫）比後面接的日期(yyyy/mm/dd)還要新的才會被打包進新建的文件中！
* -C：（大寫）目的目錄，即切換到指定的目錄
* --exclude FILE：在壓縮的過程中，不要將FILE打包！

###  linux下備份自身系統
####  1.備份
用root權限，運行完整的備份命令：
```shell
tar -cvpzf /root/tar/20190826.tar.gzip / 
--exclude=/root/tar/  \
--exclude=/proc  \
--exclude=/tmp  \
--exclude=/sys  \
--exclude=/home 
```
接著，讓我們稍微解釋一下：
* -cvpzf'	是我們給tar加的選項。
* /media/disk/backup.tgz	是壓縮包的存放路徑與名稱。
* /   		是我們想要備份的目錄，我們想要備份根目錄下的所有的東西，所以使用/作為根目錄。
* '- -exclude'	就是我們要剔除的目錄了，有些目錄是不需要備份的。
如：/proc目錄、 /tmp目錄、/sys目錄，裡面都是臨時文件，備份容易出錯，/home目錄備份容易引起"tar:由於前面延遲的錯誤而退出"的提示。
同時確保你沒有任何東西掛載在/mnt、/media目錄內，否則，會把被掛載的分區也備份在內，備份文件會很大。還要注意不要把備份文件本身也備份進去了，也需要剔除。

備份結束以後，在你的/root/tar/目錄下有一個20190826.tar.gzip，這就是備份文件。

####  2.恢復備份

慎用，將會把你目標路徑下的所有同名文件替換成壓縮文檔裡的文件，目標路徑下多出的目錄與文件並不會必刪除。

```shell
tar -xvpzf /root/tar/20190826.tar.gzip -C / 
```
> 參數x是告訴tar程序解壓縮備份文件。-C參數是指定tar程序解壓縮到的目錄。注：參數x是告訴tar程序解壓縮備份文件。-C參數是指定tar程序解壓縮到的目錄。

恢復完了以後，再手工建立如下一些目錄：
mkdir proc 
mkdir sys 
mkdir tmp 
重啟

####  3.linux下備份另一個linux系統

###### 1.備份
用root權限，運行完整的備份命令：

> 備份文件的存放路徑與名稱為/media/disk-1/backup.tgz 
只備份/meda/disk目錄內的內容，不含/media/disk路徑。
-C是臨時切換工作目錄，這樣就不把/media/disk路徑備份在壓縮包裡了。
備份時沒有剔除任何目錄，因為另一個linux沒有運行，裡面沒有臨時文件。
注意-C /media/disk的後面是空格加英文點。

######  2.還原：
建議先清空目標路徑下的除/boot目錄外的所有文件，再還原備份，命令如下：
rm -fv目錄名

還原/media/disk-1/backup.tgz壓縮包到/media/disk目錄下。
```shell
# tar -xvpzf /media/disk-1/backup.tgz -C /media/disk 
```
或：
```shell
# cd /media/disk 
# tar -xvpzf /media/disk-1/backup.tgz 
```