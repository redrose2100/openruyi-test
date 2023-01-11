# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of tboot command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL tboot

    lcp2_mlehash --create --alg sha1 --cmdline "logging=serial,memory,vga" /boot/tboot.gz > mle_hash

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    lcp2_crtpolelt --create --type mle --minver 17 --out mle.elt mle_hash
    CHECK_RESULT $? 0 0 "Check lcp2_mlehash -create --type --minver --out failed"




    lcp2_crtpolelt --create --type mle --out pconf.elt
    CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --create  failed"
    lcp2_crtpolelt --create --type custom --uuid tboot --out pconf.elt 2>&1 | grep 'CONSTRAINT'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --create  failed"
    lcp2_crtpolelt --create --type pconf --out pconf.elt
    CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --create --type pconf --out failed"
    lcp2_crtpolelt --create --type sbios --alg sha1 --out pconf.elt
    CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --create --create --type sbios --alg --out failed"
    lcp2_crtpolelt --create --type stm --alg sha1 --out pconf.elt
    CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --create --type stm --alg --out failed"
    lcp2_crtpolelt --create --type mle2 --alg sha1 --minver 1 --out pconf.elt
    CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --create --type mle2 --alg --minver --out failed"
    lcp2_crtpolelt --show pconf.elt 2>&1 | grep 'policy element'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --show failed"
    lcp2_crtpolelt --show pconf.elt --verbose 2>&1 | grep 'policy element'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --verbose failed"
    lcp2_crtpolelt --help 2>&1 | grep 'Usage'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --help failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf pconf.elt
    DNF_REMOVE
    LOG_INFO "Een to restore the test environment."
}

main $@
