#!/bin/bash
source script_lib

function install_gcc()
{
	echo 'install gcc...'
	
	yum -y install gcc || return 1
	yum -y install gcc-c++ || return 1
	yum -y install gdb || return 1
}

function install_buildtool()
{
	echo 'install build tool...'

	yum -y install libtool || return 1
	yum -y install automake || return 1
	yum -y install cmake || return 1
}

function install_mysql_devel()
{
	echo 'install mysql-devel...'
	
	yum -y install mysql-devel || return 1
}

install_gcc
if [ $? -ne 0 ]; then
	printc C_RED "install gcc error!"
	exit 1;
fi
install_buildtool
if [ $? -ne 0 ]; then
	printc C_RED "install build tool error!"
	exit 1;
fi
install_mysql_devel
if [ $? -ne 0 ]; then
	printc C_RED "install mysql-devel error!"
	exit 1;
fi

gcc --version
automake --version
cmake --version