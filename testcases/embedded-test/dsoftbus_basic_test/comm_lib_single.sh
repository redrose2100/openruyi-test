source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_dsoftbus() {
	dsoftbus_client=$1
	
    chmod 777 $dsoftbus_client

    echo 123456 > /etc/SN
    
    softbus_server_main >/log.file 2>&1 &
}

function expect_test() {
    expect -v
    if [ $? -ne 0 ]; then
        LOG_ERROR "System not support expect"
        return 0
    fi
}

function clean_dsoftbus() {
    rm -rf /etc/SN

    ps -ef | grep softbus_server_main |grep -v grep | awk '{print $2}' | xargs kill -9
    rm -rf /log.file
    
    rm -rf /data/data* 
    mkdir -p /data/data/deviceauth 
}