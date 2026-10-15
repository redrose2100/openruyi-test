#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   xiaochn
#@Contact       :   xiaochuannan@inspur.com
#@Date          :   2024-11-22
#@License       :   Mulan PSL v2
#@Desc          :   openEuler-lsb test basic function of lsb_release
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "lsb"
    DISTRIB_DESC=$(head -n 1 /etc/system-release 2>/dev/null)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    DISTRIBUTOR_MSG="Distributor ID:\t"
    DESCRIPTION_MSG="Description:\t"
    RELEASE_MSG="Release:\t"
    CODENAME_MSG="Codename:\t"

    [[ "$(lsb_release -v)" == *"LSB Version:"* ]]
    CHECK_RESULT $? 0 0 "lsb_release -v failed!"

    LSB_RELEASE_I=$(lsb_release -i | sed -e "s/$DISTRIBUTOR_MSG//")
    [[ "$DISTRIB_DESC" == *"$LSB_RELEASE_I"* ]]
    CHECK_RESULT $? 0 0 "lsb_release -i failed!"

    LSB_RELEASE_D=$(lsb_release -d | sed -e "s/$DESCRIPTION_MSG//")
    [[ "$DISTRIB_DESC" == *"$LSB_RELEASE_D"* ]]
    CHECK_RESULT $? 0 0 "lsb_release -d failed!"

    LSB_RELEASE_R=$(lsb_release -r | sed -e "s/$RELEASE_MSG//")
    [[ "$DISTRIB_DESC" == *"$LSB_RELEASE_R"* ]]
    CHECK_RESULT $? 0 0 "lsb_release -r failed!"

    LSB_RELEASE_C=$(lsb_release -c | sed -e "s/$CODENAME_MSG//")
    [[ "$DISTRIB_DESC" == *"$LSB_RELEASE_C"* ]] || [[ "n/a" == *"$LSB_RELEASE_C"* ]]
    CHECK_RESULT $? 0 0 "lsb_release -c failed!"

    lsb_release -s
    CHECK_RESULT $? 0 0 "lsb_release -s failed!"

    LSB_RELEASE_A=$(lsb_release -a)
    DISTRIBUTOR=$(echo -e "$DISTRIBUTOR_MSG$LSB_RELEASE_I")
    DESCRIPTION=$(echo -e "$DESCRIPTION_MSG$LSB_RELEASE_D")
    RELEASE=$(echo -e "$RELEASE_MSG$LSB_RELEASE_R")
    CODENAME=$(echo -e "$CODENAME_MSG$LSB_RELEASE_C")
    [[ "$LSB_RELEASE_A" == *"$DISTRIBUTOR"* && \
    "$LSB_RELEASE_A" == *"$DESCRIPTION"* && \
    "$LSB_RELEASE_A" == *"$RELEASE"* && \
    "$LSB_RELEASE_A" == *"$CODENAME"* ]]
    CHECK_RESULT $? 0 0 "lsb_release -a failed!"

    lsb_release -h | grep 'Usage'
    CHECK_RESULT $? 0 0 "lsb_release -h failed!"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
