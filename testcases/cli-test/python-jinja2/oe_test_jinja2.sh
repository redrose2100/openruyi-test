#!/usr/bin/bash

# Copyright (c) 2024  INSPUR Co., Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   koulq
# @Contact   :   koulq@inspur.com
# @Date      :   2024.3.23
# @License   :   Mulan PSL v2
# @Desc      :   Test python3-httplib2
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."

    cat > /tmp/template.html  <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>{{ title }}</title>
</head>
<body>
    <h1>Hello, {{ name }}!</h1>
</body>
</html>
EOF
    cat > /tmp/test-jinja2.py  <<EOF
import unittest
from jinja2 import Template
class TestJinja2Template(unittest.TestCase):

    def test_render_template(self):
        # Read the template file
        with open('/tmp/..html') as file:
            template_content = file.read()

        # Create a template object
        template = Template(template_content)

        # Render the template, and upload in the variable
        output = template.render(title="Jinja2 Test", name="zhangsan")

        # Assert whether the rendering results meet expectations
        self.assertIn("<title>Jinja2 Test</title>", output)
        self.assertIn("<h1>Hello, zhangsan!</h1>", output)

if __name__ == '__main__':
    unittest.main()
EOF
    DNF_INSTALL "python-jinja2"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    rpm -qa | grep python3-jinja2
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && python3 test-jinja2.py > /tmp/jinja2_test 2>&1
    test -f /tmp/jinja2_test
    CHECK_RESULT $? 0 0 "Generate test fail "
    grep "Ran 1 test" /tmp/jinja2_test
    CHECK_RESULT $? 0 0 "jinja2_test is error" 
    LOG_INFO "End to run test."  
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test-jinja2.py /tmp/jinja2_test /tmp/template.html
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

