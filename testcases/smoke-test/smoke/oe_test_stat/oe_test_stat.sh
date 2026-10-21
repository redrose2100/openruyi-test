#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/06/07
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of stat
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    stat --help | grep -iE "用法|Usage"
    CHECK_RESULT $? 0 0 "Failed to execute stat --help"
    stat --version | grep "Copyright"
    CHECK_RESULT $? 0 0 "Failed to execute stat --version"
    stat -c %D /etc/passwd | grep -iE "[-0-9]|[a-z]"
    CHECK_RESULT $? 0 0 "Failed to execute stat -c"
    stat --format "%Z" /etc/passwd
    CHECK_RESULT $? 0 0 "Failed to execute stat --format"

    ln -s non_existent_file broken_link
    stat -L broken_link
    CHECK_RESULT $? 1 0 "Failed to test broken link with -L option"
    mkdir test_dir
    ln -s test_dir dir_link
    stat -L dir_link
    CHECK_RESULT $? 0 0 "Failed to test directory link with -L option"
    attr_1=$(stat /usr/bin/yum |grep -iE 'Access|权限' |awk -F '/' '{print $1}' | awk -F '(' '{print $2}')
    attr_2=$(stat -L /usr/bin/yum |grep -iE 'Access|权限' |awk -F '/' '{print $1}' | awk -F '(' '{print $2}')
    CHECK_RESULT "${attr_1}" "${attr_2}" 1 "Failed to test access for file and dir with -L option"
    LOG_INFO "End to run test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf test_dir broken_link dir_link
  LOG_INFO "Finish environment cleanup!"
}


main "$@"
