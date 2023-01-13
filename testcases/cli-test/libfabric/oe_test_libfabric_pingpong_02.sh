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
    fi_pingpong -p usnic -I 1000 -S 1024 &
    CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
    echo P_SSH_CMD --node 2 --cmd "fi_pingpong -I 10 -S all ${NODE2_IPV4}"
    CHECK_RESULT $? 0 0 "Check fi_pingpong -I -S failed"
    fi_pingpong -p usnic -I 1000 -S 1024 &
    CHECK_RESULT $? 0 0 "Check fi_pingpong -p -I -S failed"
    echo P_SSH_CMD --node 2 --cmd "fi_pingpong -I 10 -S all ${NODE2_IPV4}"
    CHECK_RESULT $? 0 0 "Check fi_pingpong -I -S failed"
    fi_pingpong -p usnic -I 1000 -S 1024 -c &
    CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c failed"
    echo P_SSH_CMD --node 2 --cmd "fi_pingpong -B -I -S -c all ${NODE2_IPV4}"
    fi_pingpong -I 10 -S all -m msg &
    CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
    echo P_SSH_CMD --node 2 --cmd "fi_pingpong -I 10 -S all -m msg ${NODE2_IPV4} "
    CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -m failed"
    fi_pingpong -h 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Check fi_pingpong -h failed"
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
