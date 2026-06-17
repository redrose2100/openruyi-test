#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
###################################
#@Author        :   yangyuangan
#@Contact       :   yangyuangan@uniontech.com
#@Date          :   2026/6/17
#@License       :   Mulan PSL v2
#@Desc          :   bash getopts CLI argument parsing
###################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."

    # shift shifts positional parameters
#    set -- alice bob charlie
#    test "$1" = "alice"
#    CHECK_RESULT $? 0 0 "set -- positional param1 failed"
#    shift
#    test "$1" = "bob"
#    CHECK_RESULT $? 0 0 "shift param1 → bob failed"
#    test $# -eq 2
#    CHECK_RESULT $? 0 0 "shift should reduce param count"

    # shift N shifts multiple
#    set -- a b c d e
#    shift 3
#    test "$1" = "d"
##    CHECK_RESULT $? 0 0 "shift 3 param1 → d failed"
#    test $# -eq 2
#    CHECK_RESULT $? 0 0 "shift 3 count should be 2"

    # getopts parses short options (simulate 'script -a -b value -c')
    parse_opts() {
        while getopts "ab:c" opt; do
            case $opt in
                a) echo "flag_a" ;;
                b) echo "opt_b=$OPTARG" ;;
                c) echo "flag_c" ;;
                *) echo "invalid" ;;
            esac
        done
    }
    result=$(parse_opts -a -b hello -c)
    CHECK_RESULT $? 0 0 "getopts parsing failed"
    echo "$result" | grep -q "flag_a"
    CHECK_RESULT $? 0 0 "getopts flag -a not detected"
    echo "$result" | grep -q "opt_b=hello"
    CHECK_RESULT $? 0 0 "getopts -b value not captured"
    echo "$result" | grep -q "flag_c"
    CHECK_RESULT $? 0 0 "getopts flag -c not detected"

    # getopts with unknown option (silent mode :) 
    parse_opts2() {
        while getopts ":x:" opt 2>/dev/null; do
            case $opt in
                x) echo "opt_x=$OPTARG" ;;
                \?) echo "unknown_opt" ;;
            esac
        done
    }
    result2=$(parse_opts2 -z 2>/dev/null)
    echo "$result2" | grep -q "unknown_opt"
    CHECK_RESULT $? 0 0 "getopts unknown option not caught"

    # OPTIND reset between getopts invocations
    OPTIND=1

    LOG_INFO "Finish test!"
}

main "$@"
