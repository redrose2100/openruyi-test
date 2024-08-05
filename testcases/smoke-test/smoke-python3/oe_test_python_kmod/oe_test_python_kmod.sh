#!/bin/bash
# Copyright (c), 2024-2024, Huawei Tech. Co., Ltd.
# Description: python-kmod 基础功能测试,模块查询、卸载、加载
# Author: xieshouhang <xieshouhang@huawei-partners.com>
# Create: 2020-12-08
# History:

source "${OET_PATH}"/libs/locallibs/common_lib.sh
set +e
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    yum -y install python3-kmod
    LOG_INFO "End to prepare the test environment."
}

function do_test() {
    LOG_INFO "Start testing..."
    python3 -c "import kmod;km=kmod.Kmod();print([(m.name, m.size) for m in km.loaded()])" > tmp_log
    grep "virtio_console" tmp_log
    CHECK_RESULT $? 0 0
    python3 -c "import kmod;km=kmod.Kmod();km.rmmod('virtio_console');print([(m.name, m.size) for m in km.loaded()])" > tmp_log1
    grep "virtio_console" tmp_log1
    CHECK_RESULT $? 1
    python3 -c "import kmod;km=kmod.Kmod();km.modprobe('virtio_console');print([(m.name, m.size) for m in km.loaded()])" > tmp_log2
    # 模块插拔后查询到的顺序可能会发生变更,diff会有差异,使用grep查找指定模块
    grep "virtio_console" tmp_log2
    CHECK_RESULT $? 0 0
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    rm -fr tmp_log*
    id=$(yum history | grep "-y install python3-kmod" | head -n1 | awk '{print $1}')
    [ -z "${id}" ] || yum history undo -y "$id"
    LOG_INFO "End to clean the test environment."
}

main "$@"
