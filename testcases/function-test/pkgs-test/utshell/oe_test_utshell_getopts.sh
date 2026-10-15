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
# @Date      :   2024.8.2
# @License   :   Mulan PSL v2
# @Desc      :   If using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  utshell -c cat >getopts.sh<<EOF
while getopts :abc:e:f:h argvs; do
case \$argvs in
a) echo "这是执行-a的效果" ;;
b) echo "这是执行-b的效果" ;;
c) echo "这是执行-c的效果及参数值：\${OPTARG}" ;;
e) echo "这是执行-e的效果及参数值： \${OPTARG}" ;;
esac
done
EOF
  utshell -c "cat getopts.sh"|grep -i 'done'
  CHECK_RESULT $? 0 0 "utshell getopts.sh fail"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c 'utshell ./getopts.sh -a -b -c "xxoo" -e "vvoo"'|grep -E "xxoo|vvoo"
  CHECK_RESULT $? 0 0 "utshell test fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf getopts.sh
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}
main "$@"