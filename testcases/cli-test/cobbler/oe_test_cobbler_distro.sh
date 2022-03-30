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
#@Date      :   2022/1/26
#@License   :   Mulan PSL v2
#@Desc      :   Test "cobbler distro" command
###################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL cobbler 
    DNF_INSTALL httpd
    mount /dev/cdrom /mnt
    systemctl start httpd
    systemctl start cobblerd
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase."
    cobbler distro add --name=OpenEuler --owners=root --boot-loader=grub --initrd=/mnt/images/pxeboot/initrd.img --kernel=/mnt/isolinux/vmlinuz
    CHECK_RESULT $? 0 0 0 "Failed option: distro add"
    cobbler distro copy --name=OpenEuler --newname=newOpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: distro copy"
    cobbler distro edit --name=openEuler --owners=tom
    CHECK_RESULT $? 0 0 0 "Failed option: distro edit"
    cobbler distro list 2>&1 | grep "newOpenEuler"
    CHECK_RESULT $? 0 0 0 "Failed option: distro list"
    cobbler distro find 2>&1 | grep "OpenEuler"
    CHECK_RESULT $? 0 0 0 "Failed option: distro find"
    cobbler distro remove --name=OpenEuler 
    CHECK_RESULT $? 0 0 0 "Failed option: distro remove"
    cobbler distro rename --name=newOpenEuler --newname=oldOpenEuler
    CHECK_RESULT $? 0 0 0 "Failed option: distro rename"
    cobbler distro report --name=oldopenEuler 2>&1 | grep "Name"
    CHECK_RESULT $? 0 0 0 "Failed option: distro report"
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
