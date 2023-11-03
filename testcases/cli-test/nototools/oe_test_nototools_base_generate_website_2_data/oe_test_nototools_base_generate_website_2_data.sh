#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hanliyi
# @Contact   :   1032864780@qq.com
# @Date      :   2022/08/27
# @License   :   Mulan PSL v2
# @Desc      :   TEST generate_website_2_data.py in nototools options
# #############################################

source "../common/common.sh"

#Installation preparation for test objects, tools required for testing, etc.
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    
    common_pre

    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    # Compare Help Information for consistency
    LOG_INFO "generate_website_2_data help information "
    generate_website_2_data.py -h | grep -q "usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    generate_website_2_data.py --help | grep -q "usage"
    CHECK_RESULT $? 0 0 "option: --help error"

    #Test the -c parameter
    generate_website_2_data.py -c
    CHECK_RESULT $? 0 0 "option: -c error"
    generate_website_2_data.py --clean
    CHECK_RESULT $? 0 0 "option: --clean error"

    # Test the -d parameter
    generate_website_2_data.py -d
    CHECK_RESULT $? 0 0 "option: -d error"
    generate_website_2_data.py --dest 
    CHECK_RESULT $? 0 0 "option: --dest error"

    # Test the -pj parameter
    generate_website_2_data.py -pj 
    CHECK_RESULT $? 0 0 "option: -pj error"
    generate_website_2_data.py --pretty_json
    CHECK_RESULT $? 0 0 "option: --pretty_json error"

    # Test the -nr parameter
    generate_website_2_data.py -nr 
    CHECK_RESULT $? 0 0 "option: -nr error"
    generate_website_2_data.py --no_repo_check
    CHECK_RESULT $? 0 0 "option: --no_repo_check error"

    # Test the -nz parameter
    generate_website_2_data.py -nz 
    CHECK_RESULT $? 0 0 "option: -nz error"
    generate_website_2_data.py --no_zips
    CHECK_RESULT $? 0 0 "option: --no_zips error"

    # Test the -ni parameter
    generate_website_2_data.py -ni 
    CHECK_RESULT $? 0 0 "option: -ni error"
    generate_website_2_data.py --no_images
    CHECK_RESULT $? 0 0 "option: --no_images error"

    # Test the -nd parameter
    generate_website_2_data -nd 
    CHECK_RESULT $? 0 0 "option: -nd error"
    generate_website_2_data --no_data
    CHECK_RESULT $? 0 0 "option: --no_data error"

    # Test the -nc parameter
    generate_website_2_data.py -nc 
    CHECK_RESULT $? 0 0 "option: -nc error"
    generate_website_2_data.py --no_css
    CHECK_RESULT $? 0 0 "option: --no_css error"

    # Test the -n parameter
    generate_website_2_data.py -n 
    CHECK_RESULT $? 0 0 "option: -n error"
    generate_website_2_data.py --no_build
    CHECK_RESULT $? 0 0 "option: --no_build error"

    # Test the --debug parameter
    for i in "ttf" "TTC" "otf"
    do
        generate_website_2_data.py --debug ${i}
        CHECK_RESULT $? 0 0 "option: --debug ${i} error"
    done
    
    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    common_post

    LOG_INFO "End to restore the test environment."
}

main "$@"