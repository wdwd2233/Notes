# mongoDB 

### mongoDB 優點

下載 :  Windows <https://www.mongodb.com/download-center/community>

		免安裝 <https://www.mongodb.org/dl/win32>	雙數版(穩定版)、基數版(開發版)

### 安裝 

* 設定環境變量 : `D:\mongodb_server\mongodb-v3.6\bin` (安裝版)

  + 建立DB文件夾 `D:\mongodb_server\db` (建立db資料夾) 
  + 建立log文件夾 `D:\mongodb_server\log` (建立log資料夾) 
  + 移動到至目錄 `D:\mongodb_server\mongodb-v3.6\bin` 
  + 啟動mongodb 服務器 `mongod.exe --dbpath=../../db --config=../mongodb.cfg --port=27017` 

  

* 設置系統服務

  + 創建配置文件 `mongodb.cfg` 
    - 檔案格式 : MongoDB 2.6引入了基於YAML的配置檔案格式，MongoDB配置檔案使用YAML格式，YAML不支援縮排的製表符：使用空格。
    - 配置說明 : MongoDB-配置翻譯 <https://www.itread01.com/content/1545663639.html>

``` js
systemLog:
    destination: file
path: "D:\\mongodb_server\\log\\mongodb.log"
logAppend: true
storage:
    dbPath: "D:\\mongodb_server\\db"
directoryPerDB: true
net:
    port: 27017
bindIp: 127.0 .0 .1
processManagement:
    windowsService:
    serviceName: MongoDB27017
displayName: MongoDB27017
```

  + 新增windows 服務 `sc.exe create MongoDB binPath= "\"D:\mongodb_server\mongodb-v3.6\bin\mongod.exe\" --service --config=\"D:\mongodb_server\mongodb-v3.6\mongodb.cfg\"" DisplayName= "MongoDB" start= "auto"` 
  + 啟動 `net start MongoDB` 
  + 停止 `net stop MongoDB` 
  + 刪除windows 服務 `sc delete MongoDB` 

### 數據操作

  + 啟動mongodb cli `mongo` ，會出現 > 表示成功

##### 基本指令 

 - show dbs : 顯示當前所有數據庫
 - use [database] : 進入指定數據庫
 - db : 當前的數據庫