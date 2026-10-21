#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   guheping
#@Contact   :   867559702@qq.com
#@Date      :   2022/12/05
#@License   :   Mulan PSL v2
#@Desc      :   Test "pylint" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "pylint"
    cat<<EOF >plugin.py
from typing import TYPE_CHECKING

import astroid

if TYPE_CHECKING:
    from pylint.lint import PyLinter


def register(linter: "PyLinter") -> None:
  """This required method auto registers the checker during initialization.

  :param linter: The linter to register the checker to.
  """
  print('Hello world')
EOF
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    pylint --init-hook='import sys; import os; sys.path.append(os.getcwd())' --load-plugins plugin ./common/test.py | grep "Hello world"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --load-plugins <modules> No Pass"
    pylint --fail-under 9 --generate-rcfile | grep "fail-under=9.0"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --fail-under <score> No Pass"
    pylint -j 1 ./common/test.py | grep "Module test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint -j <n-processes> No Pass"
    pylint --limit-inference-results 10 ./common/test.py | grep "Module test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --limit-inference-results <number-of-results> No Pass"
    pylint --extension-pkg-whitelist=PyQt5 ./common/test.py | grep "Module test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --extension-pkg-whitelist pkg No Pass"
    pylint --suggestion-mode n --generate-rcfile | grep "suggestion-mode=no"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --suggestion-mode <yn> No Pass"
    pylint --exit-zero ./common/test.py | grep "Module test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --exit-zero No Pass"
    echo s=666 | pylint --from-stdin test | grep "Module test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --from-stdin No Pass"
    pylint --generate-rcfile > pylint.conf
    pylint --rcfile=pylint.conf ./common/test.py | grep "Module test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --rcfile <file> No Pass"
    pylint --help-msg=missing-module-docstring | grep "missing-module-docstring"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --help-msg <msg-id> No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f pylint.conf plugin.py
    LOG_INFO "End to restore the test environment."
}

main "$@"