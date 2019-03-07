

![](https://github.com/wdwd2233/Notes/blob/master/Linux/img/ELK.png?raw=true)


# 安裝

### Java [下載](https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html) (jdk-11.0.2_linux-x64_bin.rpm)
 1. 因為 Elasticsearch 及 Logstash 是用 Java 開發，所以要安裝 JVM，下載後透過 WinSCP 放到 /tmp/，執行以下指令安裝：
 2.
	```javascript
	rpm -ivh /tmp/jre-*.rpm
	```
### Elasticsearch [下載](https://www.elastic.co/downloads/elasticsearch) (elasticsearch-6.6.1.rpm)
 1. Elasticsearch 是搜尋引擎，就像是資料庫，把收集到的 Log 存在這裡，讓你可以快速的查詢。
 2.
	```javascript
	rpm -ivh /tmp/elasticsearch-*.rpm
	```
 3. 安裝好後，執行以下指令啟動: 
	```javascript
	systemctl start elasticsearch
	```
 4. 查看狀態：
 	```javascript
	systemctl status elasticsearch
	curl "http://localhost:9200/_cat/nodes"
	```
 5. 設定記憶體
	```javascript
	rpm -ivh /tmp/elasticsearch-*.rpm
	```
 6. 設定 Elasticsearch 綁定的 IP 及 Port
 	```javascript
	vi /etc/elasticsearch/elasticsearch.yml
	```
 7. 設定完成後，重新啟動：
  	```javascript
	systemctl restart elasticsearch
	```
 8. 試試看用 IP 查詢 nodes
   	```javascript
	curl "http://192.168.2.107:9200/_cat/nodes"
	```
 9. 防火牆
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