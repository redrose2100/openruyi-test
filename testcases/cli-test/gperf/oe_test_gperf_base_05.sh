source ${OET_PATH}/libs/locallibs/common_lib.sh
# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/11/22
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of mpich command
# ############################################


function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL gperf
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    mkdir tmp

    gperf -W'NAME' ./common/test.gperf > ./tmp/test.hpp
    CHECK_RESULT $? 0 0 "Check gperf  -W  failed."

    gperf --word-array-name='NAME' ./common/test.gperf > ./tmp/test.hpp
    CHECK_RESULT $? 0 0 "Check gperf --word-array-name   failed."

    gperf --length-table-name='NAME' ./common/test.gperf > ./tmp/test.hpp
    CHECK_RESULT $? 0 0 "Check gperf --length-table-name failed."

    gperf -S '10' ./common/test.gperf > ./tmp/test.hpp
    CHECK_RESULT $? 0 0 "Check gperf  -S  failed."

    gperf --switch='10' ./common/test.gperf > ./tmp/test.hpp
    CHECK_RESULT $? 0 0 "Check gperf  --switch  failed."

    gperf -T ./common/test.gperf > ./tmp/test.hpp
    CHECK_RESULT $? 0 0 "Check gperf -T   failed."

    gperf --omit-struct-type ./common/test.gperf > ./tmp/test.hpp
    CHECK_RESULT $? 0 0 "Check gperf  --omit-struct-type  failed."

    gperf -k '*' ./common/test.gperf > ./tmp/test.hpp
    CHECK_RESULT $? 0 0 "Check gperf -k   failed."

    gperf --key-positions='*' ./common/test.gperf >  ./tmp/test.hpp
    CHECK_RESULT $? 0 0 "Check gperf  --key-positions  failed."

    gperf -D ./common/test.gperf > ./tmp/test.hpp
    CHECK_RESULT $? 0 0 "Check gperf -D   failed."


    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE gperf

    LOG_INFO "Finish restoring the test environment."
}

main $@