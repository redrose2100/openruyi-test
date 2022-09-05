#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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

    cp ./common/minimal ./
    cp ./common/hivefile ./
    cp ./common/regfile ./
    cp ./common/minimal ./minimal_test

    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."

    # test command: hivexregedit

    # test option: --help
    hivexregedit --help | grep "Usage:"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --help"

    # SYNOPSIS: hivexregedit --export [--prefix prefix] [--unsafe-printable-strings] [--unsafe] [--debug] hivefile key > regfile
    hivexregedit --export hivefile test > regfile_test  && cat regfile_test | grep "Windows Registry Editor"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --export"

    hivexregedit --export --prefix prefix hivefile test > regfile_test && cat regfile_test | grep "prefix\\\test"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --prefix"

    hivexregedit --export --unsafe-printable-strings hivefile test > regfile_test  && cat regfile_test | grep "str(1)"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --unsafe-printable-strings"

    hivexregedit --export --debug hivefile test > regfile_test 2>&1 && cat regfile_test | grep "hivex: hivex_open"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --debug"

    hivexregedit --export --unsafe hivefile test > regfile_test
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --unsafe"

    hivexregedit --export --max-depth 1 minimal_test root > regfile_test && cat regfile_test | grep "\\[\\\root\\]"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --max-depth"

    # SYNOPSIS: hivexregedit --merge [--prefix prefix] [--encoding enc] [--max-depth depth] [--unsafe] [--debug] hivefile [regfile]
    hivexregedit --merge minimal_test regfile && echo "ls" | hivexsh minimal_test | grep "test"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --merge"

    # without regfile
    echo -e "Windows Registry Editor Version 5.00\n\n[\\\test2]\n@=hex(1):54,00,65,00,73,00,74,00,00,00" | hivexregedit --merge minimal_test \
    && echo "ls" | hivexsh minimal_test | grep "test2"
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test --merge without regfile"

    hivexregedit --merge --encoding UTF-16LE minimal_test regfile
    CHECK_RESULT $? 0 0 "hivexregedit: failed to test option --encoding"

    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    rm -rf minimal hivefile regfile minimal_test regfile_test
    
    DNF_REMOVE 1 "hivex perl-hivex"

    LOG_INFO "End to restore the test environment."
}

main "$@"