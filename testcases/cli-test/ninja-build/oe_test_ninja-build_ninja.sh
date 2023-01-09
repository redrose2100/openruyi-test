
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of ninja-build command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh


function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "ninja-build gcc gcc-c++"
    cp ./common/dome.cpp ./
    cp ./common/build.ninja ./
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    ninja --help 2>&1 | grep "usage: ninja"
    CHECK_RESULT $? 0 0 "Check ninja --help failed"

    ninja -h 2>&1 | grep "usage: ninja"
    CHECK_RESULT $? 0 0 "Check ninja -h failed"

    ninja --version | grep "[[:digit:]]"
    CHECK_RESULT $? 0 0 "Check ninja --version failed"

    ninja -C ./common -v | grep "\-Wall \-Werror dome.o \-o dome"
    CHECK_RESULT $? 0 0 "ninja -C -v failed"

    rm -rf ./common/dome ./common/dome.o
    ninja -f build.ninja -j 2 -k 2 -l 2
    ./dome |grep "hello"
    CHECK_RESULT $? 0 0 "ninja -f build.ninja -j -k -l failed"

    rm -rf dome dome.o
    ninja -n -f build.ninja |grep "connect"
    CHECK_RESULT $? 0 0 "Check ninja -n -f build.ninja failed"

    ninja -d list 2>&1 | grep "debugging modes"
    CHECK_RESULT $? 0 0 "Check ninja -d list failed"

    ninja -t list 2>&1 | grep "ninja subtools"
    CHECK_RESULT $? 0 0 "Check ninja -t list failed"

    ninja -w list 2>&1 | grep "warning flags"
    CHECK_RESULT $? 0 0 "Check ninja -w list failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf dome.cpp build.ninja
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
