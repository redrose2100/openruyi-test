#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wenjun
#@Contact       :   1009065695@qq.com
#@Date          :   2021-09-17
#@License       :   Mulan PSL v2
#@Desc          :   command test-pycodestyle
#####################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-pycodestyle"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # prepare ${OET_PATH}/test.py
    cat >${OET_PATH}/test.py << EOF
a='123'
b='acc'
abcdddasffsffsffffffaaaaaavvcfddddddddddddddddddddddsdwefdfdgfgfgfgfgfdgfabcdddasffsffsffffffaaaaaavvcfddddddddddddddddddddddsdwefdfdgfgfgfgfgfdgfabcdddasffsffsffffffaaaaaavvcfddddddddddddddddddddddsdwefdfdgfgfgfgfgfdgf='456'
print('123')
EOF

    # prepare ${OET_PATH}/pycodestyle.config
    cat >${OET_PATH}/pycodestyle.config << EOF
[pycodestyle]
count = True
max-line-length = 160
statistics = True
EOF

    pycodestyle -h | grep Usage
    CHECK_RESULT $?
    pycodestyle --help | grep Usage
    CHECK_RESULT $?
    test -n `pycodestyle --version`
    CHECK_RESULT $?
    pycodestyle -v ${OET_PATH}/test.py | grep "checking ${OET_PATH}/test.py"
    CHECK_RESULT $?
    pycodestyle --verbose ${OET_PATH}/test.py | grep "checking ${OET_PATH}/test.py"
    CHECK_RESULT $?
    CHECK_RESULT $(pycodestyle -v ${OET_PATH}/test.py | grep -c "E225 missing whitespace around operator") 3
    CHECK_RESULT $(pycodestyle --verbose ${OET_PATH}/test.py | grep -c "E225 missing whitespace around operator") 3
    CHECK_RESULT $(pycodestyle -v ${OET_PATH}/test.py | grep -c "E501 line too long") 1
    CHECK_RESULT $(pycodestyle --verbose ${OET_PATH}/test.py | grep -c "E501 line too long") 1
    pycodestyle -q ${OET_PATH}/test.py | grep ${OET_PATH}/test.py
    CHECK_RESULT $?
    pycodestyle --quiet ${OET_PATH}/test.py | grep ${OET_PATH}/test.py
    CHECK_RESULT $?
    CHECK_RESULT $(pycodestyle -r ${OET_PATH}/test.py | grep -c "E225 missing whitespace around operator") 3
    CHECK_RESULT $(pycodestyle --repeat ${OET_PATH}/test.py | grep -c "E225 missing whitespace around operator") 3
    CHECK_RESULT $(pycodestyle -r ${OET_PATH}/test.py | grep -c "E501 line too long") 1
    CHECK_RESULT $(pycodestyle --repeat ${OET_PATH}/test.py | grep -c "E501 line too long") 1
    CHECK_RESULT $(pycodestyle --first ${OET_PATH}/test.py | grep -c "E225 missing whitespace around operator") 1
    CHECK_RESULT $(pycodestyle --first ${OET_PATH}/test.py | grep -c "E501 line too long") 1

    CHECK_RESULT $(pycodestyle --select=E501 ${OET_PATH}/test.py | grep -v "E501 line too long" | grep -c "E225 missing whitespace around operator") 0
    CHECK_RESULT $(pycodestyle --ignore=E501 ${OET_PATH}/test.py | grep -c "E501 line too long") 0
    CHECK_RESULT $(pycodestyle --show-source ${OET_PATH}/test.py | egrep "a='123'|b='acc'|abcdddasffsffsffffffaaaaaavvcfddddddddddddddddddddddsdwefdfdgfgfgfgfgfdgfabcdddasffsffsffffffaaaaaavvcfddddddddddddddddddddddsdwefdfdgfgfgfgfgfdgfabcdddasffsffsffffffaaaaaavvcfddddddddddddddddddddddsdwefdfdgfgfgfgfgfdgf='456'" | wc -l) 4
    CHECK_RESULT $(pycodestyle --show-pep8 ${OET_PATH}/test.py  | egrep "There are still many devices around that are limited to 80 character|Always surround these binary operators with a single space on" | wc -l) 4
    CHECK_RESULT $(pycodestyle --statistics ${OET_PATH}/test.py | tail -n 2 | grep "E225 missing whitespace around operator" | awk '{print $1}') 3
    CHECK_RESULT $(pycodestyle --statistics ${OET_PATH}/test.py | tail -n 2 | grep "E501 line too long" | awk '{print $1}') 1
    CHECK_RESULT $(pycodestyle --count ${OET_PATH}/test.py 2>&1 | tail -n 1) 4
    CHECK_RESULT $(pycodestyle --max-line-length=7 ${OET_PATH}/test.py | grep -c "E501 line too long") 2
    CHECK_RESULT $(pycodestyle --format=pylint ${OET_PATH}/test.py | grep -c "\[E225\] missing whitespace around operator") 3
    CHECK_RESULT $(pycodestyle --format=pylint ${OET_PATH}/test.py | grep -c "\[E501\] line too long") 1
    pycodestyle --benchmark ${OET_PATH}/test.py | grep "per second"
    CHECK_RESULT $?
    CHECK_RESULT $(pycodestyle --config=${OET_PATH}/pycodestyle.config ${OET_PATH}/test.py 2>&1 | wc -l) 7
    LOG_INFO "End of the test."

}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # delete file
    rm -rf ${OET_PATH}/test.py ${OET_PATH}/pycodestyle.config
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"

