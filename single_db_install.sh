###############################################
# Name:single_db_install.sh
# Applied to:Linux_x86_64 & oracle11.2.0.x
# Author:cdshrewd (cdshrewd#163.com)
# Purpose:To install single oracle software on Linux_x86_64 platform.It is tested on RHEL6.5+Oracle11.2.0.4.
# Usage:It is supposed that you prepare ths OS by prepare_OS_for_single_oracle.sh before running the scrips.
#      Run this scripts with 1 args.The argument refers to the 'runInstaller' file's  location.
#      You can run this scripts like './single_db_install.sh /u01/soft/database'.
# Modified Date:2016/03/19
###############################################
#!/bin/bash
if [ -n "$1" ]
then
echo "The runInstaller is located in $1."
else
echo "Sorry,you didn't input the runInstaller directory!"
fi

orauser_name=`id -u oracle`
curuser_name=`id -u`
if [  "$curuser_name" -ne "$orauser_name" ];then
 echo "You should run this scripts by oracle." 
else
cat >$1/db_install.rsp<<EOF
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v11_2_0
oracle.install.option=INSTALL_DB_SWONLY
ORACLE_HOSTNAME=$HOSTNAME
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=$(dirname $ORACLE_BASE)/oraInventory
SELECTED_LANGUAGES=en
ORACLE_HOME=$ORACLE_HOME
ORACLE_BASE=$ORACLE_BASE
oracle.install.db.InstallEdition=EE
oracle.install.db.EEOptionsSelection=false
oracle.install.db.optionalComponents=oracle.rdbms.partitioning:11.2.0.4.0,oracle.oraolap:11.2.0.4.0,oracle.rdbms.dm:11.2.0.4.0,oracle.rdbms.dv:11.2.0.4.0,oracle.rdbms.lbac:11.2.0.4.0,oracle.rdbms.rat:11.2.0.4.0
oracle.install.db.DBA_GROUP=dba
oracle.install.db.OPER_GROUP=dba
oracle.install.db.CLUSTER_NODES=
oracle.install.db.isRACOneInstall=
oracle.install.db.racOneServiceName=
oracle.install.db.config.starterdb.type=
oracle.install.db.config.starterdb.globalDBName=
oracle.install.db.config.starterdb.SID=
oracle.install.db.config.starterdb.characterSet=AL32UTF8
oracle.install.db.config.starterdb.memoryOption=true
oracle.install.db.config.starterdb.memoryLimit=
oracle.install.db.config.starterdb.installExampleSchemas=false
oracle.install.db.config.starterdb.enableSecuritySettings=true
oracle.install.db.config.starterdb.password.ALL=
oracle.install.db.config.starterdb.password.SYS=
oracle.install.db.config.starterdb.password.SYSTEM=
oracle.install.db.config.starterdb.password.SYSMAN=
oracle.install.db.config.starterdb.password.DBSNMP=
oracle.install.db.config.starterdb.control=DB_CONTROL
oracle.install.db.config.starterdb.gridcontrol.gridControlServiceURL=
oracle.install.db.config.starterdb.automatedBackup.enable=false
oracle.install.db.config.starterdb.automatedBackup.osuid=
oracle.install.db.config.starterdb.automatedBackup.ospwd=
oracle.install.db.config.starterdb.storageType=
oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=
oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=
oracle.install.db.config.asm.diskGroup=
oracle.install.db.config.asm.ASMSNMPPassword=
MYORACLESUPPORT_USERNAME=
MYORACLESUPPORT_PASSWORD=
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false
DECLINE_SECURITY_UPDATES=true
PROXY_HOST=
PROXY_PORT=
PROXY_USER=
PROXY_PWD=
PROXY_REALM=
COLLECTOR_SUPPORTHUB_URL=
oracle.installer.autoupdates.option=
oracle.installer.autoupdates.downloadUpdatesLoc=
AUTOUPDATES_MYORACLESUPPORT_USERNAME=
AUTOUPDATES_MYORACLESUPPORT_PASSWORD=
EOF

if [ -d  $1 ]; 
then
cd $1
./runInstaller -silent -force -noconfig -ignorePrereq -responseFile $1/db_install.rsp
else
echo "You didn't provide the right location for runInstaller"
fi
fi