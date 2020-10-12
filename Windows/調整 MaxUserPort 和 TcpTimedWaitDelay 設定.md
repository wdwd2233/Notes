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

## 調整 TcpTimedWaitDelay 設定 [下載](https://github.com/wdwd2233/Notes/blob/master/Windows/file/TIME_WAITto30s.reg)

1. TcpTimedWaitDelay值會決定在關閉時，連接停留在 TIME_WAIT 狀態的時間長度。 
2. 當連線處於 TIME_WAIT 狀態時，無法重複使用通訊端配對。 這也稱為2MSL 狀態，因為此值應為網路上最大區段存留期的兩倍。 


|Age             | Time                                                                 |
|--------------- | ----                                                                 |
|Value    		| TcpTimedWaitDelay														|
|資料類型        | REG_DWORD															|
|擊鍵			| HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters	|
|建議值			| 30																	|
|預設值			| 0x78 （120十進位）													|
