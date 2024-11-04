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
# @Author    :   tanxin
# @Contact   :   njutanx@163.com
# @Date      :   2023/8/29
# @License   :   Mulan PSL v2
# @Desc      :   Test "dsconf" command
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8    
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    dsconf localhost backend create --suffix dc=example,dc=com --be-name example
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost plugin -h | grep  "usage: dsconf.* instance plugin" 
    CHECK_RESULT $? 0 0 "Check: plugin -h No Pass" 
    dsconf localhost plugin memberof -h | grep  "usage: dsconf.* instance plugin memberof" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof -h No Pass" 
    dsconf localhost plugin memberof show -h | grep  "usage: dsconf.* instance plugin memberof show" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof show -h No Pass" 
    dsconf localhost plugin memberof show | grep -iE "dn: cn=MemberOf Plugin,cn=plugins,cn=config" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof show No Pass" 
    dsconf localhost plugin memberof disable -h | grep  "usage: dsconf.* instance plugin memberof disable" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof disable -h No Pass" 
    dsconf localhost plugin memberof enable
    dsconf localhost plugin memberof disable | grep -iE "Disabled plugin 'MemberOf Plugin'" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof disable dn No Pass" 
    dsconf localhost plugin memberof enable -h | grep  "usage: dsconf.* instance plugin memberof enable" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof enable -h No Pass" 
    dsconf localhost plugin memberof enable | grep -iE  "Enabled plugin 'MemberOf Plugin'" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof enable dn No Pass" 
    dsconf localhost plugin memberof status -h | grep  "usage: dsconf.* instance plugin memberof status" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof enable -h No Pass" 
    dsconf localhost plugin memberof status | grep -iE "Plugin 'MemberOf Plugin' is enabled" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof status dn No Pass" 
    dsconf localhost plugin memberof set -h | grep  "usage: dsconf.* instance plugin memberof set" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof set -h No Pass" 
    dsconf localhost plugin memberof set --attr "memberOf1" | grep -iE "Successfully changed the cn=MemberOf1 Plugin,cn=plugins,cn=config" 
    dsconf localhost plugin memberof set --attr "memberOf" | grep -iE "Successfully changed the cn=MemberOf Plugin,cn=plugins,cn=config" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof set --attr No Pass"
    dsconf localhost plugin memberof config-entry -h | grep  "usage: dsconf.* instance plugin memberof config-entry" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry -h No Pass"
    dsconf localhost plugin memberof config-entry add -h | grep  "usage: dsconf.* instance plugin memberof config-entry add" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry add -h No Pass"
    dsconf localhost plugin memberof config-entry add "dc=example,dc=com" --attr "memberOf" --groupattr "member" --allbackends "on" --skipnested "off" --scope "backend1"  --exclude "backend2"  --autoaddoc "inetUser"  | grep  "Successfully created the dc=example,dc=com" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry add -h No Pass"
    dsconf localhost plugin memberof config-entry set -h | grep  "usage: dsconf.* instance plugin memberof config-entry set" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry set -h No Pass"
    dsconf localhost plugin memberof config-entry set "dc=example,dc=com" --attr "memberOf1" --groupattr "member1" --allbackends "off" --skipnested "on" --scope "backend2"  --exclude "backend3"  --autoaddoc "inetUser"  | grep  "Successfully changed the dc=example,dc=com" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry add -h No Pass"
    dsconf localhost plugin memberof config-entry show -h | grep  "usage: dsconf.* instance plugin memberof config-entry show" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry show -h No Pass"
    dsconf localhost plugin memberof config-entry show cn=config | grep  "dn: cn=config" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry show  No Pass"
    dsconf localhost plugin memberof config-entry delete -h | grep  "usage: dsconf.* instance plugin memberof config-entry delete" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry delete -h No Pass"
    dsconf localhost plugin memberof fixup -h | grep  "usage: dsconf.* instance plugin memberof fixup" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof fixup -h No Pass"
    dsconf localhost plugin memberof config-entry delete dc=example,dc=com | grep -iE "Successfully deleted the dc=example,dc=com" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry delete dn  No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    echo "Yes I am sure" | dsconf localhost backend delete example
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf -rf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"