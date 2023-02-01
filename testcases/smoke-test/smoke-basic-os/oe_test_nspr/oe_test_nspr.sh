#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2023-02-01
# @License   :   Mulan PSL v2
# @Desc      :   package nspr test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    yum install nspr-devel -y
    CHECK_RESULT $? 0 0 "Error reported when installing nspr-devel failed"
    rpm -qa nspr
    CHECK_RESULT $? 0 0 "rpm -qa nspr Query failed" 
    rpm -qa nspr-devel
    CHECK_RESULT $? 0 0 "rpm -qa nspr-devel Query failed"
    rpm -qi nspr-devel
    CHECK_RESULT $? 0 0 "rpm -qi nspr-devel Query failed"
    rpm -ql nspr-devel
    CHECK_RESULT $? 0 0 "rpm -ql nspr-devel Failed to query directory"
    yum remove nspr-devel -y
    CHECK_RESULT $? 0 0 "nspr-devel uninstall failed"
    rpm -ql nspr-devel
    CHECK_RESULT $? 0 1 "rpm -ql nspr-devel Software package not installed"
    LOG_INFO "Finish test!"
}

main $@
