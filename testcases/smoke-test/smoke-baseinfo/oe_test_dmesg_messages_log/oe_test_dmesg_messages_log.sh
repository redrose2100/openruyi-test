#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/04/19
# @License   :   Mulan PSL v2
# @Desc      :   Test dmesg and messages
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run test."
    # 捕捉所有内核级致命错误
    CRITICAL_KERNEL_PATTERNS="Kernel panic|Oops:|kernel BUG at|general protection fault|unable to handle kernel paging request|soft lockup|hard lockup|Out of memory|Killed process|I/O error"
    dmesg | grep -iE "$CRITICAL_KERNEL_PATTERNS" \
	    | grep -vE "Kernel command line|Command line:"
    CHECK_RESULT $? 1 0 "Dmesg has false information."
    # 只关注 文件系统损坏、硬件故障、底层I/O错误。 
    MSG_PATTERNS="\
	    XFS.*fatal|\
	    XFS.*Internal error|\
	    EXT4-fs.*error|\
	    EXT4-fs.*abort|\
	    Buffer I/O error|\
	    blk_update_request:\s+I/O error|\
	    sector.*read failed|\
	    sector.*write failed|\
	    Machine check|\
	    kernel panic|\
	    kernel BUG at|\
	    Hardware Error|\
	    EDAC.*error|\
	    Rasdaemon.*error"
    grep -iE "$MSG_PATTERNS" /var/log/messages
    CHECK_RESULT $? 1 0 "file /var/log/messages has false information."
}

main "$@"
