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
    openssl genrsa -out privkey.pem 2048
    openssl rsa -pubout -in privkey.pem -out pubkey.pem

    LOG_INFO "Start to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    lcp2_crtpolelt --create --type mle --out pconf.elt
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --create  --type --out failed"
    lcp2_crtpollist --create --sigalg rsa --listver 0x200 --out list.lst pconf.elt 2>&1 | grep 'CONSTRAINT'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --create --sigalg --listver --out failed"
    lcp2_crtpollist --create --sigalg rsa --listver 0x200 --out list-unsig.lst
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --create --sigalg --listver --out failed"
    lcp2_crtpollist --sign --hashalg sha1 --sigalg rsa --pub pubkey.pem --priv privkey.pem --rev 1 --out list.lst 2>&1 | grep 'successfully'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --sign --hashalg --listver --sigalg --pub --priv --rev --out failed"
    lcp2_crtpollist --show list.lst --verbose 2>&1 | grep 'succeed!'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --show --verbose failed"
    cp list-unsig.lst list-sig.lst
    openssl genrsa -out privkey.pem 2048
    openssl dgst -sha1 -sign privkey.pem -out list.sig list-sig.lst
    lcp2_crtpollist --addsig --sig list.sig --out list-sig.lst
    CHECK_RESULT "$(test -f ./list-sig.lst)"1 0 "Check lcp2_crtpollist --addsig --sig --out failed"
    lcp2_crtpollist --version 2>&1 | grep 'lcp2_crtpollist version'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --version  failed"
    lcp2_crtpollist --help 2>&1 | grep 'Usage:'
    CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --help  failed"
    LOG_INFO "End to run  test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf list* pconf.elt privkey.pem pubkey.pem
    DNF_REMOVE
    LOG_INFO "Finish restore the test environment."
}

main $@
