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

_MTX_COMMON_RPMBUILD_BAKUP_DIR="${HOME}/.rpmbuild.$(date +'%s')"

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
    test -d "${HOME}/rpmbuild" \
        && mv -f "${HOME}/rpmbuild" "$_MTX_COMMON_RPMBUILD_BAKUP_DIR" \
        && LOG_INFO "Successfully move ${HOME}/rpmbuild to ${_MTX_COMMON_RPMBUILD_BAKUP_DIR}."
    rpmdev-setuptree
    git clone https://gitee.com/src-openeuler/mhvtl.git ./tmp/mhvtl
    cp ./tmp/mhvtl/1.7-0_release.tar.gz ./tmp/mhvtl/build-kernel-module.patch ./tmp/mhvtl/build-mhvtl-module.patch "${HOME}/rpmbuild/SOURCES"
    rpmbuild -bb ./tmp/mhvtl/*.spec
    dnf install "${HOME}/rpmbuild/RPMS/$(arch)"/*.rpm -y
    systemctl start mhvtl.target
    # waite ....
    SLEEP_WAIT 5s
    # Looking for manipulator equipment
    PATH_MEDIUMX=$(lsscsi -g | grep "${DRIVER_MEDIUMX}" | grep -oE "/dev/sg.*")
    # Looking for drive devices
    PATH_TAPE=$(lsscsi -g | grep -m 1 "${DRIVER_TAPE}" | grep -oE "/dev/st[0-9]*")
    if [ -z "$PATH_MEDIUMX" ] || [ -z "$PATH_TAPE" ]; then
        LOG_ERROR "Failed to find mediumx device (model: ${DRIVER_MEDIUMX}) or tape device (model: ${DRIVER_TAPE})."
        exit 255
    fi
}

# Test common functions
function common_test() {
    # View mhvtl status
    systemctl status mhvtl.target | grep "mhvtl service allowing to start/stop"
    CHECK_RESULT $? 0 0 "mhvtl service WRONG"
}

# Environmental recovery
function common_post() {
    rm -rf ./tmp "${HOME}/rpmbuild"
    test -d "$_MTX_COMMON_RPMBUILD_BAKUP_DIR" \
        && mv -f "$_MTX_COMMON_RPMBUILD_BAKUP_DIR" "${HOME}/rpmbuild" \
        && LOG_INFO "Successfully move ${_MTX_COMMON_RPMBUILD_BAKUP_DIR} to ${HOME}/rpmbuild."
    systemctl stop mhvtl.target
    DNF_REMOVE "$@"
}

# Drill down to find tape devices
function common_load() {
    mtx -f "${PATH_MEDIUMX}" next >/dev/null
}
