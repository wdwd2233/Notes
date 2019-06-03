#!/bin/bash
source script_lib

network_interface=enp5s0
network_interface1=enp6s0
static_ip=10.40.0.200
static_ip1=10.40.0.201
host_name=ceserver200
gateway=10.40.0.1

function setup_network()
{
	echo "setup static ip $static_ip ..."
	
	# static ip
	f=/etc/sysconfig/network-scripts/ifcfg-$network_interface
	file_rline $f ^BOOTPROTO= 'BOOTPROTO=static'
	file_rline $f ^BROADCAST= 'BROADCAST=10.40.1.255'
	file_rline $f ^NETMASK= 'NETMASK=255.255.255.0'
	file_rline $f ^NETWORK= 'NETWORK=10.40.1.0'
	file_rline $f ^IPADDR= 'IPADDR='$static_ip
	file_rline $f ^ONBOOT= 'ONBOOT=yes'
	
	f=/etc/sysconfig/network-scripts/ifcfg-$network_interface1
	file_rline $f ^BOOTPROTO= 'BOOTPROTO=static'
	file_rline $f ^BROADCAST= 'BROADCAST=10.40.1.255'
	file_rline $f ^NETMASK= 'NETMASK=255.255.255.0'
	file_rline $f ^NETWORK= 'NETWORK=10.40.1.0'
	file_rline $f ^IPADDR= 'IPADDR='$static_ip1
	file_rline $f ^ONBOOT= 'ONBOOT=yes'

	# gateway
	echo "setup gateway $gateway ..."
	f=/etc/sysconfig/network
	file_rline $f ^NETWORKING= 'NETWORKING=yes'
	file_rline $f ^HOSTNAME= 'HOSTNAME='$host_name
	file_rline $f ^GATEWAY= 'GATEWAY='$gateway
	
	# restart network service
	/etc/init.d/network restart
	
	# dns
	echo "setup dns server ..."
	f=/etc/resolv.conf
	file_delline $f 'nameserver'
	file_append $f 'nameserver 8.8.8.8'
	file_append $f 'nameserver 168.95.1.1'
	echo "$f content:"
	cat $f

	# restart network service
	/etc/init.d/network restart
	
	# check ping
	if ping -c 1 "google.com" &> /dev/null
	then
	  echo "ping google.com successful"
	else
	  printc C_RED "ping google.com disn't reply\n"
	fi
}

echo "install network"
askDefault "static ip" "static_ip"
askDefault "static ip1" "static_ip1"
askDefault "host name" "host_name"
askDefault "gateway" "gateway"
setup_network
