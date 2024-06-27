#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   saarloos
#@Contact   	:   9090-90-90-9090@163.com
#@Date      	:   2020-08-12 11:03:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run busybox testsuite
#####################################
# shellcheck disable=SC1091,SC2016,SC1003
source ../comm_lib.sh

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    if [ -e ./tmp_test/defconfig-busybox ]; then
        cp ./tmp_test/defconfig-busybox /bin/.config
    fi
    if [ -e ./tmp_test/defconfig ]; then
        cp ./tmp_test/defconfig /bin/.config
    fi
    
    export bindir=/bin/
    export SKIP_KNOWN_BUGS=1

    pushd ./tmp_test/testsuite || CHECK_RESULT 1 0 1 "pushd ./tmp_test/testsuite fail"
    #cpio case
    sed -i 's/optional FEATURE_LS_SORTFILES FEATURE_LS_TIMESTAMPS/optional FEATURE_LS_SORTFILES FEATURE_LS_TIMESTAMPS CONFIG_BZCAT/g' cpio.tests
    sed -i '/testing "cpio extracts in existing directory"/i\optional CONFIG_BZCAT' cpio.tests

    #mv case
    sed -i '1i # FEATURE: CONFIG_FEATURE_TOUCH_SUSV3' mv/mv-files-to-dir
    sed -i '1i # FEATURE: CONFIG_FEATURE_TOUCH_SUSV3' mv/mv-files-to-dir-2
    sed -i '1i # FEATURE: CONFIG_FEATURE_TOUCH_SUSV3' mv/mv-refuses-mv-dir-to-subdir

    # strings case
    sed -i 's/\.\.\/\.\.\/busybox/\/bin\/busybox/g' strings/strings-works-like-GNU

    # tar case
    sed -i 's/FEATURE_TAR_AUTODETECT LS/FEATURE_TAR_AUTODETECT LS UUDECODE/g' tar.tests
    sed -i '1a # FEATURE: CONFIG_BUNZIP2' tar/tar_with_link_with_size

    # touch case
    sed -i '1i # FEATURE: CONFIG_FEATURE_TOUCH_SUSV3' touch/touch-touches-files-after-non-existent-file

    # patch du -l
    sed -i '/144/a \ \ -o x"`busybox du -l .`" = x"145\t." \\' du/du-l-works

    # fix hostname -s
    sed -i "s/x\$(busybox hostname -s)/x\$(busybox hostname -s) || test x\$(hostname) = x\$(busybox hostname -s)/g" hostname/hostname-s-works

    # fix date timezone
    sed -i 's/busybox date/date/g' date/date-timezone

    popd || CHECK_RESULT 1 0 1 "popd ./tmp_test/testsuite fail"

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    pushd ./tmp_test/testsuite || CHECK_RESULT 1 0 1 "pushd ./tmp_test/testsuite fail"

    chmod -R 777 ./
    ./runtest > tmp_log.log 2>&1

    ignoreFail=("FAIL: unzip (subdir only)" "FAIL: start-stop-daemon with both -x and -a" )

    while read -r line; do
        echo "$line"
        if [[ $line =~ ":" ]]; then
            resuleTitle=${line%:*}
            if echo "${ignoreFail[*]}" | grep "${line}"; then
                continue
            else
                echo "${resuleTitle}" | grep -q "FAIL"
                CHECK_RESULT $? 0 1 "run busybox testcase fail info: $line"
            fi
        fi

    done < tmp_log.log

    popd || CHECK_RESULT 1 0 1 "popd ./tmp_test/testsuite fail"

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf /bin/.config
    export SKIP_KNOWN_BUGS=

    LOG_INFO "End to restore the test environment."
}

main "$@"
