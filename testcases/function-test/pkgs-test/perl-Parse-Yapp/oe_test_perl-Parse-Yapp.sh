#!/usr/bin/bash
# shellcheck disable=SC2154

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   guheping
# @Contact   :   867559702@qq.com
# @Date      :   2023/8/05
# @License   :   Mulan PSL v2
# @Desc      :   Test "yapp" command
# ##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "perl-Parse-Yapp"
    cat<<EOF >mygrammar.yp
%{
use strict;
use warnings;
%}

%token NUM
%left '+' '-'
%left '*' '/'

%%
Expr:     NUM
       | Expr '+' Expr
       | Expr '-' Expr
       | Expr '*' Expr
       | Expr '/' Expr
       ;
%%

sub _Error {
    my ($parser, $message) = @_;
    die "Syntax error: $message\n";
}
EOF
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    yapp -m grammar mygrammar.yp
    find . -name grammar.pm | grep grammar.pm
    CHECK_RESULT $? 0 0 "L$LINENO: -m No Pass"
    yapp -v mygrammar.yp
    find . -name mygrammar.output | grep -e mygrammar.output
    CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
    yapp -s mygrammar.yp
    grep iso mygrammar.pm
    grep "standalone parser" < mygrammar.pm
    CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
    yapp -n mygrammar.yp
    find . -name mygrammar.pm | grep mygrammar.pm
    CHECK_RESULT $? 0 0 "L$LINENO: -n No Pass"
    yapp -o mygrammar.pl mygrammar.yp
    find . -name mygrammar.pl | grep mygrammar.pl
    CHECK_RESULT $? 0 0 "L$LINENO: -o No Pass"
    yapp -t mygrammar.output mygrammar.yp
    grep iso mygrammar.pm
    grep "Conflicts" < mygrammar.pm
    CHECK_RESULT $? 0 0 "L$LINENO: -t No Pass"
    yapp -b '/usr/local/bin/perl -w' -o mygrammar2.pl mygrammar.yp
    find . -name mygrammar2.pl | grep mygrammar2.pl
    CHECK_RESULT $? 0 0 "L$LINENO: -b No Pass"
    yapp mygrammar
    find . -name mygrammar.pm | grep mygrammar.pm
    CHECK_RESULT $? 0 0 "L$LINENO: grammar No Pass"
    yapp -V | grep -e "This is Parse::Yapp version"
    CHECK_RESULT $? 0 0 "L$LINENO: -V No Pass"
    yapp -h 2>&1 | grep "Usage:"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf ./*grammar*
    LOG_INFO "End to restore the test environment."
}

main "$@"
