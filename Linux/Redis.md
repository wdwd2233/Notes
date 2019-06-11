# Redis 

### Redis 優點
1. 基於內存記憶體。
2. 單線程 。


### 原子性
1. 在單線程中，能夠在單條指令中完成的操作都可以稱為"原子操作"，因為中斷只能發生在指令和指令中間。
2. 在多線程中，不能被其他線程打斷的操作也稱原子操作。

### 交易 Transaction
交易可以一次執行多個命令， 並且帶有以下幾點重要的保證：
1. 交易是一個單獨的隔離操作：交易中的所有命令都會序列化、按順序地執行。
2. 交易進行的過程中，不會被其他客戶端發送來的命令請求所打斷。
3. 交易中如果有一條執行失敗了，其他的命仍然會執行，沒有回滾。
4. 如果multi開始之後，如果有語法上的錯誤則`全部`交易都會被取消(原子性)。
 * ※ 交易的錯誤處理 : 如果交易某階段出錯了，則報錯的命令不會被執行，其他命令都會執行且不會回滾。


|--------指令--------	|------------------------------說明----------------------------------							 |---------備註---------						|
|:----------------------|:-----------------------------------------------------------------------------------------------|:---------------------------------------------|
|watch key [key ...]	|執行multi前先執行監試一個或多個key，<br />如果執行時發現這些key有被其他命令變更，則執行失敗	 |返回nil										|
|unwatch				|取消對所有key的監控																			 |exec、discard執行後<br />也會自動執行unwatch	|
|multi					|一個交易塊的開始。後續將使用EXEC命令執行排隊等待原子											 |												|
|exec					|執行所有先前排隊在一個交易中的命令，並恢複連接狀態正常											 |												|
|discard				|取消multi後的所有操作																			 |												|


##### 雙11 秒殺案例 練習
```js
ConsumerKey := "sk_Consumer_list"
countKey := "sk_Productid_qt"
userID := "123"

// 設定商品庫存量
a.client.Set(countKey, "100", 0)

	// Watch Key
	err := a.client.Watch(func(tx *redis.Tx) error {
		// 使用set 不能重複 將已購買過的ID加入 判斷是否購買過
		Consumer, _ := tx.SIsMember(ConsumerKey, userID).Result()
		if Consumer {
			fmt.Println("您已經購買過了!")
			// return
		}

		// 取得商品庫存量
		count := tx.Get(countKey)
		if count.Val() == "" {
			fmt.Println("商品ID 錯誤!")
			// return
		}
		if c, _ := count.Int(); c <= 0 {
			fmt.Println("此商品已售完!")
			// return
		}

		// Transaction
		_, err := tx.Pipelined(func(pipe redis.Pipeliner) error {
			// 將商品數量-1
			pipe.Decr(countKey)
			// 新增購買者清單
			pipe.SAdd(ConsumerKey, userID)

			return nil
		})
		if err != nil && err != redis.Nil {
			return err
		}
		return err
	}, countKey, ConsumerKey)

	if err == redis.TxFailedErr {
		fmt.Println("交易失敗")
	}
```


### Redis 命令
|-------------指令-------------|------------------------------說明---------------------------------- |--------備註-------- 			|
|:-----------------------------|:--------------------------------------------------------------------|:---------------------------------|
|select [index]			       |切換數據庫 (默認16個)				 								 |  				    			|
|keys *       			       |查詢所有的key       			     								 |  				    			|
|exists [key]      	   	       |判斷key是否存在       	     	 									 |  				    			|
|del [key]					   |刪除key 							 								 |					    			|
|type [key]					   |查看key類型						 									 |					    			|
|dbsize						   |查看當前數據庫Keys數量			 									 |					    			|
|Flushdb					   |清空`當前`數據庫					 							     |					    			|
|Flushall					   |清空`全部`數據庫					 								 |					    			|
|expire [key] [seconds]		   |設定過期時間						 								 |					    			|
|ttl [key]					   |查詢剩餘時間						 								 |-1(永遠不過期) <br> -2(已經過期)	|

LUA 腳本補充
1. 將複雜或多個步驟的redis操作寫成一個腳本，一次提交給redis執行，減少反覆連接redis次數。
2. LUA腳本類似redis交易，有一定的原子性，不會被其他命令插隊，可以完成redis的交易。
3. redis的LUA腳本只有在2.6以上的版本才能使用。 
4. 通過LUA腳本解決秒殺超賣商品的問題，實際上是redis利用單線程的特性與任務對列的方式解決併發問題。



