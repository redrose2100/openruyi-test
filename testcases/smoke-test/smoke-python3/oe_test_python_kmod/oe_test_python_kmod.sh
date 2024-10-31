#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   xieshouhang 
# @Contact   :   1069178568@qq.com
# @Date      :   2024/08/05
# @Desc      :   user identity authentication sm test
# ##################################
# shellcheck disable=SC2002,SC2119

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
