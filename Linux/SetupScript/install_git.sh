#!/bin/bash
source script_lib

user_name=rd
gitlab_container_name=my-gitlab
getInnerIP static_ip

function install_git()
{
	echo 'install git client...'
	yum -y install git || return 1
	yum -y install git-lfs || return 1
	
	git config --global core.autocrlf false
}

function install_gitlab()
{
	echo "install gitlab ..."
	
	# mount the backup volume and use cron job to schedule the backup
	gitlab_port=3000
	gitlab_ext_url=git.ce.com.tw
	gitlab_host_backup=/storage/gitlab/backups
	gitlab_container_backup=/var/opt/gitlab/backups
	docker image pull gitlab/gitlab-ce
	# --env for external_url for lfs
	# --publish for 80 port for lfs
	docker run -e "TZ=Asia/Taipei" \
		-v $gitlab_host_backup:$gitlab_container_backup \
		--env GITLAB_OMNIBUS_CONFIG="external_url 'http://"$gitlab_ext_url"'; gitlab_rails['lfs_enabled'] = true;" \
		--detach --restart always \
		--publish $gitlab_port:80 --publish 80:80 \
		--name $gitlab_container_name gitlab/gitlab-ce
	firewall-cmd --permanent --zone=public --add-port=$gitlab_port/tcp
	firewall-cmd --reload
	file_rline /etc/hosts "^$static_ip" "$static_ip	"$gitlab_ext_url
	
	# use rsync to backup
	rsync_conf_name=/etc/rsyncd.conf
	crudini --set $rsync_conf_name 'gitlab_backup' 'comment' gitlab_backup
	crudini --set $rsync_conf_name 'gitlab_backup' 'path' $gitlab_host_backup
	systemctl restart rsyncd
	
	# the crontab job of gitlab backup
	(crontab -l; echo "0 2 * * * /bin/docker exec -i "$gitlab_container_name" /opt/gitlab/bin/gitlab-rake gitlab:backup:create") | crontab
	postfix=_gitlab_backup.tar
	(crontab -l; echo "0 3 * * * find $gitlab_host_backup/*$postfix -mtime +6 -type f -delete") | crontab
}

install_git
if [ $? -ne 0 ]; then
	printc C_RED "install git error!"
	exit 1;
fi
install_gitlab
if [ $? -ne 0 ]; then
	printc C_RED "install gitlab error!"
	exit 1;
fi