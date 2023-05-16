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

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "freetds"
    echo "INSERT INTO [dbo].[test_user] ([id], [user]) VALUES (0,'lisi')" > inputFile.sql
    bsqldb -U sa -P Hw123456 -S egServer70 -D test1 -i inputFile.sql
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    echo exit | tsql -U sa -P Hw123456 -p 1433 -S egServer70 -D test1 -H root -I /etc/freetds.conf -o f -a test -t '\t' -r '\n' | grep "Setting test1 as default"
    CHECK_RESULT $? 0 0 "Check tsql f failed"

    echo exit | tsql -U sa -P Hw123456 -p 1433 -S egServer70 -D test1 -H root -I /etc/freetds.conf -o h -a test -t '\t' -r '\n' | grep "Setting test1 as default"
    CHECK_RESULT $? 0 0 "Check tsql h failed"

    echo exit | tsql -U sa -P Hw123456 -p 1433 -S egServer70 -D test1 -H root -I /etc/freetds.conf -o t -a test -t '\t' -r '\n' | grep "Setting test1 as default"
    CHECK_RESULT $? 0 0 "Check tsql t failed"

    echo exit | tsql -U sa -P Hw123456 -p 1433 -S egServer70 -D test1 -H root -I /etc/freetds.conf -o v -a test -t '\t' -r '\n' | grep "Setting test1 as default"
    CHECK_RESULT $? 0 0 "Check tsql v failed"

    echo exit | tsql -U sa -P Hw123456 -p 1433 -S egServer70 -D test1 -H root -I /etc/freetds.conf -o q -a test -t '\t' -r '\n' | grep "Setting test1 as default"
    CHECK_RESULT $? 0 0 "Check tsql q failed"

    echo quit | osql -U sa -P Hw123456 -S egServer70
    CHECK_RESULT $? 0 0 "Check osql -U -P -S failed"

    tdspool -l 1.log -d mypool
    CHECK_RESULT $? 0 0 "Check tdspool -l -d failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf inputFile.sql outFile*
    LOG_INFO "Finish restore the test environment."
}

main "$@"
