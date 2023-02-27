source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_dsoftbus() {
	dsoftbus_client=$1
	
    chmod 777 $dsoftbus_client
    SSH_SCP $dsoftbus_client root@${NODE2_IPV4}:/ "${NODE2_PASSWORD}"

    echo 123456 > /etc/SN
    SSH_CMD "echo 456789 > /etc/SN"  ${NODE2_IPV4}  ${NODE2_PASSWORD} ${NODE2_USER}  300 22

    nohup softbus_server_main >/log.file 2>&1 &
    SSH_CMD "nohup softbus_server_main > /log.file 2>&1 &"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
}

function expect_test() {
    expect -v
    if [ $? -ne 0 ]; then
        LOG_ERROR "System not support expect"
        return 0
    fi
}

function clean_dsoftbus() {
    dsoftbus_client=$1

    rm -rf /etc/SN
    SSH_CMD "rm -rf /etc/SN"  ${NODE2_IPV4}  ${NODE2_PASSWORD} ${NODE2_USER} 300 22
 
    ps -ef | grep softbus_server_main |grep -v grep | awk '{print $2}' | xargs kill -9
    SSH_CMD "ps -ef | grep $dsoftbus_client |grep -v grep | awk '{print \$2}' | xargs kill -9"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_CMD "ps -ef | grep softbus_server_main |grep -v grep | awk '{print \$2}' | xargs kill -9"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22

    rm -rf /log.file
    SSH_CMD "rm -rf /$dsoftbus_client"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_CMD "rm -rf /log.file"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    
    rm -rf /data/data* 
    mkdir -p /data/data/deviceauth 
    SSH_CMD "rm -rf /data/data*"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_CMD "mkdir -p /data/data/deviceauth"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
}