#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-8-14
# @License   :   Mulan PSL v2
# @Desc      :   Use perl-DBI case
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh


function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "perl-DBI"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > available_drivers.pl << EOF
#!/usr/bin/perl

use strict;
use DBI;
my @ary = DBI->available_drivers();
print join("\n", @ary), "\n";
EOF
    CHECK_RESULT $? 0 0 "Error, Fail to save available_drivers.pl"
    chmod +x available_drivers.pl
    CHECK_RESULT $? 0 0 "Error,Fail to add execute command"
    num=$(./available_drivers.pl | wc -l)
    CHECK_RESULT "$num" 6 0 "Error, The quantity is inconsistent with the output result"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf available_drivers.pl
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"