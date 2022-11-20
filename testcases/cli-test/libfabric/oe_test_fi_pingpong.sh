# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of libfabric command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {

  LOG_INFO "Start environmental preparation."

  DNF_INSTALL libfabric
  P_SSH_CMD --node 3 --cmd "dnf -y install socat"

  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  fi_pingpong -B 47592 -I 1 -S all -c -m msg &
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  echo P_SSH_CMD --node 3 --cmd "fi_pingpong -B 47592 -I 10 -S all -c -m msg ${NODE2_IPV4} "

  fi_pingpong -P 47592 -p -d -e -m msg &
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  echo P_SSH_CMD --node 3 --cmd "fi_pingpong -p verbs -e msg -v -m host  ${NODE2_IPV4} "

  fi_pingpong -P 47592 -p sockets &
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  echo P_SSH_CMD --node 3 --cmd "fi_pingpong -P 47592 -p sockets  ${NODE2_IPV4} "

  fi_pingpong -p sockets &
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  echo P_SSH_CMD --node 3 --cmd "fi_pingpong -p sockets   ${NODE2_IPV4} "

  fi_pingpong -p verbs -e msg -v &
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  echo P_SSH_CMD --node 3 --cmd "fi_pingpong -p verbs -e msg -v host   ${NODE2_IPV4} "

  fi_pingpong -I 10 -S all &
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  echo P_SSH_CMD --node 3 --cmd "fi_pingpong -I 10 -S all  ${NODE2_IPV4} "

  fi_pingpong -I 10 -S all &
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  echo P_SSH_CMD --node 3 --cmd "fi_pingpong -I 10 -S all  ${NODE2_IPV4} "

  fi_pingpong -I 10 -S all -c &
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  echo P_SSH_CMD --node 3 --cmd "fi_pingpong -I 10 -S all  ${NODE2_IPV4} "

  fi_pingpong -I 10 -S all -m msg &
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  echo P_SSH_CMD --node 3 --cmd "fi_pingpong -I 10 -S all -m msg  ${NODE2_IPV4} "

  fi_pingpong -h 2>&1 | grep 'Usage:'
  CHECK_RESULT $? 0 0 "Check fi_pingpong -h failed"

  LOG_INFO "End of the test."
}

function post_test() {

  LOG_INFO "Start to restore the test environment."
  P_SSH_CMD --node 3 --cmd "ps -ef | grep libfabric | grep -v grep | awk '{print $2}' | xargs kill -9"

  P_SSH_CMD --node 3 --cmd "dnf -y remove libfabric"

  DNF_REMOVE

  LOG_INFO "Finish restoring the test environment."

}

main $@
