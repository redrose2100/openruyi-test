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
# @Date      :   2023/04/10
# @License   :   Mulan PSL v2
# @Desc      :   Test Directory write permission
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    useradd test1
    chmod 755 /home/test1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    su - test1 -c "mkdir /home/test1/test115216"
    CHECK_RESULT $? 0 0 "Failed to mkdir test file"
    su - test1 -c "chmod 000 /home/test1/test115216"
    cd /home/test1
    ls -l | grep 'd---------'
    CHECK_RESULT $? 0 0 "Failed to change permission"
    su - test1 -c "cd /home/test1/test115216" | grep "权限不够"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the tet environment."
    userdel -r test1
    LOG_INFO "Finish to restore the tet environment."
}

main "$@"
