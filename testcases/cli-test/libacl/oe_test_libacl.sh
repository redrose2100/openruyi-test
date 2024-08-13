#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2024.8.2
# @License   :   Mulan PSL v2
# @Desc      :   libacl formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."    
    cat > /tmp/libacl_test.c << EOF
#include <stdio.h>
#include <stdlib.h>
#include <acl/libacl.h>

int main() {
    acl_t acl;
    acl_entry_t entry;
    acl_permset_t permset;
    char *acl_text;

    // 创建一个空的ACL对象
    acl = acl_init(1);
    if (acl == NULL) {
        perror("acl_init");
        exit(EXIT_FAILURE);
    }

    // 添加一个ACL条目
    if (acl_create_entry(&acl, &entry) == -1) {
        perror("acl_create_entry");
        exit(EXIT_FAILURE);
    }

    // 设置ACL条目的权限
    if (acl_get_permset(entry, &permset) == -1) {
        perror("acl_get_permset");
        exit(EXIT_FAILURE);
    }
    if (acl_add_perm(permset, ACL_READ) == -1) {
        perror("acl_add_perm");
        exit(EXIT_FAILURE);
    }

    // 将ACL对象转换为文本表示
    acl_text = acl_to_text(acl, NULL);
    if (acl_text == NULL) {
        perror("acl_to_text");
        exit(EXIT_FAILURE);
    }

    // 打印ACL文本
    printf("ACL: %s\n", acl_text ? acl_text : "");

    return 0;
}

EOF

    DNF_INSTALL "libacl libacl-devel"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep libacl
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp && gcc -o libacl_test libacl_test.c -lacl
    test -f /tmp/libacl_test
    CHECK_RESULT $? 0 0 "libacl test fail"
    cd /tmp && ./libacl_test > test_file
    grep ACL /tmp/test_file   
    CHECK_RESULT $? 0 0 "execute libacl_test fail"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/libacl_test /tmp/test_file
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
