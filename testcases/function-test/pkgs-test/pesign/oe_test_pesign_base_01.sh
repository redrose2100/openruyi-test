#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of pesign command
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "pesign unzip"
    mkdir pesigntest
    cd pesigntest || exit
    cp ../common/baidu.zip ./
    cp ../common/grubx64.efi ./
    unzip baidu.zip
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    pesign -? 2>&1 | grep "Usage: pesign"
    CHECK_RESULT $? 0 0 "Check pesign -?  failed"
    pesign --help 2>&1 | grep "Usage: pesign"
    CHECK_RESULT $? 0 0 "Check pesign --help  failed"
    pesign --usage 2>&1 | grep "Usage: pesign"
    CHECK_RESULT $? 0 0 "Check pesign --usage  failed"
    pesign -i grubx64.efi -o grubx64.efi.signed -c 'ALT Linux UEFI SB CA' -s -n ./baidu -t 'NSS Certificate DB' -a -v -p -P -N && test -f ./grubx64.efi.signed
    CHECK_RESULT $? 0 0 "Check pesign -i -o -c -s -n -t -a -v -p -P -N failed"
    rm -rf grubx64.efi.signed
    pesign --in=grubx64.efi --out=grubx64.efi.signed --certificate='ALT Linux UEFI SB CA' --sign --certdir=./baidu -t 'NSS Certificate DB' --nss-token='NSS Certificate DB' --ascii-armor --verbose --nopadding --nofork --nopadding && test -f ./grubx64.efi.signed
    CHECK_RESULT $? 0 0 "Check pesign --in --out --certificate --sign --certdir -t --nss-token --ascii-armor --verbose --nopadding --nofork --nopadding failed"
    pesign -i grubx64.efi -n ./baidu -h -d sha256 -V | grep "grubx64.efi"
    CHECK_RESULT $? 0 0 "Check pesign -h -d -V failed"
    pesign -i grubx64.efi -n ./baidu --hash --digest_type=sha256 --no-vendor-cert | grep "grubx64.efi"
    CHECK_RESULT $? 0 0 "Check pesign --hash --digest_type --no-vendor-cert failed"
    pesign -u 'ALT UEFI SB CA 2013' -r -i grubx64.efi.signed -o out && test -f ./out
    CHECK_RESULT $? 0 0 "Check pesign -u failed"
    pesign --signature-number='ALT UEFI SB CA 2013' --remove-signature -i grubx64.efi.signed -o out1 && test -f ./out1
    CHECK_RESULT $? 0 0 "Check pesign --signature-number failed"
    pesign -i grubx64.efi.signed -S | grep "certificate address"
    CHECK_RESULT $? 0 0 "Check pesign -i -S failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    cd ..
    rm -rf pesigntest
    pgrep -f grubx64.efi | xargs -r kill -9
    LOG_INFO "Finish restore the test environment."
}

main "$@"
