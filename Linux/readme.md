
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
		* 虛擬機位置: C:\Hyper-v\ceserver\Virtual Hard Disks\
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

##### 1. 複製安裝用的腳本

1. 使用WinSCP 將檔案傳進  /root/
	
```javascript
cd SetupScript
chmod +x *.sh
```
		
##### 2. 執行設定內網 IP 的腳本
```javascript
./setup_network.sh
```


##### 3.安裝系統工具

```javascript
./install_systool.sh
```

1. 系統工具
	1. samba
	2. rsync
	3. docker


##### 4. 安裝 git
```javascript
./install_git.sh
```
1. git工具	
	1. git client
	2. docker gitlab/gitlab-ce
2. 手動在 C:\WINDOWS\system32\drivers\etc\hosts 加入 $git_server_ip git.ce.com.tw
3. 更改密碼
	1. 設定 root 密碼 (8 碼)
	2. Sign in: root 確認登入
	
	
##### 5. 安裝 MySQL
```javascript
./create_container
```
安裝 2 , 1 

