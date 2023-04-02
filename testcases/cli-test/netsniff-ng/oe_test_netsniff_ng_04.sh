#!/usr/bin/bash
# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test netsniff-ng
# #############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "netsniff-ng tar"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    cat /etc/passwd | grep "bob"
    if [[ $? != 0 ]]; then
        useradd bob
    fi
    netsniff-ng --in any -u `id -u bob` -g `id -g bob` -n 1 > tmp.txt 2>&1
    grep "packets incoming" tmp.txt && grep "set system socket memory in" tmp.txt
    CHECK_RESULT $? 0 0 "Check netsniff-ng -u failed"
    netsniff-ng --in any --user `id -u bob` -g `id -g bob` -n 1 > tmp.txt 2>&1
    grep "packets incoming" tmp.txt && grep "set system socket memory in" tmp.txt
    CHECK_RESULT $? 0 0 "Check netsniff-ng --user failed"
    netsniff-ng --in any -u `id -u bob` -g `id -g bob` -n 1 > tmp.txt 2>&1
    grep "packets incoming" tmp.txt && grep "set system socket memory in" tmp.txt
    CHECK_RESULT $? 0 0 "Check netsniff-ng -g failed"
    netsniff-ng --in any -u `id -u bob` --group `id -g bob` -n 1 > tmp.txt 2>&1
    grep "packets incoming" tmp.txt && grep "set system socket memory in" tmp.txt
    CHECK_RESULT $? 0 0 "Check netsniff-ng --group failed"
    netsniff-ng --in any -H -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -H failed"
    netsniff-ng --in any --prio-high -n 1 | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --prio-high failed"
    netsniff-ng --in any -n 1 -q | grep "Vendor"
    CHECK_RESULT $? 1 0 "Check netsniff-ng -q failed"
    netsniff-ng --in any -n 1 --less | grep "Vendor"
    CHECK_RESULT $? 1 0 "Check netsniff-ng --less failed"
    netsniff-ng --in any -n 1 --notouch-irq | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --notouch-irq failed"
    netsniff-ng --in any -n 1 -Q | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -Q failed"
    netsniff-ng --in any -n 1 -s | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -s failed"
    netsniff-ng --in any -n 1 --silent | grep "packets incoming"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --silent failed"
    netsniff-ng --in any -n 1 -X | grep "Hex"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -X failed"
    netsniff-ng --in any -n 1 --hex | grep "Hex"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --hex failed"
    netsniff-ng --in any -n 1 -l | grep Chr
    CHECK_RESULT $? 0 0 "Check netsniff-ng -l failed"
    netsniff-ng --in any -n 1 --ascii | grep Chr
    CHECK_RESULT $? 0 0 "Check netsniff-ng --ascii failed"
    netsniff-ng --in any -n 1 -V | grep "Vendor"
    CHECK_RESULT $? 0 0 "Check netsniff-ng -V failed"
    netsniff-ng --in any -n 1 --verbose | grep "Vendor"
    CHECK_RESULT $? 0 0 "Check netsniff-ng --verbose failed"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    userdel -r bob
    rm -rf ./data/ ./common/*.sh
    LOG_INFO "End to restore the test environment."
}
main "$@"
