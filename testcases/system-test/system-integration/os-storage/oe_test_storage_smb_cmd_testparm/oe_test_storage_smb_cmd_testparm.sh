#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :  2020-4-10
# @License   :   Mulan PSL v2
# @Desc      :  Common Samba command line utilities-testparm
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL samba
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    # test order first
    expect -c "
		spawn testparm
		expect \"Press enter*\" {send \"\n\\r\"}
	"
    CHECK_RESULT $?
    # test order again
    cp -a /etc/samba/smb.conf /etc/samba/smb.conf.bak
    echo "hello world" >>/etc/samba/smb.conf

    expect -c "
	    log_file second.log
        spawn testparm
        expect \"Press enter*\" {send \"\n\\r\"}
    "
    grep 'hello world' second.log
    CHECK_RESULT $? 1
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    # remove package
    DNF_REMOVE
    # delete tmp file
    rm -rf /etc/samba/smb.conf
    mv /etc/samba/smb.conf.bak /etc/samba/smb.conf
    rm -rf second.log
    LOG_INFO "Finish environment cleanup."
}

main $@
