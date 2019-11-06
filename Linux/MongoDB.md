# mongoDB 

### mongoDB 優點

下載 :  Windows <https://www.mongodb.com/download-center/community>

		免安裝 <https://www.mongodb.org/dl/win32>	雙數版(穩定版)、基數版(開發版)

 * 數據庫的集合會自動創建。

### 安裝 

* 設定環境變量 : `D:\mongodb_server\mongodb-v3.6\bin` (安裝版)

  + 建立DB文件夾 `D:\mongodb_server\db` (建立db資料夾) 
  + 建立log文件夾 `D:\mongodb_server\log` (建立log資料夾) 
  + 移動到至目錄 `D:\mongodb_server\mongodb-v3.6\bin` 
  + 啟動mongodb 服務器 `mongod.exe --dbpath=../../db --config=../mongodb.cfg --port=27017` 

* NoSQL Manager for MongoDB GUI tool <https://www.mongodbmanager.com/>

 + MongoDB的圖形介面管理軟體 
 + 全功能整合GUI
 + 容易去使用document觀察
 + 容易操作與管理MongoDB物件
 + 以SSH通道連接MongoDB
 + Map-Reduce操作編輯
 + 多台Mongo host/database 連線

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
 - show collections : 顯示數據庫中所有的集合

##### CRUD 操作

 * Create（新增）

    - db.stus.insertOne({name:"孫悟空",age:18,gender:"男生"}) : 像集合[stus]內插入一個[{name:"孫悟空",age:18,gender:"男生"}]

    - 

 * Read（讀取）

    - db.stus.find() : 查詢集合[stus]中所有的文檔。

 
 * Update（更新） 
 * Delete（刪除）

