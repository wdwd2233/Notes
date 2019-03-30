
![SQL server](https://github.com/wdwd2233/Notes/blob/master/Windows/img/MicrosoftSQLServer2016.jpg?raw=true)

1. SQL Server 2016 組態管理員

	1. SQL Server 服務
		* MSSQLSERVER(MSSQLSERVER) 啟動
		* MSSQLSERVER 啟動
		![Setting](https://github.com/wdwd2233/Notes/blob/master/Windows/img/SQLConnection.png?raw=true)
	2. SQL Server 服務組態
		* MSSQLSERVER的通訊協定 → TCP/IP 已啟用
		![Setting](https://github.com/wdwd2233/Notes/blob/master/Windows/img/SQLConnection%20(2).png?raw=true)
		
2. Microsoft SQL Server Management Studio 

	1. 伺服器屬性
		* 安全性 
			* 伺服器驗證 SQL server 及 Windows 驗證模式 
			![Setting](https://github.com/wdwd2233/Notes/blob/master/Windows/img/SQLConnection%20(3).png?raw=true)
		* 連線
			* 允許此伺服器的遠端連線
			![Setting](https://github.com/wdwd2233/Notes/blob/master/Windows/img/SQLConnection%20(4).png?raw=true)

3. Windows 防火牆 

	1. 防火牆 輸入規則
		* 新增規則 → 連接埠 → TCP 特定本機連接埠 1433 
		![Setting](https://github.com/wdwd2233/Notes/blob/master/Windows/img/SQLConnection%20(5).png?raw=true)
		
連線字串 220.134.132.97,1433 