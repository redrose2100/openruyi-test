source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_env() {
    #检查两端测试环境有没有清理干净
    SSH_CMD "cd /mnt/hmdfs/100 || echo \$? > /remote_env.txt"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
    SSH_SCP ${NODE2_USER}@${NODE2_IPV4}:/remote_env.txt / ${NODE2_PASSWORD}
    re_env=`cat /remote_env.txt`
    if [ -d "/mnt/hmdfs/100" ]; then
	    exit 254
    elif [ $re_env ==  0 ]; then
      exit 253
    fi
    #准备工作，安装好离线rpm包dfs_service-1.1.2-1.aarch64.rpm，并且hmdfs.ko已插入内核
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

    rm -rf /test_01.txt /test_02.txt /remoteIDb.txt /remote_env.txt
    SSH_CMD "rm -rf /test_01.txt /test_02.txt /remoteIDb.txt /mnt/hmdfs"  ${NODE2_IPV4}  ${NODE2_PASSWORD}  ${NODE2_USER}  300 22
}