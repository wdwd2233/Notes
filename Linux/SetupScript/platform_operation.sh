#!/bin/bash
source script_lib

gitlab_user=spencer
gitlab_passwd=12345678
gitlab_port=3000
gitlab_ext_url=git.ce.com.tw
gitlab_url_prefix=http://$gitlab_user:$gitlab_passwd@$gitlab_ext_url:$gitlab_port

go_version=1.11.1
go_container_name=my-golang

function clone_platform()
{
	echo 'clone server...'
	
	pushd $PWD
	cd ../
	mkdir Server
	cd Server
	git clone $gitlab_url_prefix/cegame/src/server.git src
	git clone $gitlab_url_prefix/cegame/env.git env
	popd
}

function setup_platform_firewall()
{
	firewall-cmd --permanent --zone=public --add-port=15101/tcp
	firewall-cmd --permanent --zone=public --add-port=15201/tcp
	firewall-cmd --permanent --zone=public --add-port=15301/tcp
	firewall-cmd --permanent --zone=public --add-port=15401/tcp
	firewall-cmd --reload
}

function build_platform()
{
	echo 'build server...'
	
	go_host_src=/root/Server/src
	go_container_src=/go/src
	go_host_env=/root/Server/env
	go_container_env=/go/env
	build_script_name=platform_do_build.sh
	
	pushd $PWD
	cd /root/Server/src
	git pull
	cd /root/Server/env/platform
	git pull
	cd /root/Server/env/platform/linux/uuidgen
	./uuidgen
	cp server_uuid ../server_uuid
	popd

	docker run -it --rm \
		-e "TZ=Asia/Taipei" \
		-v $go_host_src:$go_container_src \
		-v $go_host_env:$go_container_env \
		-v $(pwd)/$build_script_name:/go/$build_script_name \
		--name $go_container_name golang:$go_version \
		./$build_script_name
}

function start_platform()
{
	echo 'start server...'
	
	server_host_env=/root/Server/env/platform/linux
	server_container_env=/platform
	sleep_secs=2

	# rm -rf $server_host_env/logs

	docker run --detach --rm \
		-e "TZ=Asia/Taipei" \
		-v $server_host_env:$server_container_env \
		--publish 15101:15101 \
		--name pf_backend --init golang:latest \
		/bin/sh -c "cd $server_container_env/backend && ./backend.out"
	sleep $sleep_secs

	docker run --detach --rm \
		-e "TZ=Asia/Taipei" \
		-v $server_host_env:$server_container_env \
		--publish 15201:15201 \
		--name pf_api --init golang:latest \
		/bin/sh -c "cd $server_container_env/api && ./api.out"
	sleep $sleep_secs

	docker run --detach --rm \
		-e "TZ=Asia/Taipei" \
		-v $server_host_env:$server_container_env \
		--publish 15301:15301 \
		--name pf_frontend --init golang:latest \
		/bin/sh -c "cd $server_container_env/frontend && ./frontend.out"
	sleep $sleep_secs

	docker run --detach --rm \
		-e "TZ=Asia/Taipei" \
		-v $server_host_env:$server_container_env \
		--publish 15401:15401 \
		--name pf_log --init golang:latest \
		/bin/sh -c "cd $server_container_env/log && ./log.out"
}

function stop_platform()
{
	echo 'stop server...'
	
	docker stop pf_backend
	docker stop pf_api
	docker stop pf_frontend
	docker stop pf_log
}

function check_platform_status()
{
	echo 'check server status...'
	
	docker ps -f name=pf_backend		 --format "{{.Names}}\t{{.Ports}}\t{{.Status}}"
	docker ps -f name=pf_api			 --format "{{.Names}}\t{{.Ports}}\t{{.Status}}"
	docker ps -f name=pf_frontend		 --format "{{.Names}}\t{{.Ports}}\t{{.Status}}"
	docker ps -f name=pf_log			 --format "{{.Names}}\t{{.Ports}}\t{{.Status}}"
}


function menu()
{
	time=$(date '+%Y-%m-%d %H:%M:%S')
	printc C_GREEN "================================================================\n"
	printc C_GREEN "= platform operation"
	printc C_WHITE " (IP: $static_ip, time: $time)\n"
	printc C_GREEN "================================================================\n"
	printc C_CYAN "  1. clone platform\n"
	printc C_CYAN "  2. setup platform firewall\n"
	printc C_CYAN "  11. build platform\n"
	printc C_CYAN "  21. start platform\n"
	printc C_CYAN "  22. stop platform\n"
	printc C_CYAN "  23. check platform status\n"
	printc C_CYAN "  q. Exit\n"
	while true; do
		read -p "Please Select:" cmd
		case $cmd in
			1)
				clone_platform
				return 0;;
			2)
				setup_platform_firewall
				return 0;;
			11)
				build_platform
				return 0;;
			21)
				start_platform
				return 0;;
			22)
				stop_platform
				return 0;;
			23)
				check_platform_status
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