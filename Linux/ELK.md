

![](https://github.com/wdwd2233/Notes/blob/master/Linux/img/ELK.png?raw=true)


## 安裝

1. Java [下載](https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html) (jdk-11.0.2_linux-x64_bin.rpm)
 1. 因為 Elasticsearch 及 Logstash 是用 Java 開發，所以要安裝 JVM，下載後透過 WinSCP 放到 /tmp/，執行以下指令安裝：
 2.```javascript
	rpm -ivh /tmp/jre-*.rpm
	```
2. Elasticsearch [下載] (https://www.elastic.co/downloads/elasticsearch)
 1. Elasticsearch 是搜尋引擎，就像是資料庫，把收集到的 Log 存在這裡，讓你可以快速的查詢。
 2.```javascript
	rpm -ivh /tmp/elasticsearch-*.rpm
	```