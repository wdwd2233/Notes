#!/bin/bash

function install_Docker-Compose()
{
	# 安裝Docker-Compose
	cd /usr/bin
	wget https://github.com/docker/compose/releases/download/1.18.0/docker-compose-Linux-x86_64
	mv docker-compose-Linux-x86_64 docker-compose
	chmod 755 docker-compose
}

function install_sebp/elk()
{	
	# 檢查 vm.max_map_count
	sysctl vm.max_map_count
	
	# 更改vm.max_map_count 數
	echo "vm.max_map_count=262144" > /etc/sysctl.conf
	
	# 重新啟動生效
	sysctl -p
	
	# 安裝
	sudo docker run -p 5601:5601 -p 9200:9200 -p 5044:5044 -it --name my-elk sebp/elk
	
	
	# 設定 docker-compose 啟動
	echo "elk:" >> /usr/bin/docker-compose.yml
	echo "  image: sebp/elk" >> /usr/bin/docker-compose.yml
    echo "  ports:" >> /usr/bin/docker-compose.yml
    echo "    - '5601:5601'" >> /usr/bin/docker-compose.yml
    echo "    - '9200:9200'" >> /usr/bin/docker-compose.yml
    echo "    - '5044:5044'" >> /usr/bin/docker-compose.yml
	
	# 啟動 elk
	cd /usr/bin
	sudo docker-compose up elk
}

function install_filebeat()
{	
	# 安裝 prima/filebeat
	docker run -v /path/to/filebeat.yml:/filebeat.yml prima/filebeat:6

}

install_Docker-Compose
install_sebp/elk
#if [ $? -ne 0 ]; then
#	printc C_RED "安裝 Kibana 失敗 ~! "
#	exit 1;
#fi