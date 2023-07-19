#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   liaoyuankun
#@Contact   :   1561203725@qq.com
#@Date      :   2023/8/05
#@License   :   Mulan PSL v2
#@Desc      :   Test "fonts-rpm-macros" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "fonts-rpm-macros"
    cat <<EOF >test.xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
  <!-- SPDX-License-Identifier: MIT -->
  <fontconfig>
    <group>
      <target>Tribun ADF Std</target>
      <like>
        <family>serif</family>
      </like>
    </group>
  </fontconfig>
EOF
    cat <<EOF >test.yaml
---
# SPDX-License-Identifier: MIT
- family:Tribun ADF Std:
    - like:
      - serif
...
EOF
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_texi2html."
    fc-weight -h | grep "usage: fc-weight"
    CHECK_RESULT $? 0 0 "L$LINENO: fc-weight -h No Pass"
    fc-weight -t 200 | grep "40"
    CHECK_RESULT $? 0 0 "L$LINENO: fc-weight -t No Pass"
    fc-weight -f 200 | grep "700"
    CHECK_RESULT $? 0 0 "L$LINENO: fc-weight -f No Pass"
    gen-fontconf -h | grep "usage: gen-fontconf"
    CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -h No Pass"
    gen-fontconf -x test.xml | grep "ADF"
    CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -x No Pass"
    gen-fontconf -y test.yaml | grep "family"
    CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -y No Pass"
    gen-fontconf -y test.yaml -l 123456 | grep "123456"
    CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -l No Pass"
    gen-fontconf -y test.yaml -m xml | grep "like"
    CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -m No Pass"
    gen-fontconf -y test.yaml -w && grep "ADF" test.conf
    CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -w No Pass"
    gen-fontconf -y test.yaml -o test.txt && grep "ADF" test.txt
    CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -o No Pass"
    gen-fontconf -y test.yaml -w -f | grep "test.conf"
    CHECK_RESULT $? 0 0 "L$LINENO: gen-fontconf -f No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.xml test.yaml test.conf test.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
