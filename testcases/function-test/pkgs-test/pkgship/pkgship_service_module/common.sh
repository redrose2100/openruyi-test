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
#@Author    	:   Li, Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2024-01-04
#@License   	:   Mulan PSL v2
#@Desc      	:   Define testing methods for pkgship
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function exec_init() {
    pkgship init -filepath ../common_lib/openEuler.yaml
}

function exec_query_bedepend() {
    pkgship bedepend openeuler-lts glibc >/dev/null
}

function exec_query_builddep() {
    pkgship builddep glibc >/dev/null
}

function exec_query_installdep() {
    pkgship installdep glibc >/dev/null
}

function exec_query_list() {
    pkgship list openeuler-lts -s >/dev/null
}

function exec_query() {
    pkgship list openeuler-lts >/dev/null
}

function exec_query_pkginfo() {
    pkgship pkginfo coreutils openeuler-lts >/dev/null
}

function exec_query_pkg1() {
    pkgship pkginfo git-daemon openeuler-lts >/dev/null
}

function exec_query_selfdepend() {
    pkgship selfdepend glibc >/dev/null
}
