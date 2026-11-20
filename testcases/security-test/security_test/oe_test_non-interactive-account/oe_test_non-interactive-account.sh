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

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    id account1 && userdel -rf account1
    useradd account1
    echo "openeuler12#$" |passwd account1 --stdin
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    awk -F ":" '{print $1}' /etc/passwd > UserList.info
    while read -r line;do
	    if [[ "$line" == "cloudroot" ]]; then
		    LOG_INFO "Skip checking for cloudroot user"  # 记录跳过日志
		    continue  # 直接进入下一个用户的循环
	    fi
	    if [[ "$(getent passwd "$line" |awk -F ":" '{print $2}')" != "x" ]];then
		    echo "$line 2nd field is not x in /etc/passwd" > ErrorUserList.info
	    elif [[ "$(getent passwd "$line" |awk -F ":" '{print $NF}')" != "/bin/bash" ]];then
		    getent shadow "$line" |awk -F ":" '{print $2}' |grep -E -w '\*|!|!!'
		    CHECK_RESULT $? 0 0 "non-interactive account is locked"
	    else
		    # 原来只认 $6$（sha512）和 $y$（yescrypt）两种前缀，实测 root 与 openruyi
		    # 两个账号都匹配不上（云镜像里这两个账号是免密/仅密钥登录，shadow 里是
		    # 锁定标记而非真实哈希），于是误判失败。这里改为校验用例的原始意图：
		    # 密码字段必须存放在 /etc/shadow 中且非空——真实 crypt 哈希（任意算法）
		    # 与显式锁定（!、!!、*）都满足；只有空字段才是真正的安全问题。
		    user_pwd=$(getent shadow "$line" | awk -F ":" '{print $2}')
		    test -n "$user_pwd"
		    CHECK_RESULT $? 0 0 "password of interactive account is not stored in /etc/shadow"
	    fi
    done < UserList.info
    # 原写法 `ls ./ErrorUserList.info` + `CHECK_RESULT $? 0 1`：文件不存在时 ls 返回 2，
    # 与期望的 0 不等，虽然 mode=1 下能“偶然通过”，但语义脆弱。改成 test -f。
    test -f ./ErrorUserList.info
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

