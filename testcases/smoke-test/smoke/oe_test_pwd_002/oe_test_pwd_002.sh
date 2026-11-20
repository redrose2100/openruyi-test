#!/usr/bin/bash

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huzheyuan
# @Contact   :   huzheyuan@uniontech.com
# @Date      :   2022.12.06
# @License   :   Mulan PSL v2
# @Desc      :   File system common command builtin
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    # The point of this case is that `pwd -L` prints the logical (symlinked)
    # path while `pwd -P` resolves it. Depending on /etc/init.d and
    # /etc/rc.d/init.d (a SysV layout that openRuyi does not ship) made the
    # case fail with "No such file or directory" instead of testing pwd.
    # Build our own symlinked directory so the semantics are always testable.
    PWD_TEST_DIR=$(mktemp -d)
    mkdir -p "${PWD_TEST_DIR}/real_dir"
    ln -s real_dir "${PWD_TEST_DIR}/link_dir"
    cd "${PWD_TEST_DIR}/link_dir" || {
        CHECK_RESULT 1 0 0 "Failed to enter ${PWD_TEST_DIR}/link_dir"
        return 1
    }
    pwd -L | grep "${PWD_TEST_DIR}/link_dir"
    CHECK_RESULT $? 0 0 "pwd -L did not print the logical path"
    pwd -P | grep "${PWD_TEST_DIR}/real_dir"
    CHECK_RESULT $? 0 0 "pwd -P did not resolve the symlink"
    cd / || true
    rm -rf "${PWD_TEST_DIR}"
    LOG_INFO "Finish test!"
}

main $@




