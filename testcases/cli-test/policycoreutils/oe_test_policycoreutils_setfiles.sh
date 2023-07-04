#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   wangsongsong 
# @Contact   :   ss_wang@foxmail.com
# @Date      :   2022/02/25
# @License   :   Mulan PSL v2
# @Desc      :   Test restorecond
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function run_test() {
    LOG_INFO "Start to run test."
    #show what specification matched each file
    setfiles -d /etc/selinux/targeted/contexts/files/file_contexts /srv/ |grep "matched"
    CHECK_RESULT $? 0 0 "failed to show what specification matched each file"
    #Force reset of context to match file_context for customizable files
    setfiles -F /etc/selinux/targeted/contexts/files/file_contexts /srv/
    CHECK_RESULT $? 0 0 "failed to force reset of context to match file_context for customizable files"
    #ignore files that do not exist
    setfiles -i /etc/selinux/targeted/contexts/files/file_contexts /tmp/77
    CHECK_RESULT $? 0 0 "failed to ignore file 77 that do not exist"
    #ignore digest to force checking of labels even if the stored SHA1 digest matches the specfiles SHA1 digest
    setfiles -I /etc/selinux/targeted/contexts/files/file_contexts /srv/    CHECK_RESULT $? 0 0 "failed to ignore digest"
    #Set or update /srv' SHA1 digests
    setfiles -I /etc/selinux/targeted/contexts/files/file_contexts /srv/
    CHECK_RESULT $? 0 0 "failed to set or update /srv; SHA1 digests"
    #log changes in file labels to syslog
    setfiles -l /etc/selinux/targeted/contexts/files/file_contexts /srv/
    CHECK_RESULT $? 0 0 "failed to show log changes"
    #don't change any file labels
    setfiles -l /etc/selinux/targeted/contexts/files/file_contexts /srv/
    CHECK_RESULT $? 0 0 "change /srv labels"
    #show progress by printing the number of files in 1k blocks
    setfiles -p /etc/selinux/targeted/contexts/files/file_contexts /srv
    CHECK_RESULT $? 0 0 "failed to show progress"
    #show changes in file labels and output any inode
    setfiles -v /etc/selinux/targeted/contexts/files/file_contexts /srv/
    CHECK_RESULT $? 0 0 "failed to show changes in file labels and output any inode"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    LOG_INFO "Nothing to do."
    LOG_INFO "End to restore the test environment."
}

main "$@"
