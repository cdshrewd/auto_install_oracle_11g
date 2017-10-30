###############################################
# Name:prepare_OS_for_single_oracle.sh
# Author:cdshrewd (cdshrewd#163.com)
# Purpose:Prepare OS env for single oracle installation
# Usage:You should prepare a yum repository before running the scrips.
#      Run this scripts with 2 args.
#      The first one is the directory which the installation media is located.  
#      The second one is the name of the database.This is optional.
#      You can run this scripts like './prepare_OS_for_single_oracle.sh /u01/soft test'.
# Modified Date:2016/03/19
###############################################
#!/bin/bash
RUID=`/usr/bin/id|/bin/awk -F\( '{print $1}'|/bin/awk -F= '{print $2}'`
 if [ $RUID -ne 0 ];then
 echo "This script should be run by root." 
else
chkconfig sendmail off
chkconfig ntpd off
chkconfig iptables off
chkconfig ip6tables off
yum -y install\
 compat-libstdc++\
 compat-libcap1\
 pdksh gcc gcc-c++ glibc-devel\
 libstdc++ libstdc++-devel libaio-devel\
 sysstat libaio-devel elfutils-libelf-devel\
 unixODBC unixODBC-devel

if grep "# Added by cdshrewd's prepare scripts." /etc/selinux/config >/dev/null 2>&1; then
echo "The prepare scripts has been run before.It will not change the /etc/selinux/config" 
else
setenforce 0
sed -i "s/^SELINUX=/# &/g"  /etc/selinux/config
echo "# Added by cdshrewd's prepare scripts." >>/etc/selinux/config
echo "SELINUX=disabled">>/etc/selinux/config
fi
 
if grep "# Added by cdshrewd's prepare scripts." /etc/hosts >/dev/null 2>&1; then
echo "The prepare scripts has been run before.It will not change the /etc/hosts."  
else
ip_addr=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|head -1|awk '{print $2}'|tr -d "addr:"`
host_name=`hostname`
cat>> /etc/hosts <<EOF
# Added by cdshrewd's prepare scripts.
$ip_addr $host_name
EOF
fi

 
if id oracle &> /dev/null ;then 
    echo "The prepare scripts has been run before.It will not create the user oracle."   
else
    /usr/sbin/groupadd -g 501 oinstall
    /usr/sbin/groupadd -g 502 dba
    /usr/sbin/useradd -g oinstall -G dba -d /home/oracle oracle
    ORACLE_PASSWORD="oracle"
    echo "oracle:$ORACLE_PASSWORD"|chpasswd  
fi  

if grep "# Added by cdshrewd's prepare scripts." /etc/sysctl.conf >/dev/null 2>&1; then
echo "The prepare scripts has been run before.It will not change the sysctl.conf."  
else
cat>>/etc/sysctl.conf <<EOF
# Added by cdshrewd's prepare scripts.
fs.aio-max-nr=3145728
fs.file-max=6815744
kernel.shmall=1073741824
kernel.shmmax=4398046511104
kernel.shmmni=4096
kernel.sem=250 32000 100 128
net.ipv4.ip_local_port_range=9000 65500
net.core.rmem_default=262144
net.core.rmem_max=4194304
net.core.wmem_default=262144
net.core.wmem_max=1048576
EOF
fi

if grep "# Added by cdshrewd's prepare scripts." /etc/security/limits.conf >/dev/null 2>&1; then
 echo "The prepare scripts has been run before.It will not change the limits.conf."  
else
cat>>/etc/security/limits.conf<<EOF
# Added by cdshrewd's prepare scripts.
oracle soft nproc 2048
oracle har nproc 16384
oracle soft nofile 1024
oracle hard nofile 65536
EOF
fi

if grep "# Added by cdshrewd's prepare scripts." /etc/pam.d/login >/dev/null 2>&1; then
echo "The prepare scripts has been run before.It will not change the login configuration file."  
else
cat >>/etc/pam.d/login<<EOF
# Added by cdshrewd's prepare scripts.
session    required   /lib64/security/pam_limits.so
EOF
fi


cd $1
if  ! ls p*.zip > /dev/null 2>&1; then  
 echo "There is no zip file.Please prepare the installation files manually."
elif [ -d "$1/database" ]; then 
echo "You may unzip the installation files before."
else
 for file_name in p*.zip    
        do  
        echo "unzip the file $file_name"
        unzip -o $file_name 
  done 
  chown -R oracle:oinstall $1
  chmod -R 775 $1
fi

# make oracle_home and grant privs
if [ -d /u01/app/oracle/product/11.2.0/db_1 ];
 then
echo "Path  /u01/app/oracle/product/11.2.0/db_1 exists.There is no need to create agagin."
echo "Pls check the privs manually."
else
mkdir -p /u01/app/oracle/product/11.2.0/db_1
chown -R oracle:oinstall /u01
chmod -R 775 /u01
fi

if [ -n "$2" ]
 then db_name=$2
else
echo "You didn't provide db name.It will use the default oradb."
db_name="oradb"
fi

if grep "# Added by cdshrewd's prepare scripts." /home/oracle/.bash_profile >/dev/null 2>&1; then
echo "The prepare scripts has been run before.It will not change the .bahs_profile."  
else
cat>> /home/oracle/.bash_profile <<EOF
# Added by cdshrewd's prepare scripts.
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1
export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:.
export PATH=\$PATH:\$ORACLE_HOME/bin:.
export ORACLE_SID=$db_name
EOF
fi
fi