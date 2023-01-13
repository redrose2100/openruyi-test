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
    pesigcheck -? 2>&1 | grep "Usage: pesigcheck"
    CHECK_RESULT $? 0 0 "Check pesigcheck -? failed"
    pesigcheck --help 2>&1 | grep "Usage: pesigcheck"
    CHECK_RESULT $? 0 0 "Check pesigcheck --help failed"
    pesigcheck --usage 2>&1 | grep "Usage: pesigcheck"
    CHECK_RESULT $? 0 0 "Check pesigcheck --usage failed"
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
