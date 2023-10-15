#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wangxiaorou
#@Contact       :   wangxiaorou@uniontech.com
#@Date          :   2023-04-03
#@License       :   Mulan PSL v2
#@Desc          :   Login is not allowed for a non-interactive account
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    id account1 && userdel -rf account1
    useradd account1
    echo "openeuler12#$" |passwd account1 --stdin
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat /etc/passwd |awk -F ":" '{print $1}' > UserList.info
    while read line;do
        if [[ "$(getent passwd $line |awk -F ":" '{print $2}')" != "x" ]];then
            echo "$line 2nd field is not x in /etc/passwd" > ErrorUserList.info
        elif [[ "$(getent passwd $line |awk -F ":" '{print $NF}')" != "/bin/bash" ]];then
            getent shadow $line |awk -F ":" '{print $2}' |grep -E -w '\*|!|!!'
            CHECK_RESULT $? 0 0 "non-interactive account is locked"
        else
            getent shadow $line |awk -F ":" '{print $2}' |grep -E "\\\$6\\\$|\\\$y\\\$"
            CHECK_RESULT $? 0 0 "password of interactive account is set"
        fi
    done < UserList.info
    ls ./ErrorUserList.info
    CHECK_RESULT $? 0 1 "user's password is stored in /etc/shadow"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    id account1 && userdel -rf account1
    test -f ./ErrorUserList.info && rm -rf ./ErrorUserList.info
    test -f ./UserList.info && rm -rf ./UserList.info
    LOG_INFO "End to restore the test environment."
}

main "$@"

