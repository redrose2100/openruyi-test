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
source "$OET_PATH/testcases/function-test/pkgs-test/common/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # openRuyi 的 man-db 提供 man-db.service 与 man-db.timer（非 man-db-cache-update.service）
    systemctl start man-db.timer
    LOG_INFO "End of environmental preparation!"
}


function run_test() {
    LOG_INFO "Start testing..."

    test_oneshot man-db.service 'inactive (dead)'
    LOG_INFO "Checking service execution result..."
    # 原断言依赖中文/英文日志文案，改为校验 unit 执行结果
    _check_unit_result man-db.service
    CHECK_RESULT $? 0 0 "Service should report success result"

    LOG_INFO "Checking manual page cache update..."
    systemctl start man-db.service
    SLEEP_WAIT 2
    cache_file="/var/cache/man/index.db"
    test -f "$cache_file"
    CHECK_RESULT $? 0 0 "Cache file existence check failed"

    original_mtime=$(stat -c %Y "$cache_file")
    mv /usr/share/man/man1/vi.1.gz /usr/share/man/man1/vi.1.gz.bak
    systemctl restart man-db.service
    SLEEP_WAIT 2
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
