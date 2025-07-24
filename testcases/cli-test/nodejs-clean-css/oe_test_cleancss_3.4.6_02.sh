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
    cleancss -t 2 ./data/one.css  | grep ".one{color:red}"
    CHECK_RESULT $? 0 0 "Check cleancss -t failed"
    cleancss --timeout 2 ./data/one.css  | grep ".one{color:red}"
    CHECK_RESULT $? 0 0 "Check cleancss --timeout failed"
    cleancss --rounding-precision 2 ./data/six.css  | grep ".six{height:20.25px;width:14.24px}"
    CHECK_RESULT $? 0 0 "Check cleancss --rounding-precision failed"
    cleancss ./data/comment.css --s0 | grep ".six{height:20.25px;width:14.24px}"
    CHECK_RESULT $? 0 0 "Check cleancss --s0 failed"
    cleancss ./data/comment.css --s1 | grep "\/\*! this comment1 \*\/.six{height:20.25px;width:14.24px}"
    CHECK_RESULT $? 0 0 "Check cleancss --s1 failed"
    echo ".a{margin:0}.b{margin:10px;padding:0}.c{margin:0}" | cleancss --semantic-merging | grep ".a,.c{margin:0}.b{margin:10px;padding:0}"
    CHECK_RESULT $? 0 0 "Check cleancss --semantic-merging failed"
    echo ".a{margin:0}.b{margin:10px;padding:0}.c{margin:0}" | cleancss --skip-advanced --semantic-merging | grep ".a{margin:0}.b{margin:10px;padding:0}.c{margin:0}"
    CHECK_RESULT $? 0 0 "Check cleancss --skip-advanced failed"
    echo ".a{margin:0}.b{margin:10px;padding:0}.c{margin:0}" | cleancss --skip-aggressive-merging --semantic-merging | grep ".a,.c{margin:0}.b{margin:10px;padding:0}"
    CHECK_RESULT $? 0 0 "Check cleancss --skip-aggressive-merging failed"
    cleancss ./data/two.css  --skip-import-from one.css 2>&1 | grep 'Ignoring local @import of "one.css"'
    CHECK_RESULT $? 0 0 "Check cleancss --skip-aggressive-merging failed"
    cat ./data/mediatmp1.css ./data/mediatmp2.css | cleancss  --skip-media-merging | grep ".mediatmp1{color:#fff}@media screen and (min-width:900px){article{padding:1rem 3rem}}.mediatmp{color:#ffa}@media screen and (min-width:900px){article{padding:1rem 3rem}}"
    CHECK_RESULT $? 0 0 "Check cleancss --skip-media-merging failed"
    cat ./data/five.css ./data/five.css | cleancss --skip-rebase | grep ".five{background:url(data:image/jpeg;base64,/9j/)}"
    CHECK_RESULT $? 0 0 "Check cleancss --skip-rebase failed"
    cleancss --skip-restructuring ./data/one.css | grep ".one{color:red}"
    CHECK_RESULT $? 0 0 "Check cleancss --skip-restructuring failed"
    cleancss --skip-shorthand-compacting ./data/one.css | grep ".one{color:red}"
    CHECK_RESULT $? 0 0 "Check cleancss --skip-shorthand-compacting failed"
    cleancss --source-map --output one.min.css ./data/one.css && grep ".one{color:red}\/\*# sourceMappingURL=one.min.css.map \*\/" one.min.css
    CHECK_RESULT $? 0 0 "Check cleancss --source-map failed"
    rm -f one.min.css
    cleancss --source-map --source-map-inline-sources --output one.min.css ./data/one.css && grep ".one{color:red}\/\*# sourceMappingURL=one.min.css.map \*\/" one.min.css
    CHECK_RESULT $? 0 0 "Check cleancss --source-map-inline-sources failed"
    rm -f one.min.css
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf ./data one.min.css.map
    LOG_INFO "End to restore the test environment."
}


main "$@"

