#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   huangjiayi
# @Contact   :   1960887351@qq.com
# @Date      :   2022/9/12
# @License   :   Mulan PSL v2
# @Desc      :   Test "pyScss" command
# ##################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."

    pip3 install pyScss

    LOG_INFO "End to prepare the test environment."
}
##########################################################

##########################################################
function run_test(){
    LOG_INFO "Start to run test."

    python -mscss -C &
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "L$LINENO: pyScss -C No Pass"

    python -mscss -h | grep "Converts Scss files to CSS."
    CHECK_RESULT $? 0 0 "L$LINENO: pyScss -h No Pass"

    python -mscss -v | grep "pyScss v[[:digit:]]*.[[:digit:]]*.[[:digit:]]*"
    CHECK_RESULT $? 0 0 "L$LINENO: pyScss -v No Pass"

    python -mscss -sass &
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "L$LINENO: pyScss -sass No Pass"

    python -mscss -I PATH &
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "L$LINENO: pyScss -I No Pass"

    python -mscss -S PATH &
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "L$LINENO: pyScss -S No Pass"

    python -mscss -A PATH &
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "L$LINENO: pyScss -A No Pass"

    python -mscss -a URL &
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "L$LINENO: pyScss -a No Pass"

    python -mscss -F PATH &
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "L$LINENO: pyScss -F No Pass"

    python -mscss -f PATH &
    kill -9 $(pgrep -f scss)
    CHECK_RESULT $? 0 0 "L$LINENO: pyScss -f No Pass"

    LOG_INFO "End to run test."
}


function post_test(){
    LOG_INFO "Start to restore the test environment."

    pip3 uninstall -y pyScss
    
    LOG_INFO "End to restore the test environment."
}

main "$@"