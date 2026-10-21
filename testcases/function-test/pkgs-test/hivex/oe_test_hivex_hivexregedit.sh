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
# @Author    :   hantingxiang
# @Contact   :   hantingxiang@gmail.com
# @Date      :   2022/07/26
# @License   :   Mulan PSL v2
# @Desc      :   Test hivexregedit
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "hivex perl-hivex"
    cp ./common/minimal ./common/minimal_test
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    hivexregedit --help | grep "Usage:"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --help"
    hivexregedit --export ./common/hivefile test > regfile_test && cat regfile_test | grep "Windows Registry Editor"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --export"
    hivexregedit --export --prefix prefix ./common/hivefile test > regfile_test && cat regfile_test | grep "prefix\\\test"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --prefix"
    hivexregedit --export --unsafe-printable-strings ./common/hivefile test > regfile_test  && cat regfile_test | grep "str(1)"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --unsafe-printable-strings"
    hivexregedit --export --debug ./common/hivefile test > regfile_test 2>&1 && cat regfile_test | grep "hivex: hivex_open"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --debug"
    hivexregedit --export --unsafe ./common/hivefile test > regfile_test && cat regfile_test | grep "@=hex(1)"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --unsafe"
    hivexregedit --export --max-depth 1 ./common/minimal root > regfile_test && cat regfile_test | grep "\\[\\\root\\]"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --max-depth"
    hivexregedit --merge ./common/minimal_test ./common/regfile && echo "ls" | hivexsh ./common/minimal_test | grep "test"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --merge"
    echo -e "Windows Registry Editor Version 5.00\n\n[\\\test2]\n@=hex(1):54,00,65,00,73,00,74,00,00,00" | hivexregedit --merge ./common/minimal_test \
    && echo "ls" | hivexsh ./common/minimal_test | grep "test2"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test --merge without regfile"
    hivexregedit --merge --encoding UTF-16LE ./common/minimal_test ./common/regfile
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --encoding"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf ./common/minimal_test ./common/regfile_test regfile_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