### String																								
|-------------指令-------------	|------------------------------說明-------------------------------------  	| ---備註---						|
|:------------------------------|:--------------------------------------------------------------------------|:----------------------			|
|get [key]						|查詢對應的key																|									|
|set [key] [value]				|寫入對應的key value														|									|
|append [key] [value]			|將給定的value添加到原值得尾端												|									|
|strlen [key]					|取得key值得長度															|									|
|setnx [key] [value]			|只有在key不存在時才添加此key												|									|
|incr [key]						|將key的數值+1，如果為空則新增值為1。										|只能對數字操作						|
|decr [key]						|將key的數值-1，如果為空則新增值為-1。										|只能對數字操作						|
|incrby	[key] [increment] 		|將key的數值定義長度的增加。												|									|
|decrby [key] [increment]		|將key的數值定義長度的減少。												|									|
|mset [key1][value1] .... 		|同時設置一個或多個key-value。												|									|
|mget [key1][value1] ....		|同時讀取一個或多個key-value。												|									|
|msetnx [key1][value1] ....		|同時設置一個或多個key-value <br />輸入的key全部都不存在時才會成功。		|單線原子性							|
|getrange [key] [range][range] 	|取得value 開始到結束字符串位置 <br />功能相似Substring，(0,-1)取到最後、(0,-2)取到倒數第二。|					|
|setrange [key] [offset] [value]|在指定的範圍內覆蓋掉原本的內容。											|									|
|setex [key] [second] [value]	|設定key時同時給定過期時間。												|重新寫入value<br /> 會取消過期時間	|
|getset [key][value]			|以新換舊，設定新值的同時返回舊值。											|									|



### List
1. 簡單字符串列表，按照插入順序排序。

|-------------指令-------------			|------------------------------說明----------------------------------	|---備註---			|
|:--------------------------------------|:----------------------------------------------------------------------|:-----			 	|
|lpush  [key][value].... 				|從左邊插入一個或多個值。				  								|					|
|rpush [key][value]....					|從右邊插入一個或多個值。 												|					|
|lpop [key]								|從左邊取出一個值(如果值取光了key也會消失)。							|					|
|rpop [key]								|從右邊取出一個值(如果值取光了key也會消失)。							|					|	
|ropolpush [key1][key2]					|從key1列表右邊取出值，插入key2列表左邊。								|					|
|lrange [key] [start] [stop] 			|按照索引獲取元素(從左到右)，取全部(lrange key 0 -1)(排序)。			|					|
|lindex [key] [index]					|按照索引下標獲得元素。													|從左到右			|
|llen [key]								|獲取列表長度。															|					|
|linsert [key] after [value][new value]	|在[value]前面插入[new value]的值。								|					|
|linsert [key] before [value][new value]|在[value]後面插入[new value]的值。								|					|
|lrem [key][n][value]					|從左邊刪除n個value(n:為負數則從右邊刪)<br />(n:為0的時候將列表中符合value的值全部刪除)。|	|



### set
1. 功能類似list，會自動排除重複，可以判斷元素是否在列表中。
2. Redis的set是string類型的`無序集合`，底層其實是一個value為nil的hash表，所以添加、刪除、查詢的複雜度都是O(1)。

|------------指令------------	|------------------------------說明---------------------------------- 	|--------備註--------		|
|:------------------------------|:----------------------------------------------------------------------|:--------------------------|
|sadd [key] [value1] [value2]	|將一個或多個member元素加到集合的key中，<br />已經存在於集合的member元素會自動被忽略。|				|
|smembers [key]					|取出該集合的所有值。													|							|
|sismember [key][value]			|判斷該key 是否含有該value。											|返回1(有)、0(沒有)			|
|scard [key]					|返回該集合元素的個數。													|							|
|srem [key][value1][value2]		|刪除集合中的某個元素。													|							|
|spop [key]						|隨機從該集合中吐出一個值。												|							|
|srandmember [key] [n]			|隨機從該集合中吐出一個值，並且不會從該集合中刪除。						|							|
|sinter [key1][key2]			|返回兩個集合共同有的元素。												|							|
|sunion [key1][key2]			|返回兩個集合的元素，如果兩個集合有重複的則顯示一個。					|key1保留<br />key2比較用的	|
|sdiff [key1][key2]				|將key1比較key2內是否有一樣的value，返回不重複的值。					|							|




### hash
1. Redis hash 是一個建值得集合。
2. Redis hash 是一個string類型的field(屬性標籤)和value的映射表，hash特別適合用於儲存對象。
3. 類似java裡面的map<string,object>

|------------------指令------------------		|-------------------------說明-------------------------	|------備註------	|
|:----------------------------------------------|:------------------------------------------------------|:------------------|
|hset [key1][field][value]						|給key集合中的fiekd賦值value。							|					|
|hget [key][field]								|從key集合的field取出value。							|					|
|hmset [key] [field1][value1] [field2][value2] 	|批量設置hash的值。										|					|	
|hexists [key] [field]							|查看field是否存在key內。								|					|
|hkeys [key]									|列出該hash內所有的field。								|					|
|hvals [key]									|列出該hash內所有value。								|					|
|hincrby [key][field][increment]				|為hash內的field新增數量(int)							|					|
|hsetnx [key][field][value]						|將hash中插入一個[field][value]<br />※如果field不存在才成功，反之則失敗。|	|


