#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023-5-17
# @License   :   Mulan PSL v2
# @Desc      :   functional testing subversion
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"


function pre_test(){
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "subversion"
    /usr/bin/svnserve -d
    mkdir -p /var/svn/repos/project
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    svnadmin create /var/svn/repos/project
    svn mkdir file:///var/svn/repos/project/trunk -m "create"
    CHECK_RESULT $? 0 0 "Failed to create repos"
    svn mkdir file:///var/svn/repos/project/branches -m "create"
    CHECK_RESULT $? 0 0 "Failed to create branch"
    svn mkdir file:///var/svn/repos/project/tags -m "create"
    CHECK_RESULT $? 0 0 "Failed to create label"
    mkdir -p /home/project
    echo "test" >> /home/project/test.txt
    svn import /home/project file:///var/svn/repos/project/trunk -m "initial import"
    CHECK_RESULT $? 0 0 "Import file failed"
    svn list file:///var/svn/repos/project/trunk |grep test.txt
    CHECK_RESULT $? 0 0 "Can't find this file"
    LOG_INFO "Finish test!"
}
function post_test(){
    LOG_INFO "start environment cleanup."
    svn delete file:///var/svn/repos/project/trunk -m "test.txt" --force-log
    rm -rf /home/project /var/svn/repos/project
    pgrep svnserve |xargs kill -9
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"