# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   duxiao
# @Contact   :   duxiao13@h-partners.com
# @Date      :   2024/10/22
# @License   :   Mulan PSL v2
# @Desc      :   验证filecap基本命令
# ##############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
testdir=testdir"$RANDOM"
testfile1=test"$RANDOM"1
testfile2=test"$RANDOM"2
path=$(pwd)/"$testdir"

function pre_test() {
    which filecap || yum install libcap-ng libcap-ng-utils -y
}

function run_test() {
    #创建一个文件夹和两个文件
    mkdir "$testdir" && touch "$testdir"/"$testfile1" "$testdir"/"$testfile2"
    CHECK_RESULT $? 0 0
    #给文件添加capabilities
    filecap "$path"/"$testfile1" sys_time && filecap "$path"/"$testfile2" sys_time
    CHECK_RESULT $? 0 0
    #获取文件的capabilities
    filecap "$path"/"$testfile1" | grep "sys\_time"
    CHECK_RESULT $? 0 0

    filecap "$path"/"$testfile2" | grep "sys\_time"
    CHECK_RESULT $? 0 0
    #获取testdir目录下文件的capabilities
    filecap "$path" | grep "$testfile1" && filecap "$path" | grep "$testfile1"
    CHECK_RESULT $? 0 0
    #移除文件的capabilities
    filecap "$path"/"$testfile1" none && filecap "$path"/"$testfile2" none
    CHECK_RESULT $? 0 0
    #再次获取文件的capabilities
    get_filecap=$(filecap "$path")
    test -z "$get_filecap"
}

function post_test() {
    rm -rf "$testdir"
}

main "$@"
