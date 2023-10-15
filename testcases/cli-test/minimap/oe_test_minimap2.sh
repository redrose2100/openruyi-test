#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhangmei
#@Contact       :   zhangmei@uniontech.com
#@Date          :   2023-4-20
#@License       :   Mulan PSL v2
#@Desc          :   minimap2 test
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "minimap2"
    minimap2 --v
    CHECK_RESULT $? 0 0 "log message: Failed install minimap2 "
}

function run_test()
{
    LOG_INFO "Start to run test."
    minimap2 -a upstream1000.fa.gz upstream2000.fa.gz > test.sam
    CHECK_RESULT $? 0 0 "log message: Failed to run command"
    minimap2 -x map-ont -d MT-human-ont.mmi upstream1000.fa.gz
    CHECK_RESULT $? 0 0 "log message: Failed to run command"
    minimap2 -a MT-human-ont.mmi upstream2000.fa.gz > test.sam
    CHECK_RESULT $? 0 0 "log message: Failed to run command"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf test.sam
    rm -rf MT-human-ont.mmi
    LOG_INFO "End to restore the test environment."
}

main "$@"
