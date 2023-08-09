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
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.8.8
# @License   :   Mulan PSL v2
# @Desc      :   python-mako formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){

cat > /tmp/python3-mako.py << EOF
from mako.template import Template
t = Template('hello world!')
print(t.render())
EOF

    LOG_INFO "Start environment preparation."
    DNF_INSTALL "python3-mako"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep python3-mako
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && python3 python3-mako.py > mako_test
    test -f /tmp/mako_test
    CHECK_RESULT $? 0 0 "compile python3-mako fail"    
    grep "hello world!" /tmp/mako_test
    CHECK_RESULT $? 0 0 "mako_test file error"   
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/python3-mako.py /tmp/mako_test
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
