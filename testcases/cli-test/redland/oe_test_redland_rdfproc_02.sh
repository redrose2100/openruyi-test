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
    cp ../common/*.rdf ./
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    rdfproc -q test add SUBJECT PREDICATE OBJECT && test -f test-po2s.db
    CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"

    rdfproc --quiet test1 add SUBJECT PREDICATE OBJECT && test -f test1-po2s.db
    CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"

    rdfproc -r json test2 find SUBJECT PREDICATE OBJECT && test -f test2-po2s.db
    CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"

    rdfproc --results json test3 find SUBJECT PREDICATE OBJECT && test -f test3-po2s.db
    CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"

    rdfproc -s hashes testDbd parse test.rdf && test -f testDbd-po2s.db
    CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"

    rdfproc --storage hashes testDbd1 parse test.rdf && test -f testDbd1-po2s.db
    CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"

    rdfproc -t "hash-type='bdb',dir='.'" testDbd2 print -V && test -f testDbd2-po2s.db
    CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"

    rdfproc --storage-options "hash-type='bdb',dir='.'" testDbd3 print --verbose && test -f testDbd3-po2s.db
    CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"

    rdfproc -v | grep "[[:digit:]]"
    CHECK_RESULT $? 0 0 "Check rdfproc -v failed"

    rdfproc --version | grep "[[:digit:]]"
    CHECK_RESULT $? 0 0 "Check rdfproc --version failed"

    redland-db-upgrade test newtest && test -f newtest-po2s.db
    CHECK_RESULT $? 0 0 "Check redland-db-upgrade test newtest failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    cd ..
    rm -rf redland
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
