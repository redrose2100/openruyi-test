#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   lemon.higgins
#@Contact   	:   lemon.higgins@aliyun.com
#@Date      	:   2020-04-09 09:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test ls command as an example
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# 闇€瑕侀鍔犺浇鐨勬暟鎹€佸弬鏁伴厤缃?
function config_params() {
    LOG_INFO "Start to config params of the case."

    LOG_INFO "No params need to config."

    LOG_INFO "End to config params of the case."
}

# 娴嬭瘯瀵硅薄銆佹祴璇曢渶瑕佺殑宸ュ叿绛夊畨瑁呭噯澶?
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "vim bc"

    LOG_INFO "End to prepare the test environment."
}

# 娴嬭瘯鐐圭殑鎵ц
function run_test() {
    LOG_INFO "Start to run test."

    # 娴嬭瘯鍛戒护锛歭s
    ls -CZl -all
    CHECK_RESULT 0

    # 娴嬭瘯/鐩綍涓嬫槸鍚﹀瓨鍦╬roc|usr|roor|var|sys|etc|boot|dev鐩綍
    CHECK_RESULT "$(ls / | grep -cE 'proc|usr|roor|var|sys|etc|boot|dev')" 7 0 "The system is missing a base directory."

    LOG_INFO "End to run test."
}

# 鍚庣疆澶勭悊锛屾仮澶嶆祴璇曠幆澧?
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
