#!/bin/bash
source script_lib

user_name=rd
passwd=a

function setup_sys()
{
	echo 'setup sys...'
	setsebool -P rsync_full_access 1
	
	# add sudoer
	f=/etc/sudoers
	file_rline $f '^'$user_name'.*' ''$user_name'     ALL=(ALL)       ALL'
}

function install_systools()
{
	echo 'install sys tools...'
	# yum
	yum -y update || return 1
	yum -y install yum-utils || return 1

	# epel
	rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY* || return 1
	yum -y install epel-release || return 1

	# remi
	rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm || return 1

	# tools
	yum -y install telnet || return 1
	yum -y install zip || return 1
	yum -y install unzip || return 1
	yum -y install screen || return 1
	yum -y install tmux || return 1
	yum -y install wget || return 1
	yum -y install crudini || return 1
	yum -y install jq || return 1
}

function install_samba()
{
	echo 'install samba...'
	yum install -y samba samba-client samba-common || return 1

	echo 'start samba....'
	systemctl enable smb
	systemctl enable nmb
	systemctl start smb
	systemctl start nmb
	
	setsebool -P samba_enable_home_dirs on
	firewall-cmd --permanent --zone=public --add-service=samba
	firewall-cmd --reload
	
	samba_conf_name=/etc/samba/smb.conf
	sed "s/^[ \t]*//" -i $samba_conf_name
	crudini --set $samba_conf_name 'homes' 'follow symlinks' yes
	crudini --set $samba_conf_name 'homes' 'wide links' yes
	crudini --set $samba_conf_name 'global' 'unix extensions' no
	crudini --set $samba_conf_name 'global' 'acl allow execute always' True
	
	samba_share_name=share
	su $user_name bash -c "mkdir ~/"$samba_share_name

	service smb restart
	
	(echo $passwd; echo $passwd) | smbpasswd -a $user_name
}

function install_rsync()
{
	echo 'install rsync...'
	yum install -y rsync || return 1
	
	# we use $user_name to handle the rsync job
	rsync_conf_name=/etc/rsyncd.conf
	rsync_secrets=/etc/rsyncd.secrets
	sed "s/^[ \t]*//" -i $rsync_conf_name
	crudini --set $rsync_conf_name '' 'uid' root
	crudini --set $rsync_conf_name '' 'gid' root
	crudini --set $rsync_conf_name '' 'auth users' $user_name
	crudini --set $rsync_conf_name '' 'secrets file' $rsync_secrets
	crudini --set $rsync_conf_name '' 'read only' no
	crudini --set $rsync_conf_name '' 'charset' utf-8
	(echo $user_name":"$passwd) > $rsync_secrets
	chmod 600 /etc/rsyncd.secrets
	
	rsync_port=873
	firewall-cmd --permanent --zone=public --add-port=$rsync_port/tcp
	firewall-cmd --reload
	
	systemctl restart rsyncd
	systemctl enable rsyncd
}

function install_docker()
{
	echo 'install docker...'
	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	yum -y install docker-ce || return 1
	
	docker_conf_name=/etc/docker/daemon.json
	(jq -n '{"live-restore": true'}) > $docker_conf_name
	
	systemctl restart docker
	systemctl enable docker
	
	# allow user can access docker
	sudo usermod -a -G docker $user_name
}

function setup_locale()
{
	echo 'set timezone....'
	timedatectl set-timezone Asia/Taipei
	timedatectl status
	
	# assist chrony
	timedatectl set-ntp yes
}

setup_sys

install_systools
if [ $? -ne 0 ]; then
	printc C_RED "install sys tools error!"
	exit 1;
fi

install_samba
if [ $? -ne 0 ]; then
	printc C_RED "install samba error!"
	exit 1;
fi
install_rsync
if [ $? -ne 0 ]; then
	printc C_RED "install rsync error!"
	exit 1;
fi
install_docker
if [ $? -ne 0 ]; then
	printc C_RED "install docker error!"
	exit 1;
fi

systemctl status smb
systemctl status rsyncd
docker version
systemctl status docker

setup_locale
