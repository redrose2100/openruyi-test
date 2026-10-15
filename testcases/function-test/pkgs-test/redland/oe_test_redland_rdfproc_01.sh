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
# @Desc      :   verify the uasge of redland command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL redland
    mkdir redland
    cd redland
    cp ../common/rss.rdf ./
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    rdfproc -h 2>&1 | fgrep "Usage: rdfproc [options]"
    CHECK_RESULT $? 0 0 "Check rdfproc -h failed"

    rdfproc --help 2>&1 | fgrep "Usage: rdfproc [options]"
    CHECK_RESULT $? 0 0 "Check rdfproc --help failed"

    rdfproc -c test serialize ntriples && test -f test-contexts.db
    CHECK_RESULT $? 0 0 "Check rdfproc -c test serialize ntriples failed"

    rdfproc --contexts test1 serialize ntriples && test -f test1-contexts.db
    CHECK_RESULT $? 0 0 "Check rdfproc --contexts test1 serialize ntriples failed"

    rdfproc -n test2 add SUBJECT PREDICATE OBJECT && test -f test2-so2p.db
    CHECK_RESULT $? 0 0 "Check rdfproc -n test2 add SUBJECT PREDICATE OBJECT failed"

    rdfproc --new test3 add SUBJECT PREDICATE OBJECT && test -f test3-so2p.db
    CHECK_RESULT $? 0 0 "Check rdfproc --new test3 add SUBJECT PREDICATE OBJECT failed"

    rdfproc -o rdfxml test4 print && test -f test4-so2p.db
    CHECK_RESULT $? 0 0 "Check rdfproc -o rdfxml test4 print failed"

    rdfproc --output ntriples test5 print && test -f test5-so2p.db
    CHECK_RESULT $? 0 0 "Check rdfproc --output ntriples test5 print failed"

    echo test123 | rdfproc -p test6 add SUBJECT PREDICATE OBJECT && test -f test6-so2p.db
    CHECK_RESULT $? 0 0 "Check echo Huawei@123 | rdfproc -p test6 add SUBJECT PREDICATE OBJECT failed"

    echo test123 | rdfproc --password test7 add SUBJECT PREDICATE OBJECT && test -f test7-so2p.db
    CHECK_RESULT $? 0 0 "Check echo Huawei@123 | rdfproc --password test7 add SUBJECT PREDICATE OBJECT failed"

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    cd ..
    rm -rf redland
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
