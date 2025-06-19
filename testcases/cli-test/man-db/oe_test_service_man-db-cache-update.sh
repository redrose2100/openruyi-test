#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test man-db-cache-update.service restart
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
source "$OET_PATH/testcases/cli-test/common/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    systemctl start man-db-cache-update.service   
    LOG_INFO "End of environmental preparation!"
}


function run_test() {
    LOG_INFO "Start testing..."

    test_oneshot man-db-cache-update.service 'inactive (dead)'
    LOG_INFO "Checking service execution result..."
    journalctl -u man-db-cache-update.service --no-pager | grep -q "成功完成\|success"
    CHECK_RESULT $? 0 0 "Service should show success indication in logs"

    LOG_INFO "Checking manual page cache update..."
    cache_file="/var/cache/man/index.db"
    test -f "$cache_file"
    CHECK_RESULT $? 0 0 "Cache file existence check failed"

    original_mtime=$(stat -c %Y "$cache_file")
    mv /usr/share/man/man1/vi.1.gz /usr/share/man/man1/vi.1.gz.bak
    systemctl restart man-db-cache-update.service
    sleep 2
    new_mtime=$(stat -c %Y "$cache_file")
    [ "$new_mtime" -gt "$original_mtime" ]
    CHECK_RESULT $? 0 0 "Cache update verification failed (original:$original_mtime, new:$new_mtime)"
    LOG_INFO "Finish test!"

}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    mv /usr/share/man/man1/vi.1.gz.bak /usr/share/man/man1/vi.1.gz  
    LOG_INFO "End to clean the test environment."
}
main "$@"
~
