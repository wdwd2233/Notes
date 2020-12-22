# RabbitMQ 安裝在 Windows

![RabbitMQ](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWnU9CBzwzPvZk5-VTu3ZKYC76BIQ9Q9aX9g&usqp=CAU)


**前言**


* RabbitMQ是一個開源的,基於AMQP(Advanced Message Queuing Protocol)協議的完整的可複用的企業級訊息隊,RabbitMQ可以實現點對點,釋出訂閱等訊息處理模式。

* RabbitMQ是一個開源的AMQP實現,伺服器端用Erlang語言編寫，支援Linux,windows,macOS,FreeBSD等作業系統,同時也支援很多語言,如：Python,Java,Ruby,PHP,C#,JavaScript,Go,Elixir,Objective-C,Swift等。


## 注意事項

- 首先，安裝 RabbitMQ 要先注意他的語言環境`Erlang`。
- RabbitMQ 是在 `Erlang` 環境下執行的，所以一定要先讀一下 [RabbitMQ Erlang Version Requirements](https://www.rabbitmq.com/which-erlang.html "RabbitMQ Erlang Version Requirements")。


### 安裝 Erlang

1. 下載  [Erlang ](https://www.erlang.org/downloads)  `OTP 23.2 Windows 64-bit Binary File` 。

2. 設置環境變數 變數名稱:`ERLANG_HOME ` 變數值:`C:\Program Files\erl-23.2`

3. 設置系統變數 變數名稱:`Path` 變數值:`%ERLANG_HOME%\bin`

### 安裝 RabbitMQ 

1. 下載  [RabbitMQ ](https://www.rabbitmq.com/install-windows.html)  `rabbitmq-server-3.8.9.exe` 。

2. 設置 RabbitMQ Management Portal
 1. 進到 RabbitMQ 資料夾中的 sbin 資料夾
 
 2. 看到 rabbitmq-plugins.bat，設置一下 RabbitMQ 的套件
 
 3. Cmder 移動到 `C:\Program Files\RabbitMQ Server\rabbitmq_server-3.8.9\sbin` (當前版本)
 
 4. Cmder 執行 `.\rabbitmq-plugins.bat enable rabbitmq_management`
 
 5. 啟動 RabbitMQ Server `.\rabbitmq-server.bat`

3. 如何登入 Management Portal
 1. 啟動 RabbitMQ Server 之後，打開瀏覽器，輸入 http://localhost:15672 即可看到登入畫面，
 
 2. RabbitMQ 預設帳號:guest 預設密碼:guest
