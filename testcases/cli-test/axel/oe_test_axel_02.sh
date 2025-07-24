#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   yushi
#@Contact       :   yushi@huawei2.com
#@Date          :   2023-8-2
#@License       :   Mulan PSL v2
#@Desc          :   Axel tries to accelerate the download process by using multiple connections per file, and can also balance the load between different servers.
# Axel tries to be as light as possible, so it might be useful on byte-critical systems.
# Axel supports HTTP, HTTPS, FTP and FTPS protocols.
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! yum list axel; then
        echo "axel does not exist"
        exit 255
    else
        DNF_INSTALL axel
    fi
    lang_tmp=$LANG
    if locale -a | grep "^zh_CN.utf8$" >/dev/null 2>&1; then
        LANG=zh_CN.UTF-8
        export LANG
        LC_CTYPE=zh_CN.UTF-8
        export LC_CTYPE
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    axel https://dev.mysql.com/get/mysql80-community-release-fc38-2.noarch.rpm | grep '已下载'
    CHECK_RESULT $?
    axel -s 51200 https://dev.mysql.com/get/mysql80-community-release-fc38-2.noarch.rpm | grep '已下载'
    CHECK_RESULT $?
    axel -n 10 https://dev.mysql.com/get/mysql80-community-release-fc38-2.noarch.rpm | grep '已下载'
    CHECK_RESULT $?
    axel --max-redirect=3 https://dev.mysql.com/get/mysql80-community-release-fc38-2.noarch.rpm | grep '已下载'
    CHECK_RESULT $?
    axel -o mysql.rpm https://dev.mysql.com/get/mysql80-community-release-fc38-2.noarch.rpm | find . -name 'mysql.rpm'
    CHECK_RESULT $?
    axel -S https://dev.mysql.com/get/mysql80-community-release-fc38-2.noarch.rpm | grep '正在搜索'
    CHECK_RESULT $?
    axel -4 https://dev.mysql.com/get/mysql80-community-release-fc38-2.noarch.rpm | grep '已下载'
    CHECK_RESULT $?
    axel -6 https://dev.mysql.com/get/mysql80-community-release-fc38-2.noarch.rpm | grep '已下载'
    CHECK_RESULT $? 1
    axel -H openEuler https://dev.mysql.com/get/mysql80-community-release-fc38-2.noarch.rpm | grep '已下载'
    CHECK_RESULT $?
    axel -U openEuler https://dev.mysql.com/get/mysql80-community-release-fc38-2.noarch.rpm | grep '已下载'
    CHECK_RESULT $? 1
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    find . -name 'mysql*' -print0 | xargs -0 rm -rf
    export $LANG="$lang_tmp"
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
