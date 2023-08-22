source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_env() {
    #检查两端测试环境有没有清理干净
    SSH_CMD "cd /mnt/hmdfsd/100/non_account/device_view || echo \$? > /remote_env.txt"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_SCP ${NODE2_USER}@${NODE2_IPV4}:/remote_env.txt / ${NODE2_PASSWORD}
    re_env=`cat /remote_env.txt`
    if [ -d "/mnt/hmdfs/100/non_account/device_view" ]; then
	    exit 254
    elif [ $re_env ==  0 ]; then
        exit 253
    fi
	
    #前期文件下载，hmdfs内核插入
    cd ~
    git clone https://gitee.com/heppen/hmdfs_test -b dev
    git clone https://gitee.com/heppen/filemanagement_dfs_service.git -b test
    insmod hmdfs_test/out/hmdfs_2203sp1.ko
    dnf install hilog -y && dnf install distributed-utils -y && dnf install dfs_service -y
    cd filemanagement_dfs_service && rpm2cpio dfs_service-1.0.0-1.aarch64.rpm | cpio -div
    mkdir -p /system/profile /system/log
    cp -r ~/filemanagement_dfs_service/system/profile/* /system/profile
    cd ~/filemanagement_dfs_service/system/bin
    cp mount_hmdfs.sh umount_hmdfs.sh start_services.sh stop_services.sh /system/bin
    echo 1111 > /etc/SN
    export LD_LIBRARY_PATH=/system/lib64
	
    SSH_CMD "mkdir -p /home/pre "  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_CMD "cd ~ && git clone https://gitee.com/heppen/hmdfs_test -b dev" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} 300 22
    SSH_CMD "cd ~ && git clone https://gitee.com/heppen/filemanagement_dfs_service.git -b test" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}  300 22
    SSH_CMD "insmod ~/hmdfs_test/out/hmdfs_2203sp1.ko"  ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} 300 22
    SSH_CMD "dnf install hilog -y && dnf install distributed-utils -y && dnf install dfs_service -y" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} 300 22
    SSH_CMD "cd ~/filemanagement_dfs_service && rpm2cpio dfs_service-1.0.0-1.aarch64.rpm | cpio -div | cpio -div" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}  300 22
    SSH_CMD "mkdir -p /system/profile /system/log"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_CMD "cp -r ~/filemanagement_dfs_service/system/profile/* /system/profile" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} 300 22
    SSH_CMD "cd ~/filemanagement_dfs_service/system/bin && cp mount_hmdfs.sh umount_hmdfs.sh /system/bin" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} 300 22
    SSH_CMD "cd ~/filemanagement_dfs_service/system/bin && cp start_services.sh stop_services.sh /system/bin" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} 300 22
    SSH_CMD "echo 2222 > /etc/SN" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} 300 22
    SSH_CMD "export LD_LIBRARY_PATH=/system/lib64" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}  300 22
	
    #启动服务，开启hmdfs
    cd /system/bin && ./mount_hmdfs.sh
    SSH_CMD "cd /system/bin && ./mount_hmdfs.sh"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    cd /system/bin && ./start_services.sh
    SSH_CMD "cd /system/bin && ./start_services.sh"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22

    sleep 3
    com_path="/mnt/hmdfs/100/non_account"
    remoteIDa=`cd ${com_path}/device_view && ls | grep -v local` 
    cd ${com_path}/device_view/local && mkdir testfile_1w_1
    cd ${com_path}/device_view/${remoteIDa} && mkdir testfile_1w_2
    cd ${com_path}/merge_view && mkdir testfile_1w_3
    SSH_CMD "cd ${com_path}/merge_view && mkdir testfile_1w_4"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_CMD "echo \`ls ${com_path}/device_view | grep -v local\` > /remoteIDb.txt"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_SCP ${NODE2_USER}@${NODE2_IPV4}:/remoteIDb.txt / ${NODE2_PASSWORD}
}

function set_var() {
    com_path="/mnt/hmdfs/100/non_account"
    remoteIDa=`cd ${com_path}/device_view && ls | grep -v local`
    remoteIDb=`cat /remoteIDb.txt`
}

function scp_txt() {
    SSH_SCP ${NODE2_USER}@${NODE2_IPV4}:/test_01.txt / ${NODE2_PASSWORD}
    SSH_SCP ${NODE2_USER}@${NODE2_IPV4}:/test_02.txt / ${NODE2_PASSWORD}
}

function clean_env() {
    cd /system/bin && ./stop_services.sh
    SSH_CMD "cd /system/bin && sudo ./stop_services.sh"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    cd /system/bin && ./umount_hmdfs.sh
    SSH_CMD "cd /system/bin && sudo ./umount_hmdfs.sh"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22

    dnf remove hilog -y && dnf remove distributed-utils -y && dnf remove dfs_service -y
    rm -rf /test_01.txt /test_02.txt /remoteIDb.txt /remote_env.txt 
    rm -rf ~/filemanagement_dfs_service ~/hmdfs_test /etc/SN /system
    rmmod hmdfs.ko
    unset LD_LIBRARY_PATH
    SSH_CMD "dnf remove hilog -y && dnf remove distributed-utils -y && dnf remove dfs_service -y" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER} 300 22
    SSH_CMD "rm -rf /test_01.txt /test_02.txt /remoteIDb.txt /remote_env.txt"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_CMD "rm -rf ~/filemanagement_dfs_service ~/hmdfs_test /etc/SN /system"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_CMD "rmmod hmdfs.ko"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_CMD "unset LD_LIBRARY_PATH"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
}