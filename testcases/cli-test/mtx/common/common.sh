#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   DingYaoyao
# @Contact   :   d1005562341@126.com
# @Date      :   2022/09/30
# @License   :   Mulan PSL v2
# @Desc      :   mtx common prepare
# #############################################
# shellcheck disable=SC1091
source "${OET_PATH}"/libs/locallibs/common_lib.sh

# Define configuration information
function common_config_params() {
    # Mechanical arm of mhvtl
    DRIVER_MEDIUMX="L80"
    # Drive equipment type
    DRIVER_TAPE="T10000B"
}

# Test environment preparation
function common_pre() {
    DNF_INSTALL "mtx rpm-build rpmdevtools git zlib-devel gcc kernel-devel"
    rpmdev-setuptree
    git clone https://gitee.com/src-openeuler/mhvtl.git ./tmp/mhvtl
    cp ./tmp/mhvtl/1.7-0_release.tar.gz ./tmp/mhvtl/build-kernel-module.patch ./tmp/mhvtl/build-mhvtl-module.patch ~/rpmbuild/SOURCES
    rpmbuild -bb ./tmp/mhvtl/*.spec
    dnf install ~/rpmbuild/RPMS/"$(arch)"/*.rpm -y
    systemctl start mhvtl.target
    # waite ....
    SLEEP_WAIT 5s
    # Looking for manipulator equipment
    PATH_MEDIUMX=$(lsscsi -g | grep "${DRIVER_MEDIUMX}" | grep -oE "/dev/sg.*" || exit 1)
    # Looking for drive devices
    PATH_TAPE=$(lsscsi -g | grep -m 1 "${DRIVER_TAPE}" | grep -oE "/dev/st[0-9]*" || exit 1)
    echo "$PATH_TAPE"
}

# Test common functions
function common_test() {
    # View mhvtl status
    systemctl status mhvtl.target | grep "mhvtl service allowing to start/stop"
    CHECK_RESULT $? 0 0 "mhvtl service WRONG"
}

# Environmental recovery
function common_post() {
    rm -rf ./tmp ~/rpmbuild
    systemctl stop mhvtl.target
    DNF_REMOVE "$@"
}

# Drill down to find tape devices
function common_load() {
    mtx -f "${PATH_MEDIUMX}" next >/dev/null
}
