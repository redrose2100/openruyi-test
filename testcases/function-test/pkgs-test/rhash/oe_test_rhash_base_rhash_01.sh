#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   czjoyit@qq.com
#@Contact   	:   czjoyit@qq.com
#@Date      	:   2022/07/26
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   Take the test rhash command
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test()
{
    #In the openEuler 22.03 LTS system, the version of the rhash is rhash-1.4.2
    #In the openEuler 20.03 LTS SP3 system, the version of the rhash is rhash-1.4.0
    LOG_INFO "Start to prepare the test environment."
    cp -f ./common/test1K.data .
    DNF_INSTALL "rhash"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # calculate  message digest
    rhash --gost12-256 test1K.data 2>&1 | grep "7a6682133082a49c37db7b008394aeb9c184d5fb2a8d2a6251dd4bba5f6744b4  test1K.data"
    CHECK_RESULT $? 0 0 "error --gost12-256"
    rhash --gost12-512 test1K.data 2>&1 | grep "fc44df1ffe41f70a41915b90380d458bdc149302576208d4cadee7c694e5a169812a52ea2b746b9c2c4d3e0808eb723afadabf6f795e60c9367269a8d3f6fbf8  test1K.data"
    CHECK_RESULT $? 0 0 "error --gost12-512"
    rhash --gost94 test1K.data 2>&1 | grep "890bb3ee5dbe4da22d6719a14efd9109b220607e1086c1abbb51eeac2b044cbb  test1K.data"
    CHECK_RESULT $? 0 0 "error --gost94"
    rhash --gost94-cryptopro test1K.data 2>&1 | grep "d9c92e33ab144bbb2262a5221739600062831664d16716d03751fba7d952cc06  test1K.data"
    CHECK_RESULT $? 0 0 "error --gost94-cryptopro"
    rhash --ripemd160 test1K.data 2>&1 | grep "29ea7f13cac242905ae2dc1a36d5985815b30356  test1K.data"
    CHECK_RESULT $? 0 0 "error --ripemd160"
    rhash --has160 test1K.data 2>&1 | grep "1a3ff10095b61f4ce0cbde76f615284e52133b99  test1K.data"
    CHECK_RESULT $? 0 0 "error --has160"
    rhash --edonr256 test1K.data 2>&1 | grep "069744670fd47d89f59489a45ee0d6b8f597c7c74895914997dedde4c60396f1  test1K.data"
    CHECK_RESULT $? 0 0 "error --edonr256"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf test1K.data
    DNF_REMOVE 
    LOG_INFO "End to restore the test environment."
}

main "$@"
