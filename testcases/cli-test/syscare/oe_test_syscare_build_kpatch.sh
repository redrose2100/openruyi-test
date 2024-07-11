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
#@Author        :   linmengmeng
#@Contact       :   linmengmeng@huawei.com
#@Date          :   2024-07-11
#@License       :   Mulan PSL v2
#@Desc          :   Pressure load : concurrent operations
#####################################
# shellcheck disable=SC1091

source "common/common_syscare.sh"

function pre_test() {
    init_env
    download_and_compile_redis
    target='redis'
    patch_file='redis.patch'
    patch_name_0001='0001'
}

function run_test() {
    # syscare build制作补丁
    pushd ./
    cd /root
    # 获取补丁制作必备包
    redis_src_name=$(ls -lt | grep -E "redis.*src.rpm" | head -n 1 | awk '{print $NF}')
    redis_debuginfo_name=$(ls | grep redis-debuginfo | awk '{print $NF}')

    syscare build --patch-name patch_${target}_${patch_name_0001} --source "${redis_src_name}" --debuginfo "${redis_debuginfo_name}" --patch ${patch_file}
    CHECK_RESULT $?
    patch_rpm=$(ls | grep ulp_${target}_patch_${target}_${patch_name_0001} | awk '{print $NF}')
    rpm -ivh "${patch_rpm}"
    sleep 1
    patch_name=$(syscare list | grep patch_${target}_"${patch_name_0001}" | grep redis-server | awk '{print $2}')
    popd
    # 检查热补丁基本操作正常
    syscare check "${patch_name}"
    CHECK_RESULT $?
    syscare apply "${patch_name}"
    CHECK_RESULT $?
    syscare deactive "${patch_name}"
    CHECK_RESULT $?
    syscare active "${patch_name}"
    CHECK_RESULT $?
    syscare remove "${patch_name}"
    CHECK_RESULT $?
    syscare info "${patch_name}"
    CHECK_RESULT $?
}

function post_test() {
    cd /root
    rm -f "${patch_rpm}"
    rm -f $(ls | grep ${patch_name_0001} | grep 'src.rpm')
    rpm -e $(echo "$patch_rpm" | sed 's/.rpm//')
    cd -
}

main "$@"