#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-8-8
# @License   :   Mulan PSL v2
# @Desc      :   Use python3-reportlab case
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-reportlab"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > test.py << EOF
#!/usr/bin/python3
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas

w, h = A4
c = canvas.Canvas("shapes.pdf", pagesize=A4)
c.drawString(30, h - 50, "Line")
x = 120
y = h - 45
c.line(x, y, x + 100, y)
c.drawString(30, h - 100, "Rectangle")
c.rect(x, h - 120, 100, 50)
c.drawString(30, h - 170, "Circle")
c.circle(170, h - 165, 20)
c.drawString(30, h - 240, "Ellipse")
c.ellipse(x, y - 170, x + 100, y - 220)
c.showPage()
c.save()
EOF
    CHECK_RESULT $? 0 0 "Error, Fail to create test.py"
    python3 test.py
    CHECK_RESULT $? 0 0 "Error, Check test.py"
    test -e shapes.pdf
    CHECK_RESULT $? 0 0 "Error, Fail to create shapes.pdf"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm test.py shapes.pdf
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
