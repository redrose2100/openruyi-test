# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhangmei
# @Contact   :   zhangmei@uniontech.com
# @Date      :   2023/04/07
# @License   :   Mulan PSL v2
# @Desc      :   Test kernel swappiness set
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# 直接读写 /proc/sys/vm/swappiness，避免依赖 procps-ng 提供的 sysctl。
SYSCTL_PROC=/proc/sys/vm/swappiness

function run_test() {
    LOG_INFO "Start testing..."
    test -f ${SYSCTL_PROC}
    CHECK_RESULT $? 0 0 "Failed to view swappiness information"
    val=$(cat ${SYSCTL_PROC})
    test -n "${val}"
    CHECK_RESULT $? 0 0 "Failed to view swappiness information"
    echo 60 >${SYSCTL_PROC}
    CHECK_RESULT $? 0 0 "Failed to vim swappiness"
    res1=$(cat ${SYSCTL_PROC})
    CHECK_RESULT "${res1}" 60 0 "Failed to view swappiness information"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the tet environment."
    test -n "${val}" && echo "${val}" >${SYSCTL_PROC}
    LOG_INFO "Finish to restore the tet environment."
}

main "$@"

