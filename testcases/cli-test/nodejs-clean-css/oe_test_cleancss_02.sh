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

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "nodejs tar"
    npm install -g clean-css-cli
    tar -xvf ./common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."
    cleancss --inline-timeout 2 ./data/one.css | grep ".one{color:red}"
    CHECK_RESULT $? 0 0 "Check cleancss --timeout failed"
    cleancss -O1 roundingPrecision:2 ./data/six.css  | grep ".six{height:20.25px;width:14.24px}"
    CHECK_RESULT $? 0 0 "Check cleancss roundingPrecision failed"
    cleancss -O1 specialComments:0 ./data/comment.css | grep ".six{height:20.245px;width:14.235px}"
    CHECK_RESULT $? 0 0 "Check cleancss specialComments:0 failed"
    cleancss -O1 specialComments:1 ./data/comment.css | grep "\/\*! this comment1 \*\/.six{height:20.245px;width:14.235px}"
    CHECK_RESULT $? 0 0 "Check cleancss specialComments:1 failed"
    echo ".a{margin:0}.b{margin:10px;padding:0}.c{margin:0}" | cleancss -O2 mergeSemantically:on | grep ".a,.c{margin:0}.b{margin:10px;padding:0}"
    CHECK_RESULT $? 0 0 "Check cleancss --semantic-merging failed"
    cleancss ./data/two.css  --inline local one.css 2>&1 | grep 'Ignoring local @import of "one.css"'
    CHECK_RESULT $? 0 0 "Check cleancss --inline local failed"
    cat ./data/mediatmp1.css ./data/mediatmp2.css | cleancss -O2 all:off | grep ".mediatmp1{color:#fff}@media screen and (min-width:900px){article{padding:1rem 3rem}}.mediatmp{color:#ffa}@media screen and (min-width:900px){article{padding:1rem 3rem}}"
    CHECK_RESULT $? 0 0 "Check cleancss --skip-media-merging failed"
    cleancss -O2 restructureRules:off ./data/one.css | grep ".one{color:red}"
    CHECK_RESULT $? 0 0 "Check cleancss skip restructureRules failed"
    cleancss -O2 mergeIntoShorthands:off ./data/one.css | grep ".one{color:red}"
    CHECK_RESULT $? 0 0 "Check cleancss skip mergeIntoShorthands failed"
    cleancss --source-map --output one.min.css ./data/one.css && grep ".one{color:red}" one.min.css && grep "\/\*# sourceMappingURL=one.min.css.map \*\/" one.min.css
    CHECK_RESULT $? 0 0 "Check cleancss --source-map failed"
    rm -f one.min.css
    cleancss --source-map --source-map-inline-sources --output one.min.css ./data/one.css && grep ".one{color:red}" one.min.css && grep "\/\*# sourceMappingURL=one.min.css.map \*\/" one.min.css
    CHECK_RESULT $? 0 0 "Check cleancss --source-map-inline-sources failed"
    rm -f one.min.css
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    npm uninstall -g clean-css-cli
    rm -rf ./data one.min.css.map
    LOG_INFO "End to restore the test environment."
}
main "$@"