### zset
1. 有序集合

|-----------------指令-----------------										|---------------------------說明--------------------------- 									|-------備註-------	|
|---------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------|:------------------|
|zadd [key] [score1] [value1]....											|將一個或多個score和value添加到有序集的key中。													|					|
|zrange [key] [start][stop] <br />[withscores]|返回有序集key中，下標在[start][stop]，<br /> 帶withscores可以讓分數一起返回。												|					|
|zrangebyscore [key] [min] [max] <br />[withscores][limit offset count]		|返回有序集key中，所有score介於min和max之間<br /> (包刮min、max)的值按照score值有小到大排列。	|					|
|zrevrangbyscore [key] [max] [min] <br />[withscores][limit offset count]	|返回有序集key中，所有score介於min和max之間<br /> (包刮min、max)的值按照score值有大到小排列。	|					|
|zincrby [key][increment][value]											|為元素的score增加數量(int)。																	|					|
|zrem [key][value]															|刪除該集合下，指定值的元素。																	|					|
|zcount [key][min][max]														|統計該集合分數區間內的元素數量。																|					|
|zrank [key][value]															|返回該值在元素中的排名。																		|					|



### redis.conf 設定

##### 1. 外部連接Redis

1. 打開防火牆 預設 `port 6379` 
2. 註解掉 `bind 127.0.0.1`，讓所有IP都能連(或新增特定IP)
3. 將protected-mode 改為 `no` 

##### 2. Redis 持久化

1. RDB   (Redis Database)

	1. 在指定的時間間隔內將內存中的數據集快照寫入磁盤，它恢復時是將快照文件直接讀到內存裡，<br/>
		Redis會建立(fork)一個子進程來進行持久化，先將數據寫入到一個臨時文件中，待持久化過程都結束了，
		再用這個臨時文件替換上次持久化好的文件。

		* RDB過程中主進程是不進行任何IO操作的，確保了極高的性能。
		* 進行大規模數據的恢復，且對於數據恢復的完整性不是非常敏感，那RDB方式要比AOF方式更加的高效。 
		* RDB 保存的是 dump.rdb文件
	
	2. 配置 SNAPSHOTTING
	
		1. 儲存規則:<br/>
			900秒內，如果至少增刪改了1個key，會自動保存，產生dump.rdb文件。<br/>
			300秒內，如果至少改變了10個key，會自動保存，產生dump.rdb文件。<br/>
			60秒內，如果至少改變了10000個key，會自動保存，產生dump.rdb文件。<br/>
			```javascript
			save 900 1
			save 300 10
			save 60 10000
			```
			* shutdown 會自動執行save
		2. stop-writes-on-bgsave-error：後台save出錯，那麼就停止寫入，出錯就直接停止寫的操作。
		3. rdbcompression：是否啟用壓縮保存，默認開啟。
		4. rdbchecksum：數據使用CRC64進行數據校驗，增加10%性能損耗。
		5. dbfilename dump.rdb : 默認存檔檔名
		5. dir ./ : .rdb和.aof檔案存放位置
		
	
2. AOF( Append of File)

	1. 記錄操作者的所有寫操作，數據恢復的時候，把所有寫操作執行一遍，<br/>
		以日誌的形式來記錄每個`寫入操作`，將Redis執行過的所有寫指令記錄下來(讀取操作不記錄)，
		只許追加文件但不可以改寫文件，redis重啟的話就根據日誌文件的內容，將寫指令從頭到尾執行一次以完成數據的恢復工作。
		
		* AOF默認關閉，需要手動在配置文中打開
		* AOF保存的是appendonly.aof文件
		* AOF和RDB同時開啟時，redis默認讀AOF(因為AOF保存間格較短)
		* 資料不會被壓縮，內容可辨識但無法透過file編輯修改
		* 比起RDB，檔案更大，恢復時間較久
		* 官方不建議單獨使用AOF，因為可能發生bug造數據無法恢復，建議兩個都使用
	
	2. 配置 APPEND ONLY MODE
	
		1. 同步規則 appendfsync
			* appendfsync always：同步持久化，每次發生數據變更會被立即記錄到磁盤，性能較差，但數據完整性比較好
			* appendfsync everysec：出廠默認推薦，異步操作，每秒記錄，如果一秒內宕機，有數據丟失
			* appendfsync no：從不同步，默認關閉
		2. appendfilename "appendonly.aof" : 默認存檔檔名。
		3. no-appendfsync-on-rewrite no : yes不會延遲但可能丟失少量的數據 NO對IO的讀寫可能會延遲但資料不會丟失(阻塞式寫入)。
		4. auto-aof-rewrite-percentage 100 :  aof檔案重寫機制，比上一次多寫文件多了100%才重寫
		5. auto-aof-rewrite-min-size 64mb :  aof檔案重寫機制，文件大於64mb才重寫
		6. aof-load-truncated yes : 恢復數據時，會忽略最後一條可能存在問題的指令。yes即在aof寫入時，可能存在指令寫錯的問題(突然斷電，寫了一半)，這種情況下，yes會log並繼續，而no會直接恢復失敗.
	
	3. 指令
	
		1. bgrewriteaof : 異步執行一個AOF文件重寫操作，可以把文件體積縮小。
		
