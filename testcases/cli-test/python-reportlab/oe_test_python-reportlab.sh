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
# @Date      :   2023/08.01
# @License   :   Mulan PSL v2
# @Desc      :   python-reportlab function test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  DNF_INSTALL "python3-reportlab poppler-utils"
  LOG_INFO "Finish preparing the test environment."
}

function run_test() {
  LOG_INFO "Start to run test."
  cat > python3-reportlab-test.py << EOF
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
  CHECK_RESULT $? 0 0 "Command execution failed to create Python file"
  test -e python3-reportlab-test.py
  CHECK_RESULT $? 0 0 "python3-reportlab-test.py is not found"
  python3 python3-reportlab-test.py
  CHECK_RESULT $? 0 0 "Command execution failed"
  test -e shapes.pdf
  CHECK_RESULT $? 0 0 "python3-reportlab-test.py is not found"
  pdfinfo shapes.pdf | grep 'ReportLab PDF Library'
  CHECK_RESULT $? 0 0 "PDF comparison failed"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  rm -rf python3-reportlab-test.py shapes.pdf
  DNF_REMOVE "$@"
  LOG_INFO "Finish restoring the test environment."
}

main "$@"
