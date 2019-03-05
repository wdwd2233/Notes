#!/bin/bash
source script_lib

gitlab_container_name=my-gitlab
gitlab_host_backup=/storage/gitlab/backups
gitlab_container_backup=/var/opt/gitlab/backups
user_name=rd

getInnerIP static_ip

function restore()
{
	pushd $PWD
	cd $gitlab_host_backup
	postfix=_gitlab_backup.tar
	if [ ! -f *$postfix ]; then
		ls -l
		printc C_RED "no backup to restore"
		return
	fi
	restore_file=$(ls -t *$postfix | head -1)
	restore_id=${restore_file:0:(-${#postfix})}
	popd

	echo 'restore '$restore_file'...'
	docker exec -it "$gitlab_container_name" /opt/gitlab/bin/gitlab-rake gitlab:backup:restore BACKUP=$restore_id
}

function backup()
{
	docker exec -it "$gitlab_container_name" /opt/gitlab/bin/gitlab-rake gitlab:backup:create
	
	pushd $PWD
	cd $gitlab_host_backup
	echo restore_file=$(ls -t *$postfix | head -1)
	popd
}

function menu()
{
	time=$(date '+%Y-%m-%d %H:%M:%S')
	printc C_GREEN "================================================================\n"
	printc C_GREEN "= git operations"
	printc C_WHITE " (IP: $static_ip, time: $time)\n"
	printc C_GREEN "================================================================\n"
	printc C_CYAN "  1. restore\n"
	printc C_CYAN "  2. backup\n"
	printc C_CYAN "  q. Exit\n"
	while true; do
		read -p "Please Select:" cmd
		case $cmd in
			1)
				restore
				return 0;;
			2)
				backup
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