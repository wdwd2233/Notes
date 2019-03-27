

![](https://github.com/wdwd2233/Notes/blob/master/Linux/img/ELK.png?raw=true)


# 安裝
[========]
### 1. [Java](https://javadl.oracle.com/webapps/download/AutoDL?BundleId=236877_42970487e3af4f5aa5bca3f542482c60) (jre-8u201-linux-x64.rpm)
 1. 因為 Elasticsearch 及 Logstash 是用 Java 開發，所以要安裝 JVM，下載後透過 WinSCP 放到 /tmp/，執行以下指令安裝：
 2.
	```javascript
	yum -y install java-1.8.0-openjdk-devel java-1.8.0-openjdk
	```
	
[========]
### 2. [Elasticsearch](https://www.elastic.co/downloads/elasticsearch) (elasticsearch-6.6.1.rpm)
 1. Elasticsearch 是搜尋引擎，就像是資料庫，把收集到的 Log 存在這裡，下載後透過 WinSCP 放到 /tmp/，執行以下指令安裝：
	```javascript
	wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.6.2.rpm
	yum -y install elasticsearch-*.rpm
	```
 2. 安裝好後，執行以下指令啟動: 
	```javascript
	systemctl start elasticsearch
	```
 3. 查看狀態：
 	```javascript
	systemctl status elasticsearch
	curl "http://localhost:9200/_cat/nodes"
	```
 4. 設定記憶體
	```javascript
	vi /etc/elasticsearch/jvm.options
	```
	找到以下兩個設定值，都改為 1g：
	# Xms 記憶體使用下限
	# Xmx 記憶體使用上限
	-Xms1g
	-Xmx1g
 5. 設定 Elasticsearch 綁定的 IP 及 Port
 	```javascript
	vi /etc/elasticsearch/elasticsearch.yml
	```
	* 綁定特定 IP
	* network.bind_host: 192.168.56.101
	* 綁定多個 IP
	* network.host: ["192.168.56.101", "127.0.0.1"]
	* 綁定所有 IP
	* network.bind_host: 0.0.0.0
	* 綁定 Port，預設其實就是 9200
	* http.port: 9200
 6. 設定完成後，重新啟動：
  	```javascript
	systemctl restart elasticsearch
	```
 7. 試試看用 IP 查詢 nodes
   	```javascript
	curl "http://10.40.0.55:9200/_cat/nodes"
	```
 8. 防火牆
	* 完全關閉
     ```javascript
	systemctl stop firewalld
	systemctl disable firewalld
	```
	* 增加防火牆規則
     ```javascript
	firewall-cmd --add-service=elasticsearch --permanent
	firewall-cmd --reload
	```
	
[========]
### 3. [Logstash](https://www.elastic.co/downloads/kibana)(kibana-6.6.1-x86_64.rpm)

1. Logstash 主要的工作是把收到的資料，做特定的規則處理
	```javascript
	wget https://artifacts.elastic.co/downloads/logstash/logstash-6.6.2.rpm
	yum -y install logstash-*.rpm
	/usr/share/logstash/bin/system-install
	```
2. 安裝好後，執行以下指令啟動: 
	```javascript
	systemctl start logstash
	```	
3. 查看狀態：
 	```javascript
	systemctl status logstash
	```
4. 透過 vi 或其他文字編輯器，新增 Logstah 的 Filter 設定檔：
 	```javascript
	vi /etc/logstash/conf.d/pipeline.conf
	```
	
[========]
### 4. [Kibana](https://www.elastic.co/downloads/kibana)(kibana-6.6.1-x86_64.rpm)

1. 用瀏覽器查詢 Elasticsearch API 實在是很難閱讀，所以需要一個漂亮的圖形化工具，下載後透過 WinSCP 放到 /tmp/，執行以下指令安裝：
	```javascript
	rpm -ivh /tmp/kibana-*.rpm
	```
2. 安裝好後，執行以下指令啟動: 
	```javascript
	systemctl start kibana
	```
3. 查看狀態：
 	```javascript
	systemctl status kibana
	```
4. 設定 Kibana  綁定的 IP 及 Port
 	```javascript
	vi /etc/kibana/kibana.yml
	```
	*  綁定 Port，預設其實就是 5601
		* server.port: 5601
	*  0.0.0.0 表示綁定所有 IP
		* server.host: "0.0.0.0"
	
 6. 設定完成後，重新啟動：
  	```javascript
	systemctl restart kibana
	```

