#!/usr/bin/bash
# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/20
# @License   :   Mulan PSL v2
# @Desc      :   Test cleancss
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}/testcases/cli-test/nodejs-clean-css/common/checkenv.sh"


function pre_test() {
    # clean-css 4.0.0 版本后， API 和 CLI 接口分开， 当前包不再支持cli命令
    # !!! 注意不要通过 npm install clean-css-cli的方式来测cli包， 这样安装的包和openeuler社区包没有关系
    checkversion400
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "nodejs tar nodejs-clean-css"
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}


function run_test() {
    LOG_INFO "Start to run test."
    cleancss -h | grep "Usage: cleancss"
    CHECK_RESULT $? 0 0 "Check cleancss -h failed"
    cleancss --help | grep "Usage: cleancss"
    CHECK_RESULT $? 0 0 "Check cleancss --help failed"
    cleancss -v
    CHECK_RESULT $? 0 0 "Check cleancss -v failed"
    cleancss --version
    CHECK_RESULT $? 0 0 "Check cleancss --version failed"
    cleancss -b ./data/*.css | grep ".one{color:red}"
    CHECK_RESULT $? 0 0 "Check cleancss -b failed"
    cleancss --keep-line-breaks ./data/*.css | grep ".one{color:red}"
    CHECK_RESULT $? 0 0 "Check cleancss -b failed"
    cleancss --compatibility 'ie9,-colors.opacity,-units.rem' ./data/one.css |  grep ".one{color:red}"
    CHECK_RESULT $? 0 0 "Check cleancss --compatibility failed"
    cleancss -c 'ie9,-colors.opacity,-units.rem' ./data/one.css |  grep ".one{color:red}"
    CHECK_RESULT $? 0 0 "Check cleancss -c failed"
    cleancss -d ./data/one.css 2>&1 | grep "Original: 21 bytes"
    CHECK_RESULT $? 0 0 "Check cleancss -d failed"
    cleancss --debug ./data/one.css 2>&1 | grep "Original: 21 bytes"
    CHECK_RESULT $? 0 0 "Check cleancss --debug failed"
    cleancss -o one.min.css ./data/one.css
    grep ".one{color:red}" one.min.css
    CHECK_RESULT $? 0 0 "Check cleancss -o failed"
    cleancss --output one.min.css ./data/one.css
    grep ".one{color:red}" one.min.css
    CHECK_RESULT $? 0 0 "Check cleancss --output failed"
    cleancss -r . ./data/two.css | grep ".one{color:red}.three{color:#0f0}.four{color:#00f}.two{color:#fff}"
    CHECK_RESULT $? 0 0 "Check cleancss -r failed"
    cleancss --root . ./data/two.css | grep ".one{color:red}.three{color:#0f0}.four{color:#00f}.two{color:#fff}"
    CHECK_RESULT $? 0 0 "Check cleancss --root failed"
    cleancss -s ./data/two.css | grep "@import url(one.css);@import url(extra/three.css)"
    CHECK_RESULT $? 0 0 "Check cleancss -s failed"
    cleancss --skip-import ./data/two.css | grep "@import url(one.css);@import url(extra/three.css)"
    CHECK_RESULT $? 0 0 "Check cleancss --skip-import failed"
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf ./data one.min.css
    LOG_INFO "End to restore the test environment."
}


main "$@"

