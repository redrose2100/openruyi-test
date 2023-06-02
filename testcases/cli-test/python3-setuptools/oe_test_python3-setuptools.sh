#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023/06.02
# @License   :   Mulan PSL v2
# @Desc      :   python3-setuptools functional testing
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-setuptools"
    basedir=$(pwd)
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mkdir demo && cd demo || exit
    touch __init__.py
    cat > setup.py << EOF
from setuptools import setup, find_packages
setup(
    name="demo",   # 打包后的包名
    version="1.1.1",    # 版本名称
    package=find_packages(),  # 自动寻找当前目录的项目包（项目包含 __init__.py 文件）
)
EOF
    test -f __init__.py -a setup.py
    CHECK_RESULT $? 0 0 "File creation failed"
    python3 setup.py bdist_egg
    CHECK_RESULT $? 0 0 "Script execution failed"
    test -d build -a -d demo.egg-info -a -d dist
    CHECK_RESULT $? 0 0 "Failed to generate file"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd "$basedir" || exit
    rm -rf demo
    DNF_REMOVE "$@"
    LOG_INFO "Finish restoring the test environment."
}

main "$@"


