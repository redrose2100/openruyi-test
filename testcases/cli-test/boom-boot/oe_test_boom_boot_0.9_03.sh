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
source "${OET_PATH}/testcases/cli-test/boom-boot/common/checkenv.sh"


function pre_test() {
    # 判断boom-boot版本是否为0.9, 如果不是skip退出
    checkversion09
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "boom-boot"
    LOG_INFO "End to prepare the test environment"
}


function run_test() {
    LOG_INFO "Start to run testcase:oe_test_boom_boot_03."
    boom --osrelease "/boom/" profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --osrelease No Pass"
    boom --os-release "/boom/" profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --os-release No Pass"
    boom -p 12345 profile show
    CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"
    boom --profile 12345 profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --profile No Pass"
    boom -r root_device entry show
    CHECK_RESULT $? 0 0 "L$LINENO: -r No Pass"
    boom -root-device root_device entry show
    CHECK_RESULT $? 0 0 "L$LINENO: -root-device No Pass"
    boom -rootdevice root_device entry show
    CHECK_RESULT $? 0 0 "L$LINENO: -rootdevice No Pass"
    boom -R "/boot/initramfs-%{version}.img" entry show
    CHECK_RESULT $? 0 0 "L$LINENO: -R No Pass"
    boom --initramfs-pattern "/boot/initramfs-%{version}.img" entry show
    CHECK_RESULT $? 0 0 "L$LINENO: --initramfs-pattern No Pass"
    boom --initramfspattern "/boot/initramfs-%{version}.img" entry show
    CHECK_RESULT $? 0 0 "L$LINENO: --initramfspattern No Pass"
    boom --rows entry show
    CHECK_RESULT $? 0 0 "L$LINENO: --rows No Pass"
    boom --separator SEP entry show
    CHECK_RESULT $? 0 0 "L$LINENO: --separator No Pass"
    boom -s boom prifile show
    CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
    boom --short-name boom profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --short-name No Pass"
    boom --shortname boom profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --shortname No Pass"
    boom -t boom entry show
    CHECK_RESULT $? 0 0 "L$LINENO: -t No Pass"
    boom -title boom entry show
    CHECK_RESULT $? 0 0 "L$LINENO: -title No Pass"
    boom -u fc26 profile show
    CHECK_RESULT $? 0 0 "L$LINENO: -u No Pass"
    boom --uname-pattern fc26 profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --uname-pattern No Pass"
    boom --unamepattern fc26 profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --unamepattern No Pass"
    boom -V profile show
    CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"
    boom --verbose profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"
    boom -v "$(sed -n 's/^VERSION_ID=//p' /etc/os-release | tr -d '\"')" entry show
    CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
    boom --version "$(sed -n 's/^VERSION_ID=//p' /etc/os-release | tr -d '\"')" entry show
    CHECK_RESULT $? 0 0 "L$LINENO: --version No Pass"
    boom -k " " profile show
    CHECK_RESULT $? 0 0 "L$LINENO: -k No Pass"
    boom --kernel-pattern " " profile show
    CHECK_RESULT $? 0 0 "L$LINENO: --kernel-pattern No Pass"
    boom --kernelpattern " " profile show
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

