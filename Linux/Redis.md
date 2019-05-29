# Redis 

### Redis 速度快原因
1. 基於內存記憶體。
2. 單線程 。(優先級線程調度(mac不支持)、模型簡單、不易出錯、多路IO複用)

#####  補充
 * BIO: 一次線程連接 一個線程。
 * NIO: 一次數據請求 一個線程。
 * AIO: 一次有效請求 一個線程。



### 原子性:(redis為單線程)
1. 在單線程中，能夠在單條指令中完成的操作都可以稱為"原子操作"，因為中斷只能發生在指令和指令中間。
2. 在多線程中，不能被其他線程打斷的操作也稱原子操作。

### 交易 Transaction
交易可以一次執行多個命令， 並且帶有以下幾點重要的保證：
1. 交易是一個單獨的隔離操作：交易中的所有命令都會序列化、按順序地執行。
2. 交易進行的過程中，不會被其他客戶端發送來的命令請求所打斷。
3. 不是原子性，同一個交易中如果有一條執行失敗了，其他的命仍然會執行，沒有回滾。
4. 如果multi開始之後，有語法上的錯誤則`全部`交易都會被取消 (原子性)。
 * ※ 交易的錯誤處理 : 如果交易某階段出錯了，則報錯的命令不會被執行，其他命令都會執行且不會回滾。

|--------指令--------	|------------------------------說明----------------------------------							 |---------備註---------						|
|:----------------------|:-----------------------------------------------------------------------------------------------|:---------------------------------------------|
|watch key [key ...]	|執行multi前先執行監試一個或多個key，<br />如果執行時發現這些key有被其他命令變更，則執行失敗	 |返回nil										|
|unwatch				|取消對所有key的監控																			 |exec、discard執行後<br />也會自動執行unwatch	|
|multi					|一個交易塊的開始。後續將使用EXEC命令執行排隊等待原子											 |												|
|exec					|執行所有先前排隊在一個交易中的命令，並恢複連接狀態正常											 |												|
|discard				|取消multi後的所有操作																			 |												|

雙11 秒殺案例 練習
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
|-------------指令-------------|------------------------------說明---------------------------------- |--------備註--------|
|:--------------------------   |:---------------------------------									 |:-----			   |
|select [index]			       |切換數據庫 (默認16個)				 								 |  				   |
|keys *       			       |查詢所有的key       			     								 |  				   |
|exists [key]      	   	       |判斷key是否存在       	     	 									 |  				   |
|del [key]					   |刪除key 							 								 |					   |
|type [key]					   |查看key類型						 									 |					   |
|dbsize						   |查看當前數據庫Keys數量			 									 |					   |
|Flushdb					   |清空當前數據庫					 									 |					   |
|Flushall					   |清空全部數據庫					 									 |					   |
|expire [key] [seconds]		   |設定 過期時間						 								 |					   |
|ttl [key]					   |查詢 剩餘時間						 								 |-1(永遠不過期) <br> -2(已經過期)|

LUA 腳本補充
1. 將複雜或多個步驟的redis操作寫成一個腳本，一次提交給redis執行，減少反覆連接redis次數。
2. LUA腳本類似redis交易，有一定的原子性，不會被其他命令插隊，可以完成redis的交易。
3. redis的LUA腳本只有在2.6以上的版本才能使用。 
4. 通過LUA腳本解決秒殺超賣商品的問題，實際上是redis利用單線程的特性與任務對列的方式解決併發問題。



## String																								
|-------------指令-------------	|------------------------------說明-------------------------------------  	| ---備註---			|
|:-------------------------- 	|:---------------------------------									      	|:-----			 		|
|get [key]|查詢對應的key		|																			|						|
|set [key] [value]				|寫入對應的key value														|						|
|append [key] [value]			|將給定的value添加到原值得尾端												|						|
|strlen [key]					|取得key值得長度															|						|
|setnx [key] [value]			|只有在key不存在時才添加此key												|						|
|incr [key]						|將key的數值+1，只能對數字操作，如果為空則新增值為1。						|						|
|decr [key]						|將key的數值-1，只能對數字操作，如果為空則新增值為-1。						|						|
|incrby[key]  <br /> decrby [key] [步長]|將key的數值定義長度的增減。(一次增加或減少多少)					|						|
|mset [key1][value1] .... 		|同時設置一個或多個key-value。												|						|
|mget [key1][value1] ....		|同時讀取一個或多個key-value。												|						|
|msetnx [key1][value1] ....		|同時設置一個或多個key-value <br />輸入的key全部都不存在時才會成功(單線原子性)。|					|
|getrange [key] [range][range] 	|取得value 開始到結束字符串位置 <br />功能相似Substring(0,10)，(0,-1)取到最後、(0,-2)取到倒數第二。||
|setrange [key] [偏移量] [value]|在指定的範圍內覆蓋掉原本的內容。											|						|
|setex [key] [second] [value]	|設定key時同時給定過期時間(如果重新寫入value，會取消過期時間)。				|						|
|getset [key][value]			|以新換舊，設定新值的同時返回舊值。											|						|








