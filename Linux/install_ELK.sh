#!/bin/bash

function install_Java()
{
	echo '開始安裝 Java.....'
	
	cd /tmp
	yum -y install java-1.8.0-openjdk-devel java-1.8.0-openjdk
	
	echo '安裝成功 Java.....'
}

function install_Elasticsearch ()
{
	echo '開始下載 Elasticsearch.....'
	wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.7.1.rpm
	
	echo '開始安裝 Elasticsearch.....'
	yum -y install elasticsearch-*.rpm

	sed  -i 's/#network.host: 192.168.0.1/network.bind_host: 0.0.0.0/g' /etc/elasticsearch/elasticsearch.yml
	sed  -i 's/#http.port: 9200/http.port: 9200/g' /etc/elasticsearch/elasticsearch.yml
	
	#防火牆 完全關閉
	systemctl stop firewalld
	systemctl disable firewalld
	#增加防火牆規則
	#firewall-cmd --add-service=elasticsearch --permanent
	#firewall-cmd --reload
	
	# 更改vm.max_map_count 數
	echo "vm.max_map_count=262144" > /etc/sysctl.conf
	# 重新啟動生效
	sysctl -p
	
	#啟動 Elasticsearch
	systemctl start elasticsearch
	systemctl enable elasticsearch
	
	# 刪除安裝檔
	rm -f elasticsearch-*.rpm
	
	echo '安裝成功 Elasticsearch.....'
}

function install_Logstash ()
{
	echo '開始下載 Logstash.....'
	wget https://artifacts.elastic.co/downloads/logstash/logstash-6.7.1.rpm
	
	echo '開始安裝 Logstash.....'
	yum -y install logstash-*.rpm
	
	/usr/share/logstash/bin/system-install
	
	
	# 載入設定檔
	git clone 'https://github.com/wdwd2233/Setting.git'
	cp -r /tmp/Setting/Linux/Logstah/conf.d/pipeline.conf /etc/logstash/conf.d/pipeline.conf
	
	# 啟動 Logstash 
	systemctl start logstash
	systemctl enable logstash
	
	# 刪除安裝檔
	rm -f logstash-*.rpm
	
	echo '安裝成功 Logstash.....'
}


function install_Kibana ()
{
	echo '開始下載 Kibana.....'
	wget https://artifacts.elastic.co/downloads/kibana/kibana-6.7.1-x86_64.rpm

	echo '開始安裝 Kibana.....'
	yum -y install /tmp/kibana-*.rpm
	
	sed  -i 's/#server.port: 5601/server.port: 5601/g' /etc/kibana/kibana.yml
	sed  -i 's/#server.host: "localhost"/server.host: "0.0.0.0"/g' /etc/kibana/kibana.yml
	
	
	# 漢化
	#sed  -i 's/#i18n.locale: "en"/i18n.locale: "zh_CN"/g' /etc/kibana/kibana.yml
	#python main.py /etc/kibana/
	# 啟動 Logstash 
	systemctl start kibana
	systemctl enable kibana
	
	echo '安裝成功 Kibana.....'
	
	# 刪除安裝檔
	rm -f kibana-*.rpm
}


function localize_Kibana ()
{
	cd /tmp
	#git clone 'https://github.com/anbai-inc/Kibana_Hanization.git'
	#cp -r /tmp/Kibana_Hanization/translations /usr/share/kibana/src/legacy/core_plugins/kibana
	
	git clone 'https://github.com/wdwd2233/Setting.git'
	cp -r /tmp/Setting/Linux/Kibana/translations /usr/share/kibana/src/legacy/core_plugins/kibana
	
	sed  -i 's/#i18n.locale: "en"/i18n.locale: "zh_CN"/g' /etc/kibana/kibana.yml
	rm -rf Setting
	systemctl restart kibana
	echo '漢化成功 Kibana.....'
}


install_Java
if [ $? -ne 0 ]; then
	printc C_RED "安裝 Java 失敗 ~! "
	exit 1;
fi

install_Elasticsearch
if [ $? -ne 0 ]; then
	printc C_RED "安裝 Elasticsearch 失敗 ~! "
	exit 1;
fi

install_Logstash
if [ $? -ne 0 ]; then
	printc C_RED "安裝 Logstash 失敗 ~! "
	exit 1;
fi

install_Kibana
if [ $? -ne 0 ]; then
	printc C_RED "安裝 Kibana 失敗 ~! "
	exit 1;
fi

#localize_Kibana
#if [ $? -ne 0 ]; then
#	printc C_RED "安裝 Kibana 漢化失敗 ~! "
#	exit 1;
#fi