##### 3. Redis Master-Slave

1. Master以寫入為主，Slave讀取為主。
	
	
2. 配置內容:

	* Slave連線後會將原本Master的資料完整複製過來(Slave原本的資料會清空)
	* 如果Slave有斷線，在重新連線後會自動將Master的資料複製過來
	* Slave還可以在接Slave
	* redis主從同步版本必須一致，不一致的話同步過程中會出現各種奇葩問題！
	
	1. Master 設定
		* daemonize yes  : 背景執行 (windows 不支持)
		* appendonly no : 關掉AOF設定(或者改名子)
	2. Slave 設定
		* include redis.master.conf : 要包含的主要配置文件
		* pidfile /var/run/redis.pid : (windows 不支持) 
		* port 6379 : 指定個別的port
		* dbfilename dump.rdb : 個別的備份檔
		* slaveof 127.0.0.1 6379 : 建立從集
		
	3. 指令
		* info replication : 查看主從訊息
		* slaveof no one : 取消Slave，將此改成Master
		
	4. 主從同步原理:<br/>
		1. 每次從機連通後，都會給主機發送sync指令
		2. 主機立刻進行存盤操作，發送RDB文件，給從機
		3. 從機收到RDB文件後，進行全盤加載
		4. 之後每次主機的寫操作，都會立刻發送給從機，從機執行相同的命令
		
	5. 去中心化:<br/>
		1. 上一個Slave可以是下一個slave的Master
		2. Slave同樣可以接收其他slave的連接和同步請求
		3. Slave作為了鏈條中下一個的master,可以有效減輕master的寫壓力
		* 缺點 : 鏈中的Slave掛掉，下面的Slave全部都無法讀取
		
##### 4. Redis-Sentinel 哨兵機制

1. 

2. 配置內容:

	1. sentinel.conf 
		* port 26379 : 默認port 26379
		* daemonize yes : 
		* sentinel monitor my-master 127.0.0.1 6390 1 : 至少需要幾個 sentinel 同意，master_6379 才算失效，自動 failover。
		* sentinel down-after-milliseconds master 1000 : 少毫秒數內沒有回應，master_6379 就算失效。
		* sentinel parallel-syncs master 1 : 當 failover 發生時，最多可以有多少個 slave 從新的 master 同步資料。
		* sentinel failover-timeout master 1000 : 多少毫秒數內沒有 failover 成功，就算 failover 失敗。
	2. 指令
		* redis-server.exe conf\sentinel.conf --sentinel  : 啟動sentinel (windows 版)
		* redis-sentinel conf\sentinel.conf : 啟動sentinel (Linux版)
		* info sentinel : 查看Sentinel訊息
		
3.	原理
	
	1. Master crash之後會去判斷slave-priority優先級來決定誰接手master
		* 0則是永遠不會當作master
		* 數字越小優先級越高
		* priority相等會以數據較完整的當作master
		* 找集群RunID最小的優先
		
##### 5. Redis-Cluster 集群機制 

1. Redis-Cluster實現了水平擴充，會啟動N個redis節點，將整個數據分布存放於N個節點中，每個節點存放總數據的1/N
	Redis-Cluster透過分區(partition)提供了一定的可用度，即使集群中有一部份節點失效，集群還是可以繼續執行

2. 環境 
	* 下載[https://rubyinstaller.org/downloads/]
	* 集群環境為 三個Master及三個Slave
	

3. 配置內容:
	1. conf
		* cluster-enabled yes : 開啟集群模式
		* cluster-config-file nodes-6390.conf : 設定節點配置文件名稱
		* cluster-node-timeout 15000 : 設定節點失效超過(毫秒)，集群自動進行Master-Slave切換
		* appendonly yes :
	2. 指令
		* redis-trib.rb create -- replicas 1 [ip][ip][ip] [ip][ip][ip] :真實IP位址(不能127.0.0.1)