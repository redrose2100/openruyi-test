#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023/05/15
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of freetds command
# ############################################
#shellcheck disable=SC1091
source ./common.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    common_pre
    echo "INSERT INTO [dbo].[test_user] ([id]) VALUES (10)" >inputFile.sql
    bsqldb -U sa -P Hw123456 -S egServer70 -D test1 -i inputFile.sql
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    freebcp test_user out 1.txt -U sa -P Hw123456 -S egServer70 -D test1 -o outFile1 -c && grep "10" 1.txt
    CHECK_RESULT $? 0 0 "Check freebcp out -c failed"

    freebcp test_user out 2.txt -U sa -P Hw123456 -S egServer70 -D test1 -o outFile1 -I /etc/freetds.conf -m 10 -c -e error.log -F 1 -L 5 -b 10 -t '\t' -r '\n' && grep "10" 2.txt
    CHECK_RESULT $? 0 0 "Check freebcp out -e -I -m -F -L -b -t -r failed"

    freebcp test_user out 3.txt -U sa -P Hw123456 -S egServer70 -D test1 -d -c && grep "10" 3.txt
    CHECK_RESULT $? 0 0 "Check freebcp out -d -c failed"

    freebcp test_user out 5.txt -U sa -P Hw123456 -S egServer70 -D test1 -v | grep "freebcp version"
    CHECK_RESULT $? 0 0 "Check freebcp out -v failed"

    freebcp test_user out 6.txt -U sa -P Hw123456 -S egServer70 -D test1 -d -c -h order && grep "10" 6.txt
    CHECK_RESULT $? 0 0 "Check freebcp out -h failed"

    freebcp test_user out 7.txt -U sa -P Hw123456 -S egServer70 -D test1 -d -c -T 200 -A 200 -O "SET QUOTED_IDENTIFIER OFF" && grep "10" 7.txt
    CHECK_RESULT $? 0 0 "Check freebcp out -T -A -O failed"

    freebcp test1.dbo.test_user in inputFile.sql -U sa -P Hw123456 -S egServer70 -n
    CHECK_RESULT $? 0 0 "Check freebcp in -n failed"

    freebcp "select * from test1.dbo.test_user" queryout insert.txt -U sa -P Hw123456 -S egServer70 -d -c && grep "10" insert.txt
    CHECK_RESULT $? 0 0 "Check freebcp queryout -d -c failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    common_post
    rm -rf inputFile.sql ./*.txt ./outFile*
    LOG_INFO "Finish restore the test environment."
}

main "$@"
