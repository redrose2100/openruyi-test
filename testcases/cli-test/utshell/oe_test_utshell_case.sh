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
# @Date      :   2024.6.4
# @License   :   Mulan PSL v2
# @Desc      :   case using the utshell test command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "utshell"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."
  utshell -c "help case"|grep -i case
  CHECK_RESULT $? 0 0 "help case fail"
  cat >test.sh <<EOF
#!/bin/utshell
option=\$1
case \${option} in
-f) echo "param is -f"
;;
-d) echo "param is -d"
;;
*)
echo "\$0:usage: [-f ] | [ -d ]"
exit 1  #退出码
;;
esac
EOF
  utshell -c "utshell test.sh"
  CHECK_RESULT $? 1 0 "utshell test.sh fail"
  utshell -c "utshell test.sh -f"|grep "param is -f"
  CHECK_RESULT $? 0 0 "utshell test.sh -f fail"
  utshell -c "utshell test.sh -d"|grep "param is -d"
  CHECK_RESULT $? 0 0 "utshell test.sh -d fail"
  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  rm -rf test.sh
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"