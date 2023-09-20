#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.


# #############################################
# @Author    :   cuikeyu
# @Contact   :   cky2536184321@163.com
# @Date      :   2023/09/20
# @License   :   Mulan PSL v2
# @Desc      :   Test vdo
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "vdo"
    dd if=/dev/zero of=vdo_test_device bs=1M count=10240
    losetup /dev/loop0 vdo_test_device
    vdo create -n my_vdo_volume --device /dev/loop0
    LOG_INFO "End to prepare the test environment"
}
##########################################################

##########################################################

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_vdo."

    ### oe_test_vdo_01 ###
    vdo deactivate --help | grep "usage: vdo deactivate"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"

    vdo deactivate -a | grep "Deactivating"
    CHECK_RESULT $? 0 0 "L$LINENO: --a No Pass"

    vdo deactivate -n my_vdo_volume | grep "already deactivated"
    CHECK_RESULT $? 0 0 "L$LINENO: --n No Pass"

    vdo deactivate -n my_vdo_volume -f /etc/vdoconf.yml | grep "already deactivated"
    CHECK_RESULT $? 0 0 "L$LINENO: --f <file> No Pass"

    touch /var/log/vdo_deactivate.log
    vdo activate -n my_vdo_volume
    vdo deactivate -n my_vdo_volume --logfile /var/log/vdo_deactivate.log | grep "Deactivating VDO"
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile <pathname> No Pass"
    sudo rm /var/log/vdo_deactivate.log
    
    vdo deactivate --verbose -n my_vdo_volume | grep "already deactivated"
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"
    vdo activate -n my_vdo_volume


    ### oe_test_vdo_02 ###
    vdo disableCompression --help | grep "usage: vdo disableCompression"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"

    vdo disableCompression -a
    CHECK_RESULT $? 0 0 "L$LINENO: --a No Pass"

    vdo disableCompression -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: -n No Pass"

    vdo disableCompression --verbose -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"


    vdo disableCompression -n my_vdo_volume -f /etc/vdoconf.yml
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"

    touch /var/log/vdo_disableCompression.log
    vdo disableCompression -n my_vdo_volume --logfile /var/log/vdo_disableCompression.log
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile No Pass"
    sudo rm /var/log/vdo_disableCompression.log

    vdo disableDeduplication --help | grep "usage: vdo disableDeduplication"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
    vdo disableDeduplication -a
    CHECK_RESULT $? 0 0 "L$LINENO: --a No Pass"
    vdo disableDeduplication -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --n No Pass"
    vdo disableDeduplication --verbose -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"
    vdo disableDeduplication -n my_vdo_volume -f /etc/vdoconf.yml
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    touch /var/log/vdo_disableDeduplication.log
    vdo disableDeduplication -n my_vdo_volume --logfile /var/log/vdo_disableDeduplication.log
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile No Pass"
    sudo rm /var/log/vdo_disableDeduplication.log

    vdo enableCompression --help | grep "usage: vdo enableCompression"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
    vdo enableCompression -a
    CHECK_RESULT $? 0 0 "L$LINENO: --a No Pass"
    vdo enableCompression -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --n No Pass"
    vdo enableCompression --verbose -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"
    vdo enableCompression -n my_vdo_volume -f /etc/vdoconf.yml
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    touch /var/log/vdo_enableCompression.log
    vdo enableCompression -n my_vdo_volume --logfile /var/log/vdo_enableCompression.log
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile No Pass"
    sudo rm /var/log/vdo_enableCompression.log

    vdo enableDeduplication --help | grep "usage: vdo enableDeduplication"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
    vdo enableDeduplication -a
    CHECK_RESULT $? 0 0 "L$LINENO: --a No Pass"
    vdo enableDeduplication -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --n No Pass"
    vdo enableDeduplication --verbose -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"
    vdo enableDeduplication -n my_vdo_volume -f /etc/vdoconf.yml
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    touch /var/log/vdo_enableDeduplication.log
    vdo enableDeduplication -n my_vdo_volume --logfile /var/log/vdo_enableDeduplication.log
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile No Pass"
    sudo rm /var/log/vdo_enableDeduplication.log

    vdo growLogical --help | grep "usage: vdo growLogical"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
    vdo growLogical -n my_vdo_volume --vdoLogicalSize 6278748K
    CHECK_RESULT $? 0 0 "L$LINENO: --n No Pass"
    vdo growLogical --verbose -n my_vdo_volume --vdoLogicalSize 6278752K
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"
    vdo growLogical -n my_vdo_volume -f /etc/vdoconf.yml --vdoLogicalSize 6278756K
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    touch /var/log/vdo_growLogical.log 
    vdo growLogical -n my_vdo_volume --logfile /var/log/vdo_growLogical.log --vdoLogicalSize 6278760K
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile No Pass"
    sudo rm /var/log/vdo_growLogical.log

    vdo growPhysical --help | grep "usage: vdo growPhysical"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
    # vdo growPhysical -n my_vdo_volume
    # vdo growPhysical --verbose -n my_vdo_volume
    # vdo growPhysical -n my_vdo_volume -f /etc/vdoconf.yml
    # touch /var/log/vdo_growPhysical.log
    # vdo growPhysical -n my_vdo_volume --logfile /var/log/vdo_growPhysical.log
    # sudo rm /var/log/vdo_growPhysical.log

    vdo list --help | grep "usage: vdo list"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
    vdo list -a
    CHECK_RESULT $? 0 0 "L$LINENO: --a No Pass"
    vdo list --verbose 
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"
    vdo list  -f /etc/vdoconf.yml
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    touch /var/log/vdo_list.log
    vdo list  --logfile /var/log/vdo_list.log
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile No Pass"
    sudo rm /var/log/vdo_list.log

    vdo printConfigFile --help | grep "usage: vdo printConfigFile"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
    vdo printConfigFile --verbose 
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"
    vdo printConfigFile  -f /etc/vdoconf.yml
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    touch /var/log/vdo_printConfigFile.log
    vdo printConfigFile  --logfile /var/log/vdo_printConfigFile.log
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile No Pass"
    sudo rm /var/log/vdo_printConfigFile.log

    vdo status --help | grep "usage: vdo status"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
    vdo status -a
    CHECK_RESULT $? 0 0 "L$LINENO: --a No Pass"
    vdo status -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --n No Pass"
    vdo status --verbose -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"
    vdo status -n my_vdo_volume -f /etc/vdoconf.yml
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    touch /var/log/vdo_status.log
    vdo status -n my_vdo_volume --logfile /var/log/vdo_status.log
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile No Pass"
    sudo rm /var/log/vdo_status.log


    ### oe_test_vdo_03 ###

    ### --help ###
    vdo modify --help | grep "usage: vdo modify"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"

    ### --a ###
    vdo modify -a --blockMapCacheSize 256M
    CHECK_RESULT $? 0 0 "L$LINENO: --a No Pass"

    ### --n ###
    vdo modify -n my_vdo_volume --blockMapCacheSize 256M
    CHECK_RESULT $? 0 0 "L$LINENO: --n No Pass"

    ### --f <file> ###
    vdo modify -n my_vdo_volume --blockMapCacheSize 256M -f /etc/vdoconf.yml
    CHECK_RESULT $? 0 0 "L$LINENO: --f <file> No Pass"

    ### --logfile <pathname> ###
    touch /var/log/vdo_modify.log 
    vdo modify -n my_vdo_volume --blockMapCacheSize 256M --logfile /var/log/vdo_modify.log
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile <pathname> No Pass"
    sudo rm /var/log/vdo_modify.log
    
    ### --verbose ###
    vdo modify --verbose -n my_vdo_volume --blockMapCacheSize 256M
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"
    LOG_INFO "End to run test."

    ### --blockMapCacheSize <megabytes> ###
    vdo modify -n my_vdo_volume --blockMapCacheSize 256M
    CHECK_RESULT $? 0 0 "L$LINENO: --blockMapCacheSize No Pass"
    
    ### --blockMapPeriod <period> ###
    vdo modify -n my_vdo_volume --blockMapPeriod 200
    CHECK_RESULT $? 0 0 "L$LINENO: --blockMapPeriod No Pass"

    ### --maxDiscardSize <megabytes> ###
    vdo modify -n my_vdo_volume --maxDiscardSize 8K
    CHECK_RESULT $? 0 0 "L$LINENO: --maxDiscardSize No Pass"

    ### --vdoAckThreads <threadCount> ###
    vdo modify -n my_vdo_volume --vdoAckThreads 2
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoAckThreads No Pass"

    ### --vdoBioRotationInterval <ioCount> ###
    vdo modify -n my_vdo_volume --vdoBioRotationInterval 128
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoBioRotationInterval No Pass"

    ### --vdoBioThreads <threadCount> ###
    vdo modify -n my_vdo_volume --vdoBioThreads 4
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoBioThreads No Pass"

    ### --vdoCpuThreads <threadCount> ###
    vdo modify -n my_vdo_volume --vdoCpuThreads 4
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoCpuThreads No Pass"

    ### --vdoHashZoneThreads <threadCount> ###
    vdo modify -n my_vdo_volume --vdoHashZoneThreads 2
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoHashZoneThreads No Pass"

    ### --vdoLogicalThreads <threadCount> ###
    vdo modify -n my_vdo_volume --vdoLogicalThreads 2
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoLogicalThreads No Pass"

    ### --vdoPhysicalThreads <threadCount> ###
    vdo modify -n my_vdo_volume --vdoPhysicalThreads 2
    CHECK_RESULT $? 0 0 "L$LINENO: --vdoPhysicalThreads No Pass"

    ### oe_test_vdo_04 ###
    vdo start --help | grep "usage: vdo start"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
    vdo start -a
    CHECK_RESULT $? 0 0 "L$LINENO: --a No Pass"
    # vdo start -n my_vdo_volume --forceRebuild
    vdo start -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --n No Pass"
    vdo start --verbose -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"
    vdo start -n my_vdo_volume -f /etc/vdoconf.yml
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    touch /var/log/vdo_start.log
    vdo start -n my_vdo_volume --logfile /var/log/vdo_start.log
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile No Pass"
    sudo rm /var/log/vdo_start.log


    vdo stop --help | grep "usage: vdo stop"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
    vdo stop -a
    CHECK_RESULT $? 0 0 "L$LINENO: --a No Pass"
    vdo stop -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --n No Pass"
    vdo stop --verbose -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"
    vdo stop -n my_vdo_volume -f /etc/vdoconf.yml
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    touch /var/log/vdo_stop.log
    vdo stop -n my_vdo_volume --logfile /var/log/vdo_stop.log
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile No Pass"
    sudo rm /var/log/vdo_stop.log


    vdo remove --help | grep "usage: vdo remove"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
    vdo remove -a
    CHECK_RESULT $? 0 0 "L$LINENO: --a No Pass"
    vdo create -n my_vdo_volume --device /dev/loop0
    CHECK_RESULT $? 0 0 "L$LINENO: --n No Pass"

    vdo remove -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --n No Pass"
    vdo create -n my_vdo_volume --device /dev/loop0

    vdo remove --verbose -n my_vdo_volume
    CHECK_RESULT $? 0 0 "L$LINENO: --verbose No Pass"
    vdo create -n my_vdo_volume --device /dev/loop0

    vdo remove -n my_vdo_volume -f /etc/vdoconf.yml
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    vdo create -n my_vdo_volume --device /dev/loop0
    
    touch /var/log/vdo_remove.log
    vdo remove -n my_vdo_volume --logfile /var/log/vdo_remove.log
    CHECK_RESULT $? 0 0 "L$LINENO: --logfile No Pass"
    sudo rm /var/log/vdo_remove.log
    vdo create -n my_vdo_volume --device /dev/loop0

    vdo remove -n my_vdo_volume --force
    CHECK_RESULT $? 0 0 "L$LINENO: --force No Pass"

    losetup -d /dev/loop0
    rm vdo_test_device -f

    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE "$@"

    LOG_INFO "End to restore the test environment."
}

main "$@"