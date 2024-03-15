#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2024/03/07
# @License   :   Mulan PSL v2
# @Desc      :   Basic functional verification of jinja2
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL python3-jinja2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > test.py <<EOF
from jinja2 import Template

# 创建一个模板字符串
template_str = """
<html>
<body>
    <h1>Hello, {{ name }}!</h1>
</body>
</html>
"""

# 加载模板
template = Template(template_str)

# 渲染模板，传入变量
rendered_template = template.render(name="World")

# 输出渲染后的结果
print(rendered_template)
EOF
    test -f test.py
    CHECK_RESULT $? 0 0 " File generation failed"
    python3 test.py  |grep "Hello"
    CHECK_RESULT $? 0 0 "Execution failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test.py
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"