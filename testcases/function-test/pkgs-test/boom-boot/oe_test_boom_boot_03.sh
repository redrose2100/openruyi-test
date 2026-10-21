#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   jiangchenyang
#@Contact   :   jiangcy1129@163.com
#@Date      :   2023/9/05
#@License   :   Mulan PSL v2
#@Desc      :   Test "boom-boot" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "boom-boot"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_boom_boot_03."
    boom profile show --osrelease "/boom/" 
    CHECK_RESULT $? 0 0 "L$LINENO: --osrelease No Pass"
    boom profile show --os-release "/boom/" 
    CHECK_RESULT $? 0 0 "L$LINENO: --os-release No Pass"
    boom profile show -p 12345 
    CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"
    boom profile show --profile 12345 
    CHECK_RESULT $? 0 0 "L$LINENO: --profile No Pass"
    boom entry show -r root_device 
    CHECK_RESULT $? 0 0 "L$LINENO: -r No Pass"
    boom entry show --root-device root_device 
    CHECK_RESULT $? 0 0 "L$LINENO: -root-device No Pass"
    boom entry show --rootdevice root_device 
    CHECK_RESULT $? 0 0 "L$LINENO: -rootdevice No Pass"
    boom entry show -R "/boot/initramfs-%{version}.img" 
    CHECK_RESULT $? 0 0 "L$LINENO: -R No Pass"
    boom entry show --initramfs-pattern "/boot/initramfs-%{version}.img" 
    CHECK_RESULT $? 0 0 "L$LINENO: --initramfs-pattern No Pass"
    boom entry show --initramfspattern "/boot/initramfs-%{version}.img" 
    CHECK_RESULT $? 0 0 "L$LINENO: --initramfspattern No Pass"
    boom entry show --rows 
    CHECK_RESULT $? 0 0 "L$LINENO: --rows No Pass"
    boom entry show --separator SEP 
    CHECK_RESULT $? 0 0 "L$LINENO: --separator No Pass"
    boom profile show -s boom 
    CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
    boom profile show --short-name boom 
    CHECK_RESULT $? 0 0 "L$LINENO: --short-name No Pass"
    boom profile show --shortname boom 
    CHECK_RESULT $? 0 0 "L$LINENO: --shortname No Pass"
    boom entry show -t boom 
    CHECK_RESULT $? 0 0 "L$LINENO: -t No Pass"
    boom entry show --title boom 
    CHECK_RESULT $? 0 0 "L$LINENO: -title No Pass"
    boom profile show -u fc26 
    CHECK_RESULT $? 0 0 "L$LINENO: -u No Pass"
    boom profile show --uname-pattern fc26 
    CHECK_RESULT $? 0 0 "L$LINENO: --uname-pattern No Pass"
    boom profile show --unamepattern fc26 
    CHECK_RESULT $? 0 0 "L$LINENO: --unamepattern No Pass"
    boom profile show -V 
    CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"
    boom profile show --verbose 
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"
    boom entry show -v "$(sed -n 's/^VERSION_ID=//p' /etc/os-release | tr -d '\"')" 
    CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
    boom entry show --version "$(sed -n 's/^VERSION_ID=//p' /etc/os-release | tr -d '\"')" 
    CHECK_RESULT $? 0 0 "L$LINENO: --version No Pass"
    boom profile show -k " " 
    CHECK_RESULT $? 0 0 "L$LINENO: -k No Pass"
    boom profile show --kernel-pattern " " 
    CHECK_RESULT $? 0 0 "L$LINENO: --kernel-pattern No Pass"
    boom profile show --kernelpattern " " 
    CHECK_RESULT $? 0 0 "L$LINENO: --kernelpattern No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf boom.*
    LOG_INFO "End to restore the test environment."
}
main "$@"
