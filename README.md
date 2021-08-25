# auto_install_oracle_11g
Auto install Oracle database software on Linux platform including the prerequisite condition of OS.
Before using this scripts, you should set hostname, configure a local yum repo  and upload the software to a directory. Then you can begin the installation steps.
Firstly, you can run the prepare_OS_for_single_oracle.sh with root like './prepare_OS_for_single_oracle.sh /u01/soft test'. The first argument is the location which the installation file is located. The second argument is the db name which you want to create.
Secondly, you can run the single_db_install.sh with oracle  like './single_db_install.sh /u01/soft/database'. The only argment is the unpacked  installation files' location. 
Finally, you can run the create_db.sh with oracle  like './create_db.sh'. No argment is needed. 
