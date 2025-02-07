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
# shellcheck disable=SC2086,SC2010,SC1091

source "common/common_syscare.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    init_env
    download_and_compile_redis
    target='redis'
    patch_file='redis.patch'
    patch_name_0001='0001'
    #自定义变量
    long_patch_name=""
    for ((i = 1; i <= 400; i++)); do
        patch="patch_name_$i"
        long_patch_name="$long_patch_name$patch"
    done
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    # syscare build制作补丁-使用错误的参数
    cp common/redis.patch ./
    pushd ./ || exit
    cd /root || exit
    # 获取补丁制作必备包
    redis_src_name=$(ls -lt | grep -E "redis.*src.rpm" | head -n 1 | awk '{print $NF}')
    redis_debuginfo_name=$(ls | grep redis-debuginfo | awk '{print $NF}')

    # syscare build --patch-description 为空编译失败
    syscare build --patch-name patch_${target}_${patch_name_0001} --source "${redis_src_name}" --debuginfo "${redis_debuginfo_name}" --patch ${patch_file} --patch-description
    CHECK_RESULT $? 2 0 "syscare build fail"

    # syscare build --patch-requires 依赖为空编译失败
    syscare build --patch-name patch_${target}_${patch_name_0001} --source "${redis_src_name}" --debuginfo "${redis_debuginfo_name}" --patch ${patch_file} --patch-requires
    CHECK_RESULT $? 2 0 "syscare build fail"

    # syscare --jobs -1编译失败
    syscare build --patch-name patch_${target}_${patch_name_0001} --source "${redis_src_name}" --debuginfo "${redis_debuginfo_name}" --patch ${patch_file} --jobs -1
    CHECK_RESULT $? 2 0 "syscare build fail"

    # syscare build --patch-name为异常字符
    syscare build --patch-name "@^<>!$%^&*()+_=-" --source "${redis_src_name}" --debuginfo "${redis_debuginfo_name}" --patch ${patch_file}
    CHECK_RESULT $? 255 0 "syscare build fail"

    # syscare build -s/--source 源码包不存在 -d/--debuginfo 包不存在
    syscare build --patch-name patch_${target}_${patch_name_0001} --source --debuginfo "${redis_debuginfo_name}" --patch ${patch_file}
    CHECK_RESULT $? 2 0 "syscare build fail"
    syscare build --patch-name patch_${target}_${patch_name_0001} --source "${redis_src_name}"_1 --debuginfo "${redis_debuginfo_name}" --patch ${patch_file}
    CHECK_RESULT $? 255 0 "syscare build fail"
    syscare build --patch-name patch_${target}_${patch_name_0001} --source "${redis_src_name}" --debuginfo --patch ${patch_file}
    CHECK_RESULT $? 2 0 "syscare build fail"
    syscare build --patch-name patch_${target}_${patch_name_0001} --source "${redis_src_name}" --debuginfo "${redis_debuginfo_name}"_1 --patch ${patch_file}
    CHECK_RESULT $? 255 0 "syscare build fail"
    popd || exit
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd /root || exit
    rm -f syscare-build*
    cd - || exit
    restore_env
    LOG_INFO "End to restore the test environment."
}

main "$@"