## List
1. 簡單字符串列表，按照插入順序排序。

|-------------指令-------------	|------------------------------說明----------------------------------	|---備註---			|
|:--------------------------  	|:---------------------------------										|:-----			 	|
|lpush  [key][value].... 		|從左邊(lpush)插入一個或多個值。				  						|					|
|rpush [key][value]....			|從右邊(rpush)插入一個或多個值。 										|					|
|lpop [key]						|從左邊(lpop)取出一個值(如果值取光了key也會消失)。						|					|
|lpop [key]						|從右邊(rpop)取出一個值(如果值取光了key也會消失)。						|					|	
|ropolpush [key1][key2]			|從key1列表右邊取出值，插入key2列表左邊。								|					|
|lrange [key] [start] [stop] 	|按照索引獲取元素(從左到右)，取全部(lrange key 0 -1)(排序)。			|					|
|lindex [key] [index]			|按照索引下標獲得元素(從左到右)。										|					|
|llen [key]						|獲取列表長度。															|					|
|linsert [key] after [value][new value]	|在[value]前面插入[new value]的值。								|					|
|linsert [key] before [value][new value]|在[value]後面插入[new value]的值。								|					|
|lrem [key][n][value]			|從左邊刪除n個value(n:為負數則從右邊刪)<br />(n:為0的時候將列表中符合value的值全部刪除)。|	|



## set
1. 功能類似list，會自動排除重複，可以判斷元素是否在列表中。
2. Redis的set是string類型的`無序集合`，底層其實是一個value為nil的hash表，所以添加、刪除、查詢的複雜度都是O(1)。

|------------指令------------	|------------------------------說明---------------------------------- 	|--------備註--------		|
|:------------------------------|:----------------------------------------------------------------------|:--------------------------|
|sadd [key] [value1] [value2]	|將一個或多個member元素加到集合的key中，<br />已經存在於集合的member元素會自動被忽略。|				|
|smembers [key]					|取出該集合的所有值。													|							|
|sismember [key][value]			|判斷該key 是否含有該value，返回1(有)、0(沒有)。						|							|
|scard [key]					|返回該集合元素的個數。													|							|
|srem [key][value1][value2]		|刪除集合中的某個元素。													|							|
|spop [key]						|隨機從該集合中吐出一個值。												|							|
|srandmember [key] [n]			|隨機從該集合中吐出一個值，並且不會從該集合中刪除。						|							|
|sinter [key1][key2]			|返回兩個集合共同有的元素。												|							|
|sunion [key1][key2]			|返回兩個集合的元素，如果兩個集合有重複的則顯示一個。					|key1保留<br />key2比較用的	|
|sdiff [key1][key2]				|將key1比較key2內是否有一樣的value，返回不重複的值。					|							|




## hash
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


## zset
1. 有序集合

|---------------------指令---------------------|----------------------說明---------------------- |--------備註--------|
| --------------------------   		|:---------------------------------									 |:-----			   |
|zadd [key] [score1] [value1]....	|將一個或多個score和value添加到有序集的key中。||
|zrange [key] [start][stop] <br /> [withscores]|返回有序集key中，下標在[start][stop]，<br /> 帶withscores可以讓分數一起返回。||
|zrangebyscore [key] [min] [max] <br /> [withscores][limit offset count]|返回有序集key中，所有score介於min和max之間<br /> (包刮min、max)的值按照score值有小到大排列。||
|zrevrangbyscore [key] [max] [min] <br /> [withscores][limit offset count]|返回有序集key中，所有score介於min和max之間<br /> (包刮min、max)的值按照score值有大到小排列。||
|zincrby [key][increment][value]|為元素的score增加數量(int)。||
|zrem [key][value]|刪除該集合下，指定值的元素。||
|zcount [key][min][max]|統計該集合分數區間內的元素數量。||
|zrank [key][value]|返回該值在元素中的排名。||














