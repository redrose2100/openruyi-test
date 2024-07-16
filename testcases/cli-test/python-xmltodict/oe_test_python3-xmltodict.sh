#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2024/02/23
# @License   :   Mulan PSL v2
# @Desc      :   test python3-xmltodict
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "python3-xmltodict"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  cat > test.py << EOF
# 将XML格式转换为Python字典的Python包
import xmltodict

# 定义一个XML字符串
xml_string = """
<bookstore>
  <book category="children">
    <title lang="en">The Cat in the Hat</title>
    <author>Dr. Seuss</author>
    <year>1957</year>
    <price>6.99</price>
  </book>
  <book category="web">
    <title lang="en">Learning XML</title>
    <author>Erik T. Ray</author>
    <year>2003</year>
    <price>39.95</price>
  </book>
</bookstore>
"""

# 将XML转换为Python字典
bookstore_dict = xmltodict.parse(xml_string)

# 打印Python字典
print(bookstore_dict)
EOF
  python3 test.py | grep "The Cat in the Hat"
  CHECK_RESULT $? 0 0 "Failed to convert XML format to Python dictionary"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  rm -rf test.py
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
