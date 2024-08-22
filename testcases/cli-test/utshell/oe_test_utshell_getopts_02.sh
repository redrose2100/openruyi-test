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
# @Author    :   jingxiaohui
# @Contact   :   jingxiaohui@uniontech.com
# @Date      :   2024.8.5
# @License   :   Mulan PSL v2
# @Desc      :   getopts using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "getopts --help"|grep -i "getopts"
  CHECK_RESULT $? 0 0 "getpots --help fail"
  utshell -c cat >test.sh <<EOF
#!/bin/utshell
while getopts ":sn:i:d:p:" opt; do
case \$opt in
n)
echo "选项-\$opt的值是$OPTARG"
;;
s)
echo "选项-\$opt"
;;
d)
echo "选项-\$opt的值是\$OPTARG"
;;
i)
echo "选项-\$opt的值是\$OPTARG"
;;
p)
echo "选项-\$opt的值是\$OPTARG"
;;
:)
echo "选项-\$OPTARG后面需要一个参数值"
exit 1
;;
?)
echo "无效的选项 -\$OPTARG"
exit 2
;;
esac
done
EOF
  utshell -c "utshell test.sh -s -n testname -i love -d /usr/local/ -p"|grep -E "s|n|love|local|参数值"
  CHECK_RESULT $? 0 0 "utshell test.sh fail"
  LOG_INFO "End of the test."
}
  
function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf test.sh
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}
main "$@"