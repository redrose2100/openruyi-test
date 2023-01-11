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
# @Desc      :   verify the uasge of docbook-utils command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL docbook-utils
    cp -r ./common doc
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    jw -w list | grep "xml"
    CHECK_RESULT $? 0 0 "Check jw -w failed"

    jw --warning list | grep "xml"
    CHECK_RESULT $? 0 0 "Check jw --warning failed"

    jw -e list | grep "no-idref"
    CHECK_RESULT $? 0 0 "Check jw -e failed"

    jw --error list | grep "no-idref"
    CHECK_RESULT $? 0 0 "Check jw --error failed"

    jw -h | fgrep "Usage: jw [<options>] <sgml_file>"
    CHECK_RESULT $? 0 0 "Check jw -h failed"

    jw --help | fgrep "Usage: jw [<options>] <sgml_file>"
    CHECK_RESULT $? 0 0 "Check jw --help failed"

    jw -V name=1 doc/helloworld.sgml && test -f ./t1.html
    CHECK_RESULT $? 0 0 "Check jw -V name failed"

    jw --version | grep "jw version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check jw --version failed"

    jw -v | grep "jw version [[:digit:]]"
    CHECK_RESULT $? 0 0 "Check jw -v failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf doc t1.html
    LOG_INFO "Finish restore the test environment."
}

main "$@"
