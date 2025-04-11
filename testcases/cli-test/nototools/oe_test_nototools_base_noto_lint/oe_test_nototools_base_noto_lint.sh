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
# @Date      :   2022/08/25
# @License   :   Mulan PSL v2
# @Desc      :   TEST  noto_lint.py in nototools options
# #############################################
# shellcheck disable=SC1091
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
    noto_lint.py -h | grep -q "usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    noto_lint.py --help | grep -q "usage"
    CHECK_RESULT $? 0 0 "option: --help error"

    #Test the --csv parameter
    noto_lint.py ./NotoSansLao-Regular.ttf --csv | grep -q "Lao,Sans"
    CHECK_RESULT $? 0 0 "option: --csv error"

    #Test the --info parameter
    noto_lint.py ./NotoSansLao-Regular.ttf --info | grep -q "<info>"
    CHECK_RESULT $? 0 0 "option: --info error"

    #Test the --suppress_extrema_details parameter
    noto_lint.py ./NotoSansLao-Regular.ttf --suppress_extrema_details | grep -qE "Finished linting [[:digit:]]+ file"
    CHECK_RESULT $? 0 0 "option: --suppress_extrema_details error"

    #Test the --csv_header parameter
    noto_lint.py ./NotoSansLao-Regular.ttf --csv_header | grep -qE "Finished linting [[:digit:]]+ file"
    CHECK_RESULT $? 0 0 "option: --csv_header error"

    echo '[
  {
    "weight": "Bold",
    "width": "medium",
    "is_google": true,
    "vendor": "Google",
    "char_version": "1.0",
    "filepath": "./NotoSansLao-Regular.ttf",
    "family": "Noto Sans Lao",
    "style": "Regular",
    "script": "CJK",
    "variant": "Standard",
    "slope": 0,
    "fmt": "ttf",
    "manufacturer": "Google",
    "license_type": "SIL Open Font License",
    "is_hinted": true,
    "is_mono": false,
    "is_UI": false,
    "is_UI_metrics": false,
    "is_display": false,
    "is_cjk": true,
    "subset": "CJK Unified Ideographs"
  }
]
' >font1.json
    #Test the --font_props_file parameter
    noto_lint.py --font_props_file ./font1.json
    CHECK_RESULT $? 0 0 "option: --font_props_file error"

    #Test the --config_file parameter
    noto_lint.py --config_file ./lint_config.txt
    CHECK_RESULT $? 0 0 "option: --config_file error"

    #Test the --config lint_spec parameter
    noto_lint.py --config condition
    CHECK_RESULT $? 0 0 "option: ---config lint_spec"

    #Test the --runlog parameter
    noto_lint.py ./NotoSansLao-Regular.ttf --runlog | grep -qE "Ran [[:digit:]]+ tests"
    CHECK_RESULT $? 0 0 "option: --runlog error"

    #Test the --skiplog parameter
    noto_lint.py ./NotoSansLao-Regular.ttf --skiplog | grep -qE "Skipped [[:digit:]]+ test/groups"
    CHECK_RESULT $? 0 0 "option: --skiplog error"

    #Test the --dump_font_props parameter
    noto_lint.py ./NotoSansLao-Regular.ttf --dump_font_props | grep -q "NotoSansLao-Regular.ttf"
    CHECK_RESULT $? 0 0 "option: --dump_font_props error"

    #Test the -nw parameter
    noto_lint.py ./NotoSansLao-Regular.ttf -nw | grep -qE "Finished linting [[:digit:]]+ file"
    CHECK_RESULT $? 0 0 "option: -nw error"
    noto_lint.py ./NotoSansLao-Regular.ttf --nowarn | grep -qE "Finished linting [[:digit:]]+ file"
    CHECK_RESULT $? 0 0 "option: -nowarn error"

    #Test the -q parameter
    noto_lint.py ./NotoSansLao-Regular.ttf -q | grep -qE "Finished linting [[:digit:]]+ file"
    CHECK_RESULT $? 0 0 "option: -q error"
    noto_lint.py ./NotoSansLao-Regular.ttf --quiet | grep -qE "Finished linting [[:digit:]]+ file"
    CHECK_RESULT $? 0 0 "option: --quiet error"

    #Test the -p parameter
    noto_lint.py ./NotoSansLao-Regular.ttf -p 2 | grep -qE "Finished linting [[:digit:]]+ file"
    CHECK_RESULT $? 0 0 "option: -p error"
    noto_lint.py ./NotoSansLao-Regular.ttf --phase 2 | grep -qE "Finished linting [[:digit:]]+ file"
    CHECK_RESULT $? 0 0 "option: --phase error"

    #Test the -v parameter
    noto_lint.py ./NotoSansLao-Regular.ttf -v | grep -qE "Finished linting [[:digit:]]+ file"
    CHECK_RESULT $? 0 0 "option: -v error"
    noto_lint.py ./NotoSansLao-Regular.ttf --variable | grep -qE "Finished linting [[:digit:]]+ file"
    CHECK_RESULT $? 0 0 "option: --variable error"

    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    common_post
    rm -rf font1.json

    LOG_INFO "End to restore the test environment."
}

main "$@"
