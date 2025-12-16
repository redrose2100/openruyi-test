#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   meitingli
#@Contact   	:   244349477@qq.com
#@Date      	:   2021-08-03
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test clamdscan service
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    EXECUTE_T="40m"
    LOG_INFO "Start to prepare the database config."

    DNF_INSTALL "clamav clamav-server clamav-update"
    freshclam
    mv /etc/clamd.d/scan.conf /etc/clamd.d/scan.conf.bak
    echo "LogFile /var/log/clamd.scan
        LogFileMaxSize 2M
        LogTime yes
        PidFile /run/clamd.scan/clamd.pid
        DatabaseDirectory /var/lib/clamav
        TCPAddr 0.0.0.0
        TCPSocket 3310" >/etc/clamd.d/scan.conf

   # rv架构增加clamd@scan服务启动时间
    if [ "$(uname -m)" = "riscv64" ]; then
      mkdir -p /etc/systemd/system/clamd@scan.service.d
      echo -e "[Service]\nTimeoutStartSec=700" > /etc/systemd/system/clamd@scan.service.d/timeout.conf
      systemctl daemon-reload
    fi


    systemctl restart clamd@scan.service
    mkdir move_infected_dir copy_infected_dir
    echo "/var/lib/clamav
/opt" >testfile

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    clamdscan -v -l clamdscan_log /var/lib/clamav >/dev/null
    CHECK_RESULT $? 0 0 "Check clamdscan  -v -l clamdscan_log /var/lib/clamav failed."
    clamdscan --quiet /var/lib/clamav >/dev/null
    CHECK_RESULT $? 0 0 "Check clamdscan --quiet failed."
    clamdscan --remove /var/lib/clamav >/dev/null
    CHECK_RESULT $? 0 0 "Check clamdscan --remove failed."
    clamdscan --move=move_infected_dir /var/lib/clamav >/dev/null
    CHECK_RESULT $? 0 0 "Check clamdscan --move failed."
    clamdscan --copy=copy_infected_dir /var/lib/clamav >/dev/null
    CHECK_RESULT $? 0 0 "Check clamdscan --copy failed."
    clamdscan --config-file=/etc/clamd.d/scan.conf /var/lib/clamav >/dev/null
    CHECK_RESULT $? 0 0 "Check clamdscan --config-file failed."
    clamdscan -i /var/lib/clamav >/dev/null
    CHECK_RESULT $? 0 0 "Check clamdscan -i failed."
    clamdscan --no-summary /var/lib/clamav >/dev/null
    CHECK_RESULT $? 0 0 "Check clamdscan --no-summary failed."
    #clamdscan --file-list=testfile >/dev/null
     echo "[START] Scanning at $(date)"
    
    # 启用详细模式，每扫描一个文件就输出
    clamdscan --verbose --file-list="testfile" 2>&1 | while IFS= read -r line; do
        echo "$line"
        # 可选：实时写入日志文件
        echo "$line" >> /tmp/clamdscan_progress.log
    done
    
    echo "[END] Finished at $(date)"
    CHECK_RESULT $? 0 0 "Check clamdscan --file-list failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf /etc/clamd.d/scan.conf clamdscan_log move_infected_dir copy_infected_dir testfile
    mv /etc/clamd.d/scan.conf.bak /etc/clamd.d/scan.conf
    systemctl restart clamd@scan.service
    DNF_REMOVE "$@"

    LOG_INFO "End to restore the test environment."
}

main "$@"

