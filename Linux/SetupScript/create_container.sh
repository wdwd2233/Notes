#!/bin/bash
source script_lib

redis_container_name=my-redis
mysql_passwd=1234
mysql_container_name=my-mysql
mysql_docker_file_path=/root/DockerArea/MySQL/
mysql_master_conf_path=/root/DockerArea/MySQL/master.cnf
mysql_slave_conf_path=/root/DockerArea/MySQL/slave.cnf
mysql_master_ip=10.40.0.199
mysql_master_port=3306
mysql_slave_ip=10.40.0.199
mysql_slave_port=3307
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

function create_mysql_master()
{
	# https://github.com/Junnplus/blog/issues/1
	# https://blog.miniasp.com/post/2012/07/04/How-to-setup-MySQL-55-One-way-replication-Master-Slave-mode.aspx
	echo 'create MySQL master container...'
	
	pushd $PWD
	cd $mysql_docker_file_path
	mysql_host_data=/storage/mysqlm/data
	mysql_container_data=/var/lib/mysql
	mysql_container_conf=/etc/mysql/conf.d/master.conf
	docker build -t my-mysql .
	mysqlm_container_name=my-mysqlm
	docker run -e "TZ=Asia/Taipei" \
		-v $mysql_host_data:$mysql_container_data \
		-v $mysql_master_conf_path:$mysql_container_conf \
		--detach \
		--publish $mysql_master_port:3306 \
		-e MYSQL_ROOT_PASSWORD=$mysql_passwd \
		--name $mysqlm_container_name my-mysql
	docker exec -it $mysqlm_container_name bash -c "mysql -V"
	popd
	
	firewall-cmd --permanent --zone=public --add-port=$mysql_master_port/tcp
	firewall-cmd --reload
}
function create_mysql_slave()
{
	echo 'create MySQL slave container...'
	
	pushd $PWD
	cd $mysql_docker_file_path
	mysql_host_data=/storage/mysqls/data
	mysql_container_data=/var/lib/mysql
	mysql_container_conf=/etc/mysql/conf.d/slave.cnf
	docker build -t my-mysql .
	mysqls_container_name=my-mysqls
	docker run -e "TZ=Asia/Taipei" \
		-v $mysql_host_data:$mysql_container_data \
		-v $mysql_slave_conf_path:$mysql_container_conf \
		--detach \
		--publish $mysql_slave_port:3306 \
		-e MYSQL_ROOT_PASSWORD=$mysql_passwd \
		--name $mysqls_container_name my-mysql
	docker exec -it $mysqls_container_name bash -c "mysql -V"
	popd
	
	mysql_host_backup=/storage/mysqls/backups
	mkdir $mysql_host_backup
	(crontab -l; echo "0 2 * * * /bin/docker exec "$mysqls_container_name" sh -c 'exec mysqldump -uroot -p\"\$MYSQL_ROOT_PASSWORD\" "$mysql_db_name"' > "$mysql_host_backup"/"$mysql_db_name"-\`date +\"\%Y-\%m-\%d\"\`.sql") | crontab
	(crontab -l; echo "0 3 * * * find $mysql_host_backup/*.sql -mtime +6 -type f -delete") | crontab
	
	firewall-cmd --permanent --zone=public --add-port=$mysql_slave_port/tcp
	firewall-cmd --reload
}

function config_mysql_slave()
{
	echo 'config MySQL slave container...'
	
	mysqls_container_name=my-mysqls
	
	mysql_sql="\
stop slave;\
reset slave;\
change master to master_host='$mysql_master_ip', master_port=$mysql_master_port, master_user='root', master_password='$mysql_passwd';\
start slave;\
show slave status\G
"
	mysql_command="mysql -uroot -p$mysql_passwd -e \"$mysql_sql\""
	echo "$mysql_sql"
	docker exec -it $mysqls_container_name bash -c "$mysql_command"
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
	printc C_CYAN "  3. mysql master\n"
	printc C_CYAN "  4. mysql slave\n"
	printc C_CYAN "  5. config mysql slave\n"
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
			3)
				create_mysql_master
				return 0;;
			4)
				create_mysql_slave
				return 0;;
			5)
				config_mysql_slave
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