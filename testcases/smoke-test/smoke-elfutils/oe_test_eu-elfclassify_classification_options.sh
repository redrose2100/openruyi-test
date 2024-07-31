#!/usr/bin/bash
# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liangdong
# @Contact   :   liangdong47@h-partners.com
# @Date      :   2024/06/06
# @License   :   Mulan PSL v2
# @Desc      :   eu-elfclassify 分类选项
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh &> /dev/null
source ./package_lib.sh
set +e
test_log=tmp_test.log
bin_dir=./usr

function pre_test() {
    yum -y install elfutils eu-elfclassify
}

function run_test() {
    LOG_INFO "Start to run test."
    eu-elfclassify --core $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 1 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    ulimit_core_bak="$(ulimit -c)"
    core_pattern_bak="$(cat /proc/sys/kernel/core_pattern)"
    selinux_bak="$(getenforce)"
    mkdir tmp_core
    ulimit -c unlimited
    setenforce 0
    echo "$(pwd)/tmp_core/core-%e-%p-%t" > /proc/sys/kernel/core_pattern
    # shellcheck disable=SC2046
    kill -6 $(pidof rsyslogd)
    # shellcheck disable=SC2046
    ls -l $(pwd)/tmp_core/core-*
    CHECK_RESULT $? 0 0
    ulimit -c "$ulimit_core_bak"
    echo "$core_pattern_bak" > /proc/sys/kernel/core_pattern
    setenforce "$selinux_bak"
    eu-elfclassify --core tmp_core/core-* &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1

    eu-elfclassify --debug-only $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 1 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    yum install -y binutils
    objcopy --only-keep-debug $bin_dir/test_main tmp_test_main.debug
    eu-elfclassify --debug-only tmp_test_main.debug &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1

    eu-elfclassify --elf $bin_dir/test.h &> $test_log
    CHECK_RESULT $? 1 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    eu-elfclassify --elf $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1

    eu-elfclassify --elf-archive $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 1 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    eu-ar -r libtest.a $bin_dir/main.o
    CHECK_RESULT $? 0 0
    eu-elfclassify --elf-archive libtest.a &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1

    eu-elfclassify --executable $bin_dir/test.h &> $test_log
    CHECK_RESULT $? 1 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    eu-elfclassify --executable $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    
     eu-elfclassify --library $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 1 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    eu-elfclassify --library "$(rpm -ql elfutils | grep 'libelf-')" &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1

    eu-elfclassify --linux-kernel-module $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 1 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    eu-elfclassify --linux-kernel-module "$(find /lib/modules -name '*.ko' | head -1)" &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1

    eu-elfclassify --loadable $bin_dir/test.h &> $test_log
    CHECK_RESULT $? 1 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    eu-elfclassify --loadable $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1

    eu-elfclassify --program $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    eu-elfclassify --program "$(rpm -ql elfutils | grep 'libelf-')" &> $test_log
    CHECK_RESULT $? 1 0
    test -s $test_log
    CHECK_RESULT $? 0 1

    eu-elfclassify --shared "$(rpm -ql elfutils | grep 'libelf-')" &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    eu-elfclassify --shared $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 1 0
    test -s $test_log
    CHECK_RESULT $? 0 1

    eu-elfclassify --unstripped $bin_dir/test_main &> $test_log
    CHECK_RESULT $? 0 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    cp $bin_dir/test_main tmp_test_main_strip
    strip tmp_test_main_strip
    CHECK_RESULT $? 0 0
    eu-elfclassify --unstripped tmp_test_main_strip &> $test_log
    CHECK_RESULT $? 1 0
    test -s $test_log
    CHECK_RESULT $? 0 1
    LOG_INFO "End to run test."
}

function post_test() {
    rm -rf $test_log libtest.a
    yum -y remove elfutils eu-elfclassify
}

main "$@"

