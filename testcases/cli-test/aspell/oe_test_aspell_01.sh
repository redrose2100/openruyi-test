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
# @Desc      :   verify the uasge of aspell command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL aspell
    unzip common/aspell6-en-2020.12.07-0.zip
    cp -R ./aspell6-en-2020.12.07-0/* /usr/lib64/aspell-0.60
    export LANG=en_US
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    aspell -? 2>&1 | fgrep "Usage: aspell [options]"
    CHECK_RESULT $? 0 0 "Check aspell -? failed"

    aspell usage 2>&1 | fgrep "Usage: aspell [options]"
    CHECK_RESULT $? 0 0 "Check aspell usage failed"

    aspell help 2>&1 | fgrep "Usage: aspell [options]"
    CHECK_RESULT $? 0 0 "Check aspell help failed"

    aspell -v | grep "International Ispell Version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check aspell -v failed"

    aspell version | grep "International Ispell Version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check aspell version failed"

    echo "aaa name" | aspell list -d en_US | grep "aaa"
    CHECK_RESULT $? 0 0 "Check aspell list failed"

    aspell config | grep "HTML tags to always skip the"
    CHECK_RESULT $? 0 0 "Check aspell config failed"

    aspell config f-html-skip | grep "style"
    CHECK_RESULT $? 0 0 "Check aspell config f-html-skip failed"

    echo aaa | aspell -a | grep "& aaa 15 0:"
    CHECK_RESULT $? 0 0 "Check aspell -a failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf aspell6-en-2020.12.07-0
    LOG_INFO "End to restore the test environment."
}

main "$@"
