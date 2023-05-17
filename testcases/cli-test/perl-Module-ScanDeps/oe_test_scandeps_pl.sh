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
# @Desc      :   Test perl-Module-ScanDeps
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "perl-Module-ScanDeps tar"
    tar -xvf common/data.tar.gz > /dev/null
    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start to run test."
    scandeps.pl -B ./data/Html.pm | grep "Encode::Alias"
    CHECK_RESULT $? 0 0 "Check scandeps.pl -B failed"
    scandeps.pl -V ./data/Html.pm | grep "Pod::Simple::SimpleTree"
    CHECK_RESULT $? 0 0 "Check scandeps.pl -V failed"
    scandeps.pl -T ./data/Html.pm | grep "Encode::Config"
    CHECK_RESULT $? 0 0 "Check scandeps.pl -T failed"
    scandeps.pl -x data/Html.pm  | grep "Socket"
    CHECK_RESULT $? 0 0 "Check scandeps.pl -x failed"
    scandeps.pl --xargs="data" ./data/Html.pm
    CHECK_RESULT $? 0 0 "Check scandeps.pl --xargs failed"
    scandeps.pl -c ./data/Html.pm 2>&1 | grep "syntax OK"
    CHECK_RESULT $? 0 0 "Check scandeps.pl -c failed"
    scandeps.pl -R ./data/Html.pm  | grep "parent"
    CHECK_RESULT $? 0 0 "Check scandeps.pl -R failed"
    scandeps.pl -e "use utf8"
    CHECK_RESULT $? 0 0 "Check scandeps.pl -e failed"
    scandeps.pl -C tmpa.txt  ./data/Html.pm && test -f tmpa.txt
    CHECK_RESULT $? 0 0 "Check scandeps.pl -C failed"
    LOG_INFO "End of the test."
}
function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./data tmp.txt tmpa.txt
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
