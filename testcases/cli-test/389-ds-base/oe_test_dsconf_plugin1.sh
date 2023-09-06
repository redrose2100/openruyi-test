#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Desc      :   Test dirsrv-snmp.service restart
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "389-ds-base"
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    dsconf localhost backend create --suffix dc=example,dc=com --be-name example
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_dsconf_backend."
    ### plugin -h
    dsconf localhost plugin -h | grep  "usage: dsconf instance plugin" 
    CHECK_RESULT $? 0 0 "Check: plugin -h No Pass" 
    ### plugin memberof -h
    dsconf localhost plugin memberof -h | grep  "usage: dsconf instance plugin memberof" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof -h No Pass" 
    ### plugin memberof show -h
    dsconf localhost plugin memberof show -h | grep  "usage: dsconf instance plugin memberof show" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof show -h No Pass" 
    ### plugin memberof show
    dsconf localhost plugin memberof show | grep  "dn: cn=MemberOf Plugin,cn=plugins,cn=config" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof show No Pass" 
    ### plugin memberof disable -h
    dsconf localhost plugin memberof disable -h | grep  "usage: dsconf instance plugin memberof disable" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof disable -h No Pass" 
    ### plugin memberof disable dn
    dsconf localhost plugin memberof enable
    dsconf localhost plugin memberof disable | grep  "Disabled plugin 'MemberOf Plugin'" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof disable dn No Pass" 
    ### plugin memberof enable -h
    dsconf localhost plugin memberof enable -h | grep  "usage: dsconf instance plugin memberof enable" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof enable -h No Pass" 
    ### plugin memberof enable dn
    dsconf localhost plugin memberof enable | grep  "Enabled plugin 'MemberOf Plugin'" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof enable dn No Pass" 
    ### plugin memberof status -h
    dsconf localhost plugin memberof status -h | grep  "usage: dsconf instance plugin memberof status" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof enable -h No Pass" 
    ### plugin memberof status dn
    dsconf localhost plugin memberof status | grep  "Plugin 'MemberOf Plugin' is enabled" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof status dn No Pass" 
    ### plugin memberof set -h
    dsconf localhost plugin memberof set -h | grep  "usage: dsconf instance plugin memberof set" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof set -h No Pass" 
     ### plugin memberof set --attr
    dsconf localhost plugin memberof set --attr "memberOf1"
    dsconf localhost plugin memberof set --attr "memberOf" | grep  "Successfully changed the cn=MemberOf Plugin,cn=plugins,cn=config" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof set --attr No Pass"
    ### plugin memberof config-entry -h
    dsconf localhost plugin memberof config-entry -h | grep  "usage: dsconf instance plugin memberof config-entry" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry -h No Pass"
    ### plugin memberof config-entry add -h
    dsconf localhost plugin memberof config-entry add -h | grep  "usage: dsconf instance plugin memberof config-entry add" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry add -h No Pass"
    ### plugin memberof config-entry add --attr --allbackends --skipnested  --scope --exclude --autoaddoc
    dsconf localhost plugin memberof config-entry add "dc=example,dc=com" --attr "memberOf" --groupattr "member" --allbackends "on" --skipnested "off" --scope "backend1"  --exclude "backend2"  --autoaddoc "inetUser"  | grep  "Successfully created the dc=example,dc=com" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry add -h No Pass"
    ### plugin memberof config-entry set -h
    dsconf localhost plugin memberof config-entry set -h | grep  "usage: dsconf instance plugin memberof config-entry set" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry set -h No Pass"
    ### plugin memberof config-entry set --attr --allbackends --skipnested  --scope --exclude --autoaddoc
    dsconf localhost plugin memberof config-entry set "dc=example,dc=com" --attr "memberOf1" --groupattr "member1" --allbackends "off" --skipnested "on" --scope "backend2"  --exclude "backend3"  --autoaddoc "inetUser"  | grep  "Successfully changed the dc=example,dc=com" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry add -h No Pass"
    ### plugin memberof config-entry show -h
    dsconf localhost plugin memberof config-entry show -h | grep  "usage: dsconf instance plugin memberof config-entry show" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry show -h No Pass"
    ### plugin memberof config-entry show dn
    dsconf localhost plugin memberof config-entry show cn=config | grep  "dn: cn=config" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry show  No Pass"
    ### plugin memberof config-entry delete -h
    dsconf localhost plugin memberof config-entry delete -h | grep  "usage: dsconf instance plugin memberof config-entry delete" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry delete -h No Pass"
    
    ### plugin memberof fixup -h
    dsconf localhost plugin memberof fixup -h | grep  "usage: dsconf instance plugin memberof fixup" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof fixup -h No Pass"
    ### plugin memberof fixup -f 
    #dsconf localhost plugin memberof fixup  -f "objectClass=top" "dc=example,dc=com" | grep  "Attempting to add task entry..." 
    #CHECK_RESULT $? 0 0 "Check: plugin memberof delete -h No Pass"

    ### plugin memberof config-entry delete dn
    dsconf localhost plugin memberof config-entry delete dc=example,dc=com | grep  "Successfully deleted the dc=example,dc=com" 
    CHECK_RESULT $? 0 0 "Check: plugin memberof config-entry delete dn  No Pass"
    LOG_INFO "End to run testcase:oe_test_dsconf_backend."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    echo "Yes I am sure" | dsconf localhost backend delete example
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf
    LOG_INFO "End to restore the test environment."
}

main "$@"
