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

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL pesign
    mkdir pesigntest
    cd pesigntest
    cp ../common/baidu.zip ./
    cp ../common/grubx64.efi ./
    unzip baidu.zip
    pesign -i grubx64.efi -o grubx64.efi.signed -c 'ALT Linux UEFI SB CA' -s -n ./baidu -t 'NSS Certificate DB' -a -v -p -P -N
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    pesign -i grubx64.efi.signed --show-signature
    CHECK_RESULT $? 0 0 "Check pesign -i grubx64.efi.signed --show-signature failed"
    pesign -u 'ALT UEFI SB CA 2013' -r -i grubx64.efi.signed -o out && test -f ./out
    CHECK_RESULT $? 0 0 "Check pesign -r failed"
    pesign --signature-number='ALT UEFI SB CA 2013' --remove-signature -i grubx64.efi.signed -o out1 && test -f ./out1
    CHECK_RESULT $? 0 0 "Check pesign --remove-signature failed"
    pesign -i grubx64.efi.signed -n ./baidu -K out2 -c 'ALT Linux UEFI SB CA' && test -f ./out2
    CHECK_RESULT $? 0 0 "Check pesign -K failed"
    pesign -i grubx64.efi.signed -n ./baidu --export-pubkey=out3 -c 'ALT Linux UEFI SB CA' && test -f ./out3
    CHECK_RESULT $? 0 0 "Check pesign --export-pubkey failed"
    pesign -i grubx64.efi.signed -n ./baidu -C out4 -c 'ALT Linux UEFI SB CA' && test -f ./out4
    CHECK_RESULT $? 0 0 "Check pesign -C failed"
    pesign -i grubx64.efi.signed -n ./baidu --export-cert=out5 -c 'ALT Linux UEFI SB CA' && test -f ./out5
    CHECK_RESULT $? 0 0 "Check pesign --export-cert failed"
    pesign -i grubx64.efi -n ./baidu -D
    CHECK_RESULT $? 0 0 "Check pesign -D failed"
    pesign -i grubx64.efi -n ./baidu --daemonize
    CHECK_RESULT $? 0 0 "Check pesign --daemonize failed"
    pesign -i grubx64.efi.signed -n ./baidu -C out6 -f -c 'ALT Linux UEFI SB CA' && test -f ./out6
    CHECK_RESULT $? 0 0 "Check pesign -f failed"
    pesign -i grubx64.efi.signed -n ./baidu -C out7 --force -c 'ALT Linux UEFI SB CA' && test -f ./out7
    CHECK_RESULT $? 0 0 "Check pesign --force failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    ps -ef | grep grubx64.efi | grep -v grep | awk '{print $2}' | xargs kill -9
    cd ..
    rm -rf pesigntest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
