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
# @Date      :   2023.7.13
# @License   :   Mulan PSL v2
# @Desc      :   Testing the Python setuptools package
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    cat > /tmp/setup.py <<EOF
from setuptools import setup, find_packages
setup(
    name="demo",  
    version="1.1.1",    
    package=find_packages(),
)
EOF
    DNF_INSTALL "python-setuptools python-setuptools-help python2-setuptools python3-setuptools"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep setuptools
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && touch  __init__.py
    python3 setup.py bdist_egg
    CHECK_RESULT $? 0 0 "setuptools execute fail"    
    test -d /tmp/build -a /tmp/demo.egg-info -a /tmp/dist
    CHECK_RESULT $? 0 0 "Generate log fail "
    test -f /tmp/dist/demo-1.1.1-py3.7.egg
    CHECK_RESULT $? 0 0 "Generate directory fail "   
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/setup.py /tmp/__init__.py /tmp/dist /tmp/demo.egg-info /tmp/build
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

