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
    echo "INSERT INTO [dbo].[admin] ([id], [age]) VALUES (1,'18')" >inputFile.sql
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    bsqldb -U sa -P Hw123456 -S egServer70 -D test1 -i inputFile.sql -o outFile -e log_file.log && test -f outFile
    CHECK_RESULT $? 0 0 "Check bsqldb -U -P -S -D -i -o -e failed"

    echo "INSERT INTO [dbo].[admin] ([id], [age]) VALUES (2,'18')" >inputFile.sql
    bsqlodbc -U sa -P Hw123456 -S egServer70 -D test1 -i inputFile.sql -o outFile1 -e log_file.log && test -f outFile1
    CHECK_RESULT $? 0 0 "Check bsqlodbc -U -P -S -D -i -o -e failed"
    cat log_file.log
    bsqldb -U sa -P Hw123456 -S egServer70 -D test1 -i inputFile.sql
    datacopy -S egServer70/sa/Hw123456/test1/admin -D egServer70/sa/Hw123456/test1/test_admin -t -b 10 -p 10 -T 10 -E -v -d &&
        freebcp "select * from test1.dbo.test_admin" queryout out.txt -U sa -P Hw123456 -S egServer70 -d -c && grep "18" out.txt
    CHECK_RESULT $? 0 0 "Check datacopy -t failed"

    echo "delete from test_admin" >delete.sql
    bsqldb -U sa -P Hw123456 -S egServer70 -D test1 -i delete.sql
    datacopy -S egServer70/sa/Hw123456/test1/admin -D egServer70/sa/Hw123456/test1/test_admin -a -b 10 -p 10 -T 10 -E -v -d &&
        freebcp "select * from test1.dbo.test_admin" queryout out.txt -U sa -P Hw123456 -S egServer70 -d -c && grep "18" out.txt
    CHECK_RESULT $? 0 0 "Check datacopy -a failed"

    datacopy -S egServer70/sa/Hw123456/test1/admin -D egServer70/sa/Hw123456/test1/test1_admin -c dbo -b 10 -p 10 -T 10 -E -v -d &&
        freebcp "select * from test1.dbo.test1_admin" queryout out.txt -U sa -P Hw123456 -S egServer70 -d -c && grep "18" out.txt
    CHECK_RESULT $? 0 0 "Check datacopy -S -c failed"

    defncopy -U sa -P Hw123456 -S egServer70 -D test1 -i inputFile.sql -o outFile2 test_user && grep "CREATE TABLE dbo.test_user" outFile2
    CHECK_RESULT $? 0 0 "Check defncopy -i -o -e failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf inputFile.sql out.txt log_file.log delete.sql outFile*
    common_post
    LOG_INFO "Finish restore the test environment."
}

main "$@"
