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
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    fisql -v 2>&1 | grep "fisql, a free isql replacement"
    CHECK_RESULT $? 0 0 "Check fisql -v failed"

    fisql -g 2>&1 | grep "fisql"
    CHECK_RESULT $? 0 0 "Check fisql -g failed"

    echo "INSERT INTO [dbo].[test_user] ([id]) VALUES (0)" >inputFile.sql
    fisql -e -U sa -P Hw123456 -S egServer70 -D test1 -i inputFile.sql -o outFile && grep -F "INSERT INTO [dbo].[test_user] ([id]) VALUES (0)" outFile
    CHECK_RESULT $? 0 0 "Check fisql -e failed"

    fisql -e -U sa -P Hw123456 -S egServer70 -D test1 -i inputFile.sql -o outFile1 -t 100 -s " " -w 80 && grep -F "INSERT INTO [dbo].[test_user] ([id]) VALUES (0)" outFile1
    CHECK_RESULT $? 0 0 "Check fisql -t -s -w failed"

    fisql -e -U sa -P Hw123456 -S egServer70 -D test1 -i inputFile.sql -o outFile2 -t 100 -s " " -w 80 -E vi -I /etc/freetds.conf -y test -c go -H root && grep -F "INSERT INTO [dbo].[test_user] ([id]) VALUES (0)" outFile2
    CHECK_RESULT $? 0 0 "Check fisql -E -I -y -c -H failed"

    fisql -e -U sa -P Hw123456 -S egServer70 -D test1 -i inputFile.sql -o outFile3 -t 100 -s " " -w 80 -E vi -I /etc/freetds.conf -y test -c go -H root -h 1 && grep -F "INSERT INTO [dbo].[test_user] ([id]) VALUES (0)" outFile3
    CHECK_RESULT $? 0 0 "Check fisql -h failed"

    fisql -F -U sa -P Hw123456 -S egServer70 -D test1 -i inputFile.sql -o outFile4 -z us_english && grep "Changed language setting to us_english" outFile4
    CHECK_RESULT $? 0 0 "Check fisql -F failed"

    fisql -n -U sa -P Hw123456 -S egServer70 -D test1 -i inputFile.sql -o outFile5 -t 100 -s " " -w 80 -E vi -h 1 -I /etc/freetds.conf -y test -c go -H root && grep -F "INSERT INTO [dbo].[test_user] ([id]) VALUES (0)" outFile5
    CHECK_RESULT $? 0 0 "Check fisql -n failed"

    fisql -X -U sa -P Hw123456 -S egServer70 -D test1 -i inputFile.sql -o outFile6 -t 100 -s " " -w 80 -E vi -h 1 -I /etc/freetds.conf -y test -c go -H root && grep -F "INSERT INTO [dbo].[test_user] ([id]) VALUES (0)" outFile6
    CHECK_RESULT $? 0 0 "Check fisql -X failed"

    fisql -Y -U sa -P Hw123456 -S egServer70 -D test1 -i inputFile.sql -o outFile7 -t 100 -s " " -w 80 -E vi -h 1 -I /etc/freetds.conf -y test -c go -H root && grep -F "INSERT INTO [dbo].[test_user] ([id]) VALUES (0)" outFile7
    CHECK_RESULT $? 0 0 "Check fisql -Y failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf inputFile.sql outFile*
    common_post
    LOG_INFO "Finish restore the test environment."
}

main "$@"
