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
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of nvml command
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "${OET_PATH}/testcases/cli-test/nvml/common/checkenv.sh"


checkversion4rpma(){
    NVML_VERSION=$(yum info nvml 2>/dev/null  | grep -E '^Version' | awk '{print $NF}' | head -1)
    # 1.13.0及以后的版本不再支持rpma 
    compareversions "$NVML_VERSION" "1.13.0"
    result=$?

    if [[ $result -eq 0 || $result -eq 1 ]]; then
        echo "Skip: ${NVML_VERSION}版本不支持rpma" >&2
        exit 255
    elif [[ $result -eq 3 ]]; then
        echo "错误: ${NVML_VERSION}无效的版本号格式" >&2
        exit 1
    fi
}


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! yum list nvml &>/dev/null; then
         echo "skip unsupported arm arch"
         exit 255
    fi
    DNF_INSTALL nvml
    cat >rpmemd.conf <<EOL
  log-file = /var/log/rpmemd.log
  poolset-dir = $HOME
  persist-apm = no
  persist-general = yes
  use-syslog = yes
  log-level = err
EOL
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    checkversion4rpma
    LOG_INFO "Start to run test."
    rpmemd -h 2>&1 | grep 'usage: rpmemd'
    CHECK_RESULT $? 0 0 "Check rpmemd -h failed"
    rpmemd --help 2>&1 | grep 'usage: rpmemd'
    CHECK_RESULT $? 0 0 "Check rpmemd --help failed"
    rpmemd -V 2>&1 | grep "$(rpm -q nvml --queryformat '%{version}\n')"
    CHECK_RESULT $? 0 0 "Check rpmemd -V failed"
    rpmemd --version 2>&1 | grep "$(rpm -q nvml --queryformat '%{version}\n')"
    CHECK_RESULT $? 0 0 "Check rpmemd --version failed"
    rpmemd -c rpmemd.conf &
    pgrep rpmemd
    CHECK_RESULT $? 0 0 "Check rpmemd -c failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf rpmemd.conf log.* blk.*
    pkill -f "rpmemd -c rpmemd.conf" || true
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
