#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   qinhaiqi
#@Contact   :   2683064908@qq.com
#@Date      :   2022/2/16
#@License   :   Mulan PSL v2
#@Desc      :   Test "cobbler system" command
###################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL cobbler httpd
    mount /dev/cdrom /mnt
    systemctl start httpd
    systemctl start cobblerd
    cobbler distro add --name=OpenEuler --owners=root --boot-loader=grub --initrd=/mnt/images/pxeboot/initrd.img --kernel=/mnt/isolinux/vmlinuz
    cobbler profile add --name=OpenEuler --distro=OpenEuler    
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase."
    cobbler system add --name=OpenEuler --profile=oldOpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: system add"
    cobbler system copy --name=OpenEuler --newname=newOpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: system copy"
    cobbler system dumpvars --name=OpenEuler | grep "allow_duplicate_hostnames"
    CHECK_RESULT $? 0 0 0 "Failed option: system dumpvars"
    cobbler system edit --name=openEuler --owners=tom
    CHECK_RESULT $? 0 0 0 "Failed option: system edit"
    cobbler system list 2>&1 | grep "newOpenEuler"
    CHECK_RESULT $? 0 0 0 "Failed option: system list"
    cobbler system find 2>&1 | grep "OpenEuler"
    CHECK_RESULT $? 0 0 0 "Failed option: system find"
    cobbler system remove --name=OpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: system remove"
    cobbler system rename --name=newOpenEuler --newname=oldOpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: system rename"
    cobbler system report --name=oldOpenEuler 2>&1 | grep "Name"
    CHECK_RESULT $? 0 0 0 "Failed option: system report"
    cobbler system get-autoinstall --name=oldOpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: system get-autoinstall"
    cobbler system poweroff --name=oldOpenEuler | grep "*** TASK COMPLETE ***"
    CHECK_RESULT $? 0 0 0 "Failed option: system poweroff"    
    cobbler system poweron --name=oldOpenEuler | grep "*** TASK COMPLETE ***"
    CHECK_RESULT $? 0 0 0 "Failed option: system poweron"
    cobbler system powerstatus --name=oldOpenEuler | grep "*** TASK COMPLETE ***"
    CHECK_RESULT $? 0 0 0 "Failed option: system powerstatus"
    cobbler system reboot --name=oldOpenEuler | grep "*** TASK COMPLETE ***"
    CHECK_RESULT $? 0 0 0 "Failed option: system reboot"
    LOG_INFO "End to run testcase."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    umount /dev/cdrom
    systemctl stop httpd
    systemctl stop cobblerd
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
