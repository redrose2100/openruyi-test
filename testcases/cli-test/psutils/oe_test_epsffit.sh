#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   linjianbo
# @Contact   :   jianbo.lin@outlook.com
# @Date      :   2023/07/28
# @License   :   Mulan PSL v2
# @Desc      :   test epsffit and extractres
# #############################################

# shellcheck disable=SC1091
source "./common/test_epsffit.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL psutils
    box_llx=0
    box_lly=0
    box_urx=200
    box_ury=300
    version=$(rpm -qa psutils | awk -F "-" '{print$2}')
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # test epsffit -v
    test "$(epsffit --version 2>&1 | awk 'NR==1{print$2}')" == "$version"
    CHECK_RESULT $? 0 0 "epsffit -v execution failed."

    # test espffit llx lly urx ury
    test_epsffit "" "$box_llx" "$box_lly" "$box_urx" "$box_ury" "./common/a4-1.ps"

    # test -c option
    test_epsffit "-c" "$box_llx" "$box_lly" "$box_urx" "$box_ury" "./common/a4-1.ps" 

    # test -a option
    test_epsffit "-a" "$box_llx" "$box_lly" "$box_urx" "$box_ury" "./common/a4-1.ps"

    # test -r option
    test_epsffit "-r" "$box_llx" "$box_lly" "$box_urx" "$box_ury" "./common/a4-1.ps"

    # test -m option
    test_epsffit "-m" "$box_llx" "$box_lly" "$box_urx" "$box_ury" "./common/a4-1.ps"

    # test -s option
    test_epsffit "-s" "$box_llx" "$box_lly" "$box_urx" "$box_ury" "./common/a4-1.ps"

    # test extractres
    extractres -m ./common/a4-1.ps 2>&1
    find . -name ISO-8859-1Encoding.enc
    CHECK_RESULT $? 0 0 "extractres -m ./common/a4-1.ps execution failed."
    
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf ISO-8859-1Encoding.enc a2ps*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
