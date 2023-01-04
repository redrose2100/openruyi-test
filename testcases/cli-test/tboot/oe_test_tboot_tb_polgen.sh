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
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    tb_polgen --create --type nonfatal --alg sha1 --ctrl 0x00 --verbose vl.pol 2>&1 | grep 'new policy'
    CHECK_RESULT $? 0 0 "Check tb_polgen create --type  failed"
    lcp2_crtpol --create --alg sha1 --polver 3.2 --type any --pol list.pol --sign rsa-2048-sha1
    CHECK_RESULT $? 0 0 "Check --create --alg --polver --type --pol --sign failed"
    tb_polgen --add --num 0 --pcr 19 --hash image --cmdline "cmdline" --image /boot/vmlinuz-5.10.0-60.18.0.50.oe2203.x86_64 --verbose vl.pol 2>&1 | grep 'policy entry'
    CHECK_RESULT $? 0 0 "Check --add --num --pcr --hash --type --cmdline --image --verbose failed"
    tb_polgen --del --num 0 --verbose vl.pol 2>&1 | grep 'hash_alg'
    CHECK_RESULT $? 0 0 "Check tb_polgen del failed"
    tb_polgen --unwrap --elt list.pol pconf.elt --verbose vl.pol 2>&1 | grep 'reading existing'
    CHECK_RESULT $? 0 0 "Check tb_polgen --unwrap --elt --verbose failed"
    tb_polgen --show vl.pol 2>&1 | grep 'policy_control:'
    CHECK_RESULT $? 0 0 "Check tb_polgen --show failed"
    tb_polgen --help 2>&1 | grep 'tb_polgen'
    CHECK_RESULT $? 0 0 "Check tb_polgen --help failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf vl.pol list.pol pconf.elt
    DNF_REMOVE
    LOG_INFO "Finish restore the test environment."
}

main $@
