#!/bin/bash
source script_lib

redis_container_name=my-redis

getInnerIP static_ip

function create_redis() {
	echo 'create redis container...'

	redis_host_data=/storage/redis/data
	redis_container_data=/data
	redis_port=6379

	# 創建目錄 -p 多層創建 -m 權限
	mkdir -p -m 711 $redis_host_data

	docker run -e "TZ=Asia/Taipei" \
		-v $redis_host_data:$redis_container_data \
		--detach \
		--publish $redis_port:$redis_port \
		--name $redis_container_name redis
	docker exec -it $redis_container_name bash -c "redis-server --version"

	firewall-cmd --permanent --zone=public --add-port=$redis_port/tcp
	firewall-cmd --reload
}

mysql_passwd=1234
mysql_container_name=my-mysql
mysql_docker_file_path=/root/DockerArea/MySQL/
mysql_db_name=platform
function create_mysql() {
	# https://medium.com/@lvthillo/customize-your-mysql-database-in-docker-723ffd59d8fb
	echo 'create MySQL container...'

	mysql_host_data=/storage/mysql/data
	mysql_container_data=/var/lib/mysql
	mysql_port=3306

	# 創建目錄 -p 多層創建 -m 權限
	mkdir -p -m 711 /root/DockerArea/MySQL/sql-scripts
	mkdir -p -m 711 $mysql_host_data

	echo "FROM mysql" >>/root/DockerArea/MySQL/Dockerfile
	echo "COPY ./sql-scripts/ /docker-entrypoint-initdb.d/" >>/root/DockerArea/MySQL/Dockerfile

	# 移動至目錄
	pushd $PWD
	cd $mysql_docker_file_path

	docker build -t my-mysql .
	docker run -e "TZ=Asia/Taipei" \
		-v $mysql_host_data:$mysql_container_data \
		--detach \
		--publish $mysql_port:$mysql_port \
		-e MYSQL_ROOT_PASSWORD=$mysql_passwd \
		--name $mysql_container_name my-mysql
	docker exec -it $mysql_container_name bash -c "mysql -V"

	# 返回目錄
	popd

	mysql_host_backup=/storage/mysql/backups
	# 創建目錄 -p 多層創建 -m 權限
	mkdir -p -m 711 $mysql_host_backup
	(
		crontab -l
		echo "0 2 * * * /bin/docker exec "$mysql_container_name" sh -c 'exec mysqldump -uroot -p\"\$MYSQL_ROOT_PASSWORD\" "$mysql_db_name"' > "$mysql_host_backup"/"$mysql_db_name"-\`date +\"\%Y-\%m-\%d\"\`.sql"
	) | crontab
	(
		crontab -l
		echo "0 3 * * * find $mysql_host_backup/*.sql -mtime +6 -type f -delete"
	) | crontab

	firewall-cmd --permanent --zone=public --add-port=$mysql_port/tcp
	firewall-cmd --reload
}

function create_nginx() {
	echo 'create nginx...'

	# 主要nginx.conf
	nginx_host_cfg=/root/DockerArea/nginx/nginx.conf
	nginx_container_cfg=/etc/nginx/nginx.conf

	# nginx include conf
	nginx_host_icfg=/root/DockerArea/nginx/conf
	nginx_container_icfg=/etc/nginx/conf.d

	# nginx log
	nginx_host_log=/root/DockerArea/nginx/log
	nginx_container_log=/var/log/nginx

	# nginx ssl
	nginx_host_ssl=/root/DockerArea/nginx/ssl
	nginx_container_ssl=/etc/nginx/ssl

	# nginx html
	nginx_host_client=/root/DockerArea/nginx/html
	nginx_container_client=/usr/share/nginx/html

	nginx_port=8080

	# 創建目錄 -p 多層創建 -m 權限
	mkdir -p -m 711 /root/DockerArea/nginx
	mkdir -m 711 $nginx_host_icfg
	mkdir -m 711 $nginx_host_log
	mkdir -m 711 $nginx_host_ssl
	mkdir -m 711 $nginx_host_client

	docker run --detach --name my-nginx nginx
	docker cp my-nginx:$nginx_container_cfg $nginx_host_cfg
	docker cp my-nginx:$nginx_container_icfg/default.conf $nginx_host_icfg/default.conf
	docker cp my-nginx:$nginx_container_client/. $nginx_host_client
	docker stop my-nginx
	docker rm my-nginx
	docker rmi nginx

	docker run --detach \
		-e "TZ=Asia/Taipei" \
		-v $nginx_host_cfg:$nginx_container_cfg:ro \
		-v $nginx_host_icfg:$nginx_container_icfg \
		-v $nginx_host_log:$nginx_container_log \
		-v $nginx_host_ssl:$nginx_container_ssl \
		-v $nginx_host_client:$nginx_container_client \
		--publish $nginx_port:80 \
		--publish 443:443 \
		--name my-nginx nginx

	firewall-cmd --permanent --zone=public --add-port=$nginx_port/tcp
	firewall-cmd --reload
}

function redis_client() {
	docker run -it --link $redis_container_name:$redis_container_name --rm redis sh -c 'exec redis-cli -h '$redis_container_name' -p 6379'
}

function create_vsftpd() {
	echo 'create vsftpd...'

	vsftpd_host_cfg=/root/DockerArea/FTP/fax
	vsftpd_container_cfg=/home/vsftpd

	# 創建目錄 -p 多層創建 -m 權限
	mkdir -p -m 711 $vsftpd_host_cfg

	docker run --detach \
		-e "TZ=Asia/Taipei" \
		-v $vsftpd_host_cfg:$vsftpd_container_cfg \
		-p 20:20 \
		-p 21:21 \
		-p 21100-21110:21100-21110 \
		-e FTP_USER=root \
		-e FTP_PASS=a \
		-e PASV_ADDRESS=10.40.0.43 \
		-e PASV_MIN_PORT=21100 \
		-e PASV_MAX_PORT=21110 \
		--name my-ftp --restart=always fauria/vsftpd

	firewall-cmd --permanent --zone=public --add-port=20/tcp
	firewall-cmd --permanent --zone=public --add-port=21/tcp
	firewall-cmd --reload
}

function menu() {
	time=$(date '+%Y-%m-%d %H:%M:%S')
	printc C_GREEN "================================================================\n"
	printc C_GREEN "= create containers"
	printc C_WHITE " (IP: $static_ip, time: $time)\n"
	printc C_GREEN "================================================================\n"
	printc C_CYAN "  1.  create_redis\n"
	printc C_CYAN "  11. redis client\n"
	printc C_CYAN "  2.  create_mysql\n"
	printc C_CYAN "  3.  create_nginx\n"
	printc C_CYAN "  4.  create_vsftpd\n"
	printc C_CYAN "  q.  Exit\n"
	while true; do
		read -p "Please Select:" cmd
		case $cmd in
		1)
			create_redis
			return 0
			;;
		11)
			redis_client
			return 0
			;;
		2)
			create_mysql
			return 0
			;;
		3)
			create_nginx
			return 0
			;;
		4)
			create_vsftpd
			return 0
			;;
		[Qq]*)
			return 1
			;;
		*)
			echo "Please enter number or q to exit."
			;;
		esac
	done
}

while menu; do
	echo
done
