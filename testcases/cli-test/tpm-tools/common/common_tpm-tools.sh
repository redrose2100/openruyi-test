#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ############################################
# @Author    :   liujuan
# @Contact   :   lchutian@163.com
# @Date      :   2020/12/21
# @License   :   Mulan PSL v2
# @Desc      :   public class integration
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function deploy_env() {
    DNF_INSTALL "tpm-tools trousers cmake make gcc-c++ gmp-devel wget unzip kernel-devel-$(uname -r) patch"
    wget https://github.com/PeterHuewe/tpm-emulator/archive/v0.7.5.zip
    unzip v0.7.5.zip
    wget https://github.com/PeterHuewe/tpm-emulator/archive/v0.7.4.zip
    unzip v0.7.4.zip
    test -d tpm-emulator-0.7.4 && cd tpm-emulator-0.7.4 || exit
    patch -p1 < "$OET_PATH"/testcases/cli-test/tpm-tools/common/0001-Fix-compilation-under-3.19-kernels-till-now.patch
    test -d ../tpm-emulator-0.7.5 && cp ../tpm-emulator-0.7.5/tpmd/unix/tpmd.c tpmd/unix/tpmd.c || exit
    patch -p1 < "$OET_PATH"/testcases/cli-test/tpm-tools/common/0002-Use-stable-kernel-api-for-userspace-socket-communica.patch
    sed -i "s/-Wall -Werror/-Wall -Wno-error/g" tpmd_dev/linux/Makefile
    sed -i '/MODULE_SUPPORTED_DEVICE/d' tpmd_dev/linux/tpmd_dev.c
    sed -i 's|-Wall -Werror|-Wall -Wno-error -fcommon|' CMakeLists.txt
    mkdir build && cd build || exit
    cmake .. && make && make install
    tpmd deactivated
    tpmd clear
    modprobe tpmd_dev
    nohup tpmd -d -f clear >/dev/null 2>&1 &
    SLEEP_WAIT 10
    if [ -z "$(pgrep -f 'tpmd -d')" ]; then
        rm -rf /var/run/tpm/tpmd_socket:0
        nohup tpmd -d -f clear >/dev/null 2>&1 &
        SLEEP_WAIT 10
        pgrep -f 'tpmd -d'
    fi
    if [ -n "$(pgrep -f 'tcsd -e')" ]; then
        kill -9 "$(pgrep -f 'tcsd -e')"
    else
        nohup tcsd -e -f >/dev/null 2>&1 &
        SLEEP_WAIT 10
        pgrep -f 'tcsd -e'
    fi
    tpm_version | grep -i "[0-9a-z]"
    tpm_getpubek | grep -i "[0-9a-z\!():,_]"
}

function clear_env() {
    kill -9 "$(pgrep -f 'tpmd -d')"
    kill -9 "$(pgrep -f 'tcsd -e')"
    currentDir=$(
        cd "$(dirname "$0")" || exit 1
        pwd
    )
    currentName=$(echo "$currentDir" | awk -F '/' '{print $NF}')
    test "$currentName"x = "build"x && cd ../../ && {
        find . -mindepth 1 -maxdepth 1 ! -name "*.sh" -exec rm -rf "{}" +
    }
    DNF_REMOVE "$@"
}
