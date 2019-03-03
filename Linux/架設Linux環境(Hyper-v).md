
![](https://github.com/wdwd2233/Notes/blob/master/Linux/img/hyper-v.jpg?raw=true)


# 架設Linux環境

##### 1. 安裝 CentOS VM  [下載](https://www.centos.org/download/) 

##### 2. 安裝 WinSCP [免安裝](https://www.azofreeware.com/2008/03/winscp-41-beta.html)


## Hyper-v 新增虛擬機器

1. 新增虛擬交換器管 → 虛擬交換器管理員 → 建立虛擬交換器 → 建立外部

2. 新增虛擬機器

	1. 指定名稱和位置
		* 名稱: ceserver
		* 將虛擬機器存在不同位置: C:\Hyper-v
	2. 指定世代
		* 虛擬機世代: 第一代
	3. 指派記憶體
		* 啟動記憶體: 1024MB (使用動態記憶體)
	4. 設定網路功能
		* 連線: 外部網路
	5. 連接虛擬硬碟
		* 虛擬機名稱: ceserver.vhdx
		* 虛擬機位置: C:\Hyper-v\ceserver\
		* 虛擬機大小: 127G
	6. 安裝選項
		* 從可開機CD/DVD-ROM安裝作業系統
		* 映像檔(.iso檔): F:\PC軟件備份\CentOS-7-x86_64-Minimal-1810.iso
		
3. 安裝 CentOS 7

4. 虛擬機器連線 → 檔案 → 設定 → 網路介面卡 → 虛擬交換器: 外部網路

## Linux 設定

1. 選擇語言
	* 中文
	* 繁體中文(台灣)
2. 安裝目的地
	* Msft Virtual Disk
3. 開始安裝

4. 用戶設定
    * ROOT密碼: a
	* 用戶建立 
		* 使用者名稱 : rd
		* 密碼 : a
		* ☑ 讓這位使用者成為管理員



### Linux 設定內網

#### 查看網路位置
```javascript
cd /etc/sysconfig/network-scripts/
ls
```
##### 停用網路介面
```javascript
ifdown eth0
```
##### 啟動網路介面
```javascript
ifup eth0
```
##### 取得分配到的 IP 位置: 
```javascript
hostname -I
```

### Linux 安裝腳本

1. 複製安裝用的腳本
	* 使用WinSCP 將檔案傳進  /root/
	* ```javascript
		cd SetupScript
		chmod +x *.sh
		```
2. 執行設定內網 IP 的腳本
	* ```javascript
		./setup_network.sh
	  ```

### 執行設定內網 IP 的腳本
./setup_network.sh



ls      →檢查當前目錄下內容
ls -al    →檢視當前目錄位置及內容 

cd    	→回到根目錄
cd /etc →移動到目標目錄

cd (change directory, 變換目錄)
[root@study ~]# cd [相對路徑或絕對路徑]
# 最重要的就是目錄的絕對路徑與相對路徑，還有一些特殊目錄的符號囉！
[root@study ~]# cd /var/spool/mail
# 這個就是絕對路徑的寫法！直接指定要去的完整路徑名稱！
[root@study mail]# cd ../postfix
# 這個是相對路徑的寫法，我們由/var/spool/mail 去到/var/spool/postfix 就這樣寫！



pwd (顯示目前所在的目錄)
[root@study ~]# pwd [-P]
選項與參數：
-P  ：顯示出確實的路徑，而非使用連結 (link) 路徑。



mkdir (建立新目錄)
[root@study ~]# mkdir [-mp] 目錄名稱
選項與參數：
-m ：設定檔案的權限喔！直接設定，不需要看預設權限 (umask) 的臉色～
-p ：幫助你直接將所需要的目錄(包含上層目錄)遞迴建立起來！





將檔案變為可執行檔
chmod +x file
chgrp ：改變檔案所屬群組
chown ：改變檔案擁有者
chmod ：改變檔案的權限, SUID, SGID, SBIT等等的特性

[root@study ~]# chmod [-R] xyz 檔案或目錄
選項與參數：
xyz : 就是剛剛提到的數字類型的權限屬性，為 rwx 屬性數值的相加。
-R : 進行遞迴(recursive)的持續變更，亦即連同次目錄下的所有檔案都會變更

[root@study ~]# chgrp [-R] dirname/filename ...
選項與參數：
-R : 進行遞迴(recursive)的持續變更，亦即連同次目錄下的所有檔案、目錄
     都更新成為這個群組之意。常常用在變更某一目錄內所有的檔案之情況。
範例：
[root@study ~]# chgrp users initial-setup-ks.cfg

[root@study ~]# chown [-R] 帳號名稱 檔案或目錄
[root@study ~]# chown [-R] 帳號名稱:群組名稱 檔案或目錄
選項與參數：
-R : 進行遞迴(recursive)的持續變更，亦即連同次目錄下的所有檔案都變更

範例：將 initial-setup-ks.cfg 的擁有者改為bin這個帳號：
[root@study ~]# chown bin initial-setup-ks.cfg







目前有誰在線上
who

[root@study ~]# /sbin/shutdown [-krhc] [時間] [警告訊息]
選項與參數：
-k     ： 不要真的關機，只是發送警告訊息出去！
-r     ： 在將系統的服務停掉之後就重新開機(常用)
-h     ： 將系統的服務停掉後，立即關機。 (常用)
-c     ： 取消已經在進行的 shutdown 指令內容。
時間   ： 指定系統關機的時間！時間的範例底下會說明。若沒有這個項目，則預設 1 分鐘後自動進行。
範例：
[root@study ~]# /sbin/shutdown -h 10 'I will shutdown after 10 mins'



reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters" /f /v AllowEncryptionOracle /t REG_DWORD /d 2


cp
mv, 
rm, 
chmod
vi, 
grep