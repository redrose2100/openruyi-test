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
    DNF_INSTALL "389-ds-base"
    echo "/usr/lib64/dirsrv" | tee /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    dscreate create-template 389_ds_test.inf
    dscreate from-file 389_ds_test.inf
    dsconf localhost backend create --suffix dc=example,dc=com --be-name example
    dsconf localhost backend create --suffix cn=Posix,ou=templates,dc=example,dc=com --be-name Posix
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dsconf localhost plugin referential-integrity set --update-delay 3600 --membership-attr memberOf --entry-scope "ou=people,dc=example,dc=com" --exclude-entry-scope "ou=ignore,dc=example,dc=com" --container-scope "ou=groups,dc=example,dc=com" --log-file /var/log/dirsrv/slapd-localhost/referint --config-entry cn=config | grep "Successfully changed the cn=referential integrity postoperation,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin referential-integrity set all No Pass"
    dsconf localhost plugin root-dn show | grep "dn: cn=RootDN Access Control,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin root-dn show No Pass"
    dsconf localhost plugin root-dn enable | grep "Enabled plugin 'RootDN Access Control'"
    CHECK_RESULT $? 0 0 "Check: plugin root-dn enable No Pass"
    dsconf localhost plugin root-dn disable | grep "Disabled plugin 'RootDN Access Control'"
    CHECK_RESULT $? 0 0 "Check: plugin root-dn disable No Pass"
    dsconf localhost plugin root-dn status | grep "Plugin 'RootDN Access Control' is disabled"
    CHECK_RESULT $? 0 0 "Check: plugin root-dn status No Pass"
    dsconf localhost plugin root-dn set --allow-host example.com --deny-host denied.example.com --allow-ip 192.168.0.1 --deny-ip 10.0.0.1 --open-time 0800 --close-time 1800 --days-allowed mon,tue,wed,thu,fri | grep "Successfully changed the cn=RootDN Access Control,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin root-dn set all No Pass"
    dsconf localhost plugin usn show | grep "dn: cn=USN,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin usn show No Pass"
    dsconf localhost plugin usn enable | grep "Enabled plugin 'USN'"
    CHECK_RESULT $? 0 0 "Check: plugin usn enable No Pass"
    dsconf localhost plugin usn disable | grep "Disabled plugin 'USN'"
    CHECK_RESULT $? 0 0 "Check: plugin usn disable No Pass"
    dsconf localhost plugin usn status | grep "Plugin 'USN' is disabled"
    CHECK_RESULT $? 0 0 "Check: plugin usn status No Pass"
    dsconf localhost plugin usn global on | grep "USN global mode enabled"
    CHECK_RESULT $? 0 0 "Check: plugin usn global on No Pass"
    dsconf localhost plugin usn global off | grep "USN global mode disabled"
    CHECK_RESULT $? 0 0 "Check: plugin usn global off No Pass"
    dsconf localhost plugin usn enable
    dsconf localhost plugin usn cleanup -s "dc=example,dc=com" -m 1000 | grep "Attempting to add task entry..."
    CHECK_RESULT $? 0 0 "Check: plugin usn cleanup --suffix --backend --max-usn  No Pass"
    dsconf localhost plugin account-policy config-entry add --always-record-login yes --alt-state-attr alt_state_attribute_name --always-record-login-attr always_record_login_attribute_name --limit-attr limit_attribute_name --spec-attr spec_attribute_name --state-attr state_attribute_name dc=example,dc=com | grep "Successfully created the dc=example,dc=com"
    CHECK_RESULT $? 0 0 "Check: plugin account-policy config-entry add all  No Pass"
    dsconf localhost plugin account-policy config-entry set --always-record-login no --alt-state-attr alt_state_attribute_name --always-record-login-attr always_record_login_attribute_name --limit-attr limit_attribute_name --spec-attr spec_attribute_name --state-attr state_attribute_name dc=example,dc=com | grep "Successfully changed the dc=example,dc=com"
    CHECK_RESULT $? 0 0 "Check: plugin account-policy config-entry set all  No Pass"
    dsconf localhost plugin account-policy show  | grep "dn: cn=Account Policy Plugin,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin account-policy show No Pass"
    dsconf localhost plugin account-policy enable | grep "Enabled plugin 'Account Policy Plugin'"
    CHECK_RESULT $? 0 0 "Check: plugin account-policy enable No Pass"
    dsconf localhost plugin account-policy disable | grep "Disabled plugin 'Account Policy Plugin'"
    CHECK_RESULT $? 0 0 "Check: plugin account-policy disable No Pass"
    dsconf localhost plugin account-policy status | grep "Plugin 'Account Policy Plugin' is disabled"
    CHECK_RESULT $? 0 0 "Check: plugin account-policy status No Pass"
    dsconf localhost plugin account-policy config-entry show dc=example,dc=com | grep "dn: dc=example,dc=com"
    CHECK_RESULT $? 0 0 "Check: plugin account-policy config-entry show No Pass"
    dsconf localhost plugin account-policy config-entry delete dc=example,dc=com | grep "Successfully deleted the dc=example,dc=com"
    CHECK_RESULT $? 0 0 "Check: plugin account-policy config-entry delete No Pass"
    dsconf localhost plugin attr-uniq add --enabled on --attr-name attributeName1 attributeName2 --subtree dn1 dn2 --across-all-subtrees on --top-entry-oc topEntryOC --subtree-entries-oc subtreeEntriesOC YourPluginConfigName | grep "Successfully created the cn=YourPluginConfigName,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin attr-uniq add all  No Pass"
    dsconf localhost plugin attr-uniq set --enabled off --attr-name attributeName1 attributeName2 --subtree dn1 dn2 --across-all-subtrees on --top-entry-oc topEntryOC --subtree-entries-oc subtreeEntriesOC YourPluginConfigName | grep "Successfully changed the cn=YourPluginConfigName,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin attr-uniq set all  No Pass"
    dsconf localhost plugin attr-uniq show YourPluginConfigName | grep "dn: cn=YourPluginConfigName,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin attr-uniq show No Pass"
    dsconf localhost plugin attr-uniq enable YourPluginConfigName| grep "Successfully enabled the cn=YourPluginConfigName,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin attr-uniq enable No Pass"
    dsconf localhost plugin attr-uniq disable YourPluginConfigName | grep "Successfully disabled the cn=YourPluginConfigName,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin attr-uniq disable No Pass"
    dsconf localhost plugin attr-uniq status YourPluginConfigName | grep "Plugin 'YourPluginConfigName' is disabled"
    CHECK_RESULT $? 0 0 "Check: plugin attr-uniq status No Pass"
    dsconf localhost plugin attr-uniq delete YourPluginConfigName | grep "Successfully deleted the cn=YourPluginConfigName,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin attr-uniq delete No Pass"
    dsconf localhost plugin dna show  | grep "dn: cn=Distributed Numeric Assignment Plugin,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin dna show No Pass"
    dsconf localhost plugin dna enable | grep "Enabled plugin 'Distributed Numeric Assignment Plugin'"
    CHECK_RESULT $? 0 0 "Check: plugin dna enable No Pass"
    dsconf localhost plugin dna disable  | grep "Disabled plugin 'Distributed Numeric Assignment Plugin'"
    CHECK_RESULT $? 0 0 "Check: plugin dna disable No Pass"
    dsconf localhost plugin dna status  | grep "Plugin 'Distributed Numeric Assignment Plugin' is disabled"
    CHECK_RESULT $? 0 0 "Check: plugin dna status No Pass"
    dsconf localhost plugin dna config my_config add --type attribute1 attribute2 --prefix my_prefix --next-value 100 --max-value 1000 --interval 10 --magic-regen 0 --filter "(objectClass=user)" --scope "ou=people,dc=example,dc=com" --remote-bind-dn "cn=ReplicationManager,dc=example,dc=com" --remote-bind-cred "password" --shared-config-entry "cn=SharedConfig,dc=example,dc=com" --threshold 50 --next-range 1001 --range-request-timeout 60  | grep "Successfully created the cn=my_config,cn=Distributed Numeric Assignment Plugin,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin dna config NAME add No Pass"
    dsconf localhost plugin dna config my_config set --type attribute1 attribute2 --prefix my_prefix --next-value 100 --max-value 10000 --interval 10 --magic-regen 0 --filter "(objectClass=user)" --scope "ou=people,dc=example,dc=com" --remote-bind-dn "cn=ReplicationManager,dc=example,dc=com" --remote-bind-cred "password" --shared-config-entry "cn=SharedConfig,dc=example,dc=com" --threshold 50 --next-range 1001 --range-request-timeout 60  | grep "Successfully changed the cn=my_config,cn=Distributed Numeric Assignment Plugin,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin dna config NAME set No Pass"  
    dsconf localhost plugin dna config my_config show  | grep "dn: cn=my_config,cn=Distributed Numeric Assignment Plugin,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin dna config NAME show No Pass"
    dsconf localhost plugin dna list configs  | grep "my_config"
    CHECK_RESULT $? 0 0 "Check: plugin dna list configs No Pass"
    dsconf localhost plugin dna config my_config delete  | grep "Successfully deleted the cn=my_config,cn=Distributed Numeric Assignment Plugin,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin dna config NAME delete No Pass"
    dsconf localhost plugin linked-attr show  | grep "dn: cn=Linked Attributes,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin linked-attr show No Pass"
    dsconf localhost plugin linked-attr enable | grep "Plugin 'Linked Attributes' already enabled"
    CHECK_RESULT $? 0 0 "Check: plugin linked-attr enable No Pass"
    dsconf localhost plugin linked-attr disable  | grep "Disabled plugin 'Linked Attributes'"
    CHECK_RESULT $? 0 0 "Check: plugin linked-attr disable No Pass"
    dsconf localhost plugin linked-attr status  | grep "Plugin 'Linked Attributes' is disabled"
    CHECK_RESULT $? 0 0 "Check: plugin linked-attr status No Pass"
    dsconf localhost plugin linked-attr status  | grep "Plugin 'Linked Attributes' is disabled"
    CHECK_RESULT $? 0 0 "Check: plugin linked-attr status No Pass"
    dsconf localhost plugin linked-attr fixup -l example | grep "Successfully added task entry"
    CHECK_RESULT $? 0 0 "Check: plugin linked-attr fixup -l No Pass"
    dsconf localhost plugin linked-attr config my_plugin add --link-type myLinkType --managed-type myManagedType --link-scope myLinkScope | grep "Successfully created the cn=my_plugin,cn=Linked Attributes,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin linked-attr config NAME add all No Pass"
    dsconf localhost plugin linked-attr config my_plugin set --link-type myLinkType1 --managed-type myManagedType --link-scope myLinkScope1 | grep "Successfully changed the cn=my_plugin,cn=Linked Attributes,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin linked-attr config NAME set all No Pass"
    dsconf localhost plugin linked-attr config my_plugin show | grep "dn: cn=my_plugin,cn=Linked Attributes,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin linked-attr config NAME show No Pass"
    dsconf localhost plugin linked-attr config my_plugin delete | grep "Successfully deleted the cn=my_plugin,cn=Linked Attributes,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin linked-attr config NAME delete No Pass"
    dsconf localhost plugin managed-entries show  | grep "dn: cn=Managed Entries,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries show No Pass"
    dsconf localhost plugin managed-entries enable | grep "Plugin 'Managed Entries' already enabled"
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries enable No Pass"
    dsconf localhost plugin managed-entries disable  | grep "Disabled plugin 'Managed Entries'"
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries disable No Pass"
    dsconf localhost plugin managed-entries status  | grep "Plugin 'Managed Entries' is disabled"
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries status No Pass"
    dsconf localhost plugin managed-entries set --config-area cn=plugins,cn=config  | grep "Successfully changed the cn=Managed Entries,cn=plugins,cn=config"
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries set --config-area No Pass"
    dsconf localhost backend create --suffix ou=People,dc=example,dc=com --be-name People
    dsconf localhost backend create --suffix ou=Managed,dc=example,dc=com --be-name Managed
    dsconf localhost backend create --suffix cn=Template,ou=Templates,dc=example,dc=com --be-name Template
    dsconf localhost plugin managed-entries disable
    dsctl localhost restart
    dsconf localhost plugin managed-entries config myplugin add --scope "ou=People,dc=example,dc=com" --filter "(objectClass=inetOrgPerson)" --managed-base "ou=Managed,dc=example,dc=com" --managed-template "cn=Template,ou=Templates,dc=example,dc=com"  
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries config NAME add all No Pass"
    dsconf localhost plugin managed-entries list configs | grep "myplugin"
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries list configs all No Pass"
    dsconf localhost plugin managed-entries config myplugin set --scope "ou=people,dc=example,dc=com" --filter "(objectClass=person)" --managed-base "ou=managed,dc=example,dc=com" --managed-template "cn=template,ou=templates,dc=example,dc=com" 
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries config NAME set No Pass"
    dsconf localhost plugin managed-entries config myplugin show
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries config NAME show No Pass"
    dsconf localhost plugin managed-entries config myplugin delete
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries config NAME delete No Pass"
    dsconf  localhost plugin managed-entries template "cn=Posix,ou=templates,dc=example,dc=com" add --rdn-attr "cn" --static-attr "objectclass: posixGroup" --mapped-attr "cn:  Group Entry" "gidNumber: " "memberUid: " | grep "Successfully created the cn=Posix,ou=templates,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries template DN add No Pass"
    dsconf localhost plugin managed-entries list templates "cn=Posix,ou=templates,dc=example,dc=com" | grep "Posix"
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries list templates all No Pass"
    dsconf  localhost plugin managed-entries template "cn=Posix,ou=templates,dc=example,dc=com" set --rdn-attr "cn" --static-attr "objectclass: posixGroup1" --mapped-attr "cn:  Group Entry" "gidNumber: " "memberUid: " | grep "Successfully changed the cn=Posix,ou=templates,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries template DN set No Pass"
    dsconf localhost plugin managed-entries template "cn=Posix,ou=templates,dc=example,dc=com" show | grep "dn: cn=Posix,ou=templates,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries template show No Pass"
    dsconf localhost plugin managed-entries template "cn=Posix,ou=templates,dc=example,dc=com" delete | grep "Successfully deleted the cn=Posix,ou=templates,dc=example,dc=com"
    CHECK_RESULT $? 0 0 "Check: plugin managed-entries template delete  No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    echo "Yes I am sure" | dsconf localhost backend delete People
    echo "Yes I am sure" | dsconf localhost backend delete Managed
    echo "Yes I am sure" | dsconf localhost backend delete Template
    echo "Yes I am sure" | dsconf localhost backend delete Posix
    echo "Yes I am sure" | dsconf localhost backend delete example
    dsctl localhost remove --do-it
    rm -rf 389_ds_test.inf /etc/ld.so.conf.d/custom-libraries.conf
    ldconfig
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"