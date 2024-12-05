#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhangjujie
# @Contact   :   zhangjujie43@gmail.com
# @Date      :   2022/08/04
# @License   :   Mulan PSL v2
# @Desc      :   Take the test for nmon
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

_NMON_COMMON_RPMBUILD_BAKUP_DIR="${HOME}/.rpmbuild.$(date +'%s')"

function env_pre() {
    test -d "${HOME}/rpmbuild" \
        && mv -f "${HOME}/rpmbuild" "$_NMON_COMMON_RPMBUILD_BAKUP_DIR" \
        && LOG_INFO "Successfully move ${HOME}/rpmbuild to ${_NMON_COMMON_RPMBUILD_BAKUP_DIR}."
    systemctl start nfs-server
    rpmdev-setuptree
    cp ./common/libnvidia-ml.spec "${HOME}/rpmbuild/SPECS/"
    if [[ "$NODE1_FRAME" == "x86_64" ]]; then
        export ARCH=X86
        wget -P "${HOME}/rpmbuild/SOURCES/" https://cn.download.nvidia.com/XFree86/Linux-x86_64/470.74/NVIDIA-Linux-x86_64-470.74.run
    elif [[ "$NODE1_FRAME" == "aarch64" ]]; then
        export ARCH=ARM
        wget -P "${HOME}/rpmbuild/SOURCES/" https://cn.download.nvidia.com/XFree86/aarch64/470.74/NVIDIA-Linux-aarch64-470.74.run
    else 
        cp /usr/bin/nmon ./nmon_openEuler
        mkdir template
        return
    fi
    touch "${HOME}/rpmbuild/SOURCES/null"
    rpmbuild -ba --nodebuginfo "${HOME}/rpmbuild/SPECS/libnvidia-ml.spec"
    rpm -i "${HOME}/rpmbuild/RPMS/${NODE1_FRAME}/libnvidia-ml-470.74-openEuler.${NODE1_FRAME}.rpm"
    CHECK_RESULT $? 0 0 "Failed to install libnvidia-ml"
    mv /lib64/libnvidia-ml.so.470.74 /lib64/libnvidia-ml.so
    ldconfig
    yumdownloader --source --destdir=./template/ nmon
    rpm -i ./template/nmon*.src.rpm
    gcc -o nmon_openEuler "${HOME}/rpmbuild/SOURCES"/lmon*.c -g -Wall -D JFS -D GETUSER -D LARGEMEM -lncurses -lm -g -D "${ARCH}" -lnvidia-ml -D NVIDIA_GPU
    [ -f ./nmon_openEuler ]
    CHECK_RESULT $? 0 0 "Failed to build nmon_openEuler"

}

function env_post() {
    systemctl stop nfs-server
    unset ARCH
    rm -rf ./template "${HOME}/rpmbuild" nmon_openEuler auto /lib64/libnvidia-ml*
    test -d "$_NMON_COMMON_RPMBUILD_BAKUP_DIR" \
        && mv -f "$_NMON_COMMON_RPMBUILD_BAKUP_DIR" "${HOME}/rpmbuild" \
        && LOG_INFO "Successfully move ${_NMON_COMMON_RPMBUILD_BAKUP_DIR} to ${HOME}/rpmbuild."
    mv /lib64/libnvidia-ml.so /lib64/libnvidia-ml.so.470.74
    rpm -e --nodeps libnvidia-ml
}

