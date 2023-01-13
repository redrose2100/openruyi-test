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
    pesign -i grubx64.efi -n ./baidu -D
    pesign -i grubx64.efi -o grubx64.efi.signed -c 'ALT Linux UEFI SB CA' -s -n ./baidu -t 'NSS Certificate DB' -a -v -p -P -N
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    pesign-client -i grubx64.efi.signed -o out -c 'ALT Linux UEFI SB CA' -s && test -f ./out
    CHECK_RESULT $? 0 0 "Check pesign-client -i -o -c -s failed."
    pesign-client --infile=grubx64.efi.signed --outfile=out1 -c 'ALT Linux UEFI SB CA' --sign && test -f ./out1
    CHECK_RESULT $? 0 0 "Check pesign-client --infile --outfile -c --sign failed."
    pesign-client -i grubx64.efi.signed -c 'ALT Linux UEFI SB CA' -F out -s -e out2 && test -f ./out2
    CHECK_RESULT $? 0 0 "Check pesign-client -i -c -F -s -e failed."
    pesign-client -i grubx64.efi.signed -c 'ALT Linux UEFI SB CA' --pinfile=out -s -e out3 && test -f ./out3
    CHECK_RESULT $? 0 0 "Check pesign-client -i -c --pinfile -s -e failed."
    pesign-client -i grubx64.efi.signed -o out4 -c 'ALT Linux UEFI SB CA' -s -f 1 && test -f ./out4
    CHECK_RESULT $? 0 0 "Check pesign-client -i -o -c -s -f failed."
    pesign-client -i grubx64.efi.signed -o out5 -c 'ALT Linux UEFI SB CA' -s --pinfd=1 && test -f ./out5
    CHECK_RESULT $? 0 0 "Check pesign-client -i -o -c -s --pinfd failed."
    pesign-client -kill
    CHECK_RESULT $? 0 0 "Check pesign-client -kill failed"
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
