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
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL libfabric
    P_SSH_CMD --node 2 --cmd "dnf -y install libfabric"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    fi_pingpong -p usnic -B 47592 -I 10 -S 1024 &
    CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
    echo P_SSH_CMD --node 2 --cmd "fi_pingpong -B 47592 -I 10 -S all -c -m msg ${NODE2_IPV4}"
    CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
    fi_pingpong -P 47592 -p -d -e -m msg &
    CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
    echo P_SSH_CMD --node 2 --cmd "fi_pingpong -p verbs -e msg -v -m host ${NODE2_IPV4}"
    CHECK_RESULT $? 0 0 "Check fi_pingpong -p -e -v -m failed"
    fi_pingpong -P 47592 -p sockets &
    CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
    echo P_SSH_CMD --node 2 --cmd "fi_pingpong -P 47592 -p sockets ${NODE2_IPV4}"
    CHECK_RESULT $? 0 0 "Check fi_pingpong -P -p failed"
    fi_pingpong -p sockets &
    CHECK_RESULT $? 0 0 "Check fi_pingpong -p failed"
    echo P_SSH_CMD --node 2 --cmd "fi_pingpong -p sockets ${NODE2_IPV4}"
    CHECK_RESULT $? 0 0 "Check fi_pingpong -p failed"
    fi_pingpong -p verbs -e msg -v &
    CHECK_RESULT $? 0 0 "Check fi_pingpong -e -v failed"
    echo P_SSH_CMD --node 2 --cmd "fi_pingpong -p verbs -e msg -v host ${NODE2_IPV4}"
    CHECK_RESULT $? 0 0 "Check fi_pingpong -p -e -v failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ps -ef | grep fi_pingpong | grep -v grep | awk '{print $2}' | xargs kill -9
    DNF_REMOVE
    P_SSH_CMD --node 2 --cmd "ps -ef | grep fi_pingpong | grep -v grep | awk '{print $2}' | xargs kill -9 && dnf -y remove libfabric"
    LOG_INFO "End to restore the test environment."
}

main $@
