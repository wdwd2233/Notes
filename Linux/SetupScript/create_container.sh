#!/bin/bash
source script_lib

redis_container_name=my-redis
mysql_passwd=1234
mysql_container_name=my-mysql
mysql_docker_file_path=/root/DockerArea/MySQL/
mysql_db_name=cegame

getInnerIP static_ip

function create_redis()
{
	echo 'create redis container...'
	
	redis_host_data=/storage/redis/data
	redis_container_data=/data
	redis_port=6379
	docker run -e "TZ=Asia/Taipei" \
		-v $redis_host_data:$redis_container_data \
		--detach \
		--publish $redis_port:$redis_port \
		--name $redis_container_name redis
	docker exec -it $redis_container_name bash -c "redis-server --version"
	
	firewall-cmd --permanent --zone=public --add-port=$redis_port/tcp
	firewall-cmd --reload
}

function create_mysql()
{
	# https://medium.com/@lvthillo/customize-your-mysql-database-in-docker-723ffd59d8fb
	echo 'create MySQL container...'
	
	pushd $PWD
	cd $mysql_docker_file_path
	mysql_host_data=/storage/mysql/data
	mysql_container_data=/var/lib/mysql
	mysql_port=3306
	docker build -t my-mysql .
	docker run -e "TZ=Asia/Taipei" \
		-v $mysql_host_data:$mysql_container_data \
		--detach \
		--publish $mysql_port:$mysql_port \
		-e MYSQL_ROOT_PASSWORD=$mysql_passwd \
		--name $mysql_container_name my-mysql
	docker exec -it $mysql_container_name bash -c "mysql -V"
	popd
	
	mysql_host_backup=/storage/mysql/backups
	mkdir $mysql_host_backup
	(crontab -l; echo "0 2 * * * /bin/docker exec "$mysql_container_name" sh -c 'exec mysqldump -uroot -p\"\$MYSQL_ROOT_PASSWORD\" "$mysql_db_name"' > "$mysql_host_backup"/"$mysql_db_name"-\`date +\"\%Y-\%m-\%d\"\`.sql") | crontab
	(crontab -l; echo "0 3 * * * find $mysql_host_backup/*.sql -mtime +6 -type f -delete") | crontab
	
	firewall-cmd --permanent --zone=public --add-port=$mysql_port/tcp
	firewall-cmd --reload
}

function test_redis()
{
	echo 'test redis container...'
	
	docker exec -it $redis_container_name bash -c "redis-cli ping"
}

function test_mysql()
{
	echo 'test mysql container...'
	
	mysql_test_sql="\
show databases;\
use cegame;\
show tables;\
select * from account limit 10;\
"
	mysql_test_command="mysql -uroot -p"$mysql_passwd" -e '"$mysql_test_sql"'"
	docker exec -it $mysql_container_name bash -c "$mysql_test_command"
}

function fix_mysql()
{
	echo 'fix mysql container...'
	
	mysql_fix_sql="\
alter user root@'localhost' identified with mysql_native_password by '"$mysql_passwd"';\
alter user root@'%' identified with mysql_native_password by '"$mysql_passwd"';\
"
	mysql_fix_command="mysql -uroot -p"$mysql_passwd" -e \""$mysql_fix_sql"\""
	docker exec -it $mysql_container_name bash -c "$mysql_fix_command"
	
	mysql_test_sql="\
select * from mysql.user where User='root';\
"
	mysql_test_command="mysql -uroot -p"$mysql_passwd" -e \""$mysql_test_sql"\""
	docker exec -it $mysql_container_name bash -c "$mysql_test_command"
}

function redis_client()
{
	docker run -it --link $redis_container_name:$redis_container_name --rm redis sh -c 'exec redis-cli -h '$redis_container_name' -p 6379'
}

function menu()
{
	time=$(date '+%Y-%m-%d %H:%M:%S')
	printc C_GREEN "================================================================\n"
	printc C_GREEN "= create containers"
	printc C_WHITE " (IP: $static_ip, time: $time)\n"
	printc C_GREEN "================================================================\n"
	printc C_CYAN "  1. redis\n"
	printc C_CYAN "  2. mysql\n"
	printc C_CYAN "  11. test redis\n"
	printc C_CYAN "  12. test mysql\n"
	printc C_CYAN "  21. fix mysql\n"
	printc C_CYAN "  31. redis client\n"
	printc C_CYAN "  q. Exit\n"
	while true; do
		read -p "Please Select:" cmd
		case $cmd in
			1)
				create_redis
				return 0;;
			2)
				create_mysql
				return 0;;
			11)
				test_redis
				return 0;;
			12)
				test_mysql
				return 0;;
			21)
				fix_mysql
				return 0;;
			31)
				redis_client
				return 0;;
			[Qq]* )
				return 1;;
			* ) 
				echo "Please enter number or q to exit.";;
		esac
	done
}

while menu
do
	echo
done