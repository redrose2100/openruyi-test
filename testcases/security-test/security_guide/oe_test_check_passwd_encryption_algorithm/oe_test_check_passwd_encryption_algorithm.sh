#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2020/05/29
# @License   :   Mulan PSL v2
# @Desc      :   The encryption algorithm of verifying setting password
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    grep "^test:" /etc/passwd && userdel -rf test
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    useradd test
    CHECK_RESULT $? 0 0 "add test failed"
    passwd test <<EOF
${NODE1_PASSWORD}
${NODE1_PASSWORD}
EOF
    # 默认口令哈希算法随发行版而变：$1$=MD5 $5$=SHA-256 $6$=SHA-512
    # $y$=yescrypt $2b$=bcrypt 等。这里只断言“口令以可识别的 crypt
    # 格式存放”，不再把算法写死成 SHA-512/MD5，否则换了默认算法的发行版
    # 会被误判成用例失败。
    grep '^test:' /etc/shadow | grep -qE ':\$[0-9a-zA-Z]+\$'
    CHECK_RESULT $? 0 0 "check test encryption algorithm failed"
    grep '^root:' /etc/shadow | grep -qE ':\$[0-9a-zA-Z]+\$'
    CHECK_RESULT $? 0 0 "check root encryption algorithm failed"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf test
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
