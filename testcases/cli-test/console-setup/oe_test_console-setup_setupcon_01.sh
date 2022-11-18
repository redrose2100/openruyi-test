# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
# @Author    	:   chen zhenghao
# @Contact   	:   zhenghao@isrc.iscas.ac.cn
# @Date      	:   2022-11-9
# @License   	:   Mulan PSL v2
# @Desc      	:   the test of byacc package
####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL byacc
    test -d tmp || mkdir tmp
    LOG_INFO "End of environmental preparation!"
}
function run_test() {

    LOG_INFO "Start testing..."
    setupcon -v 2>&1 | grep "The charmap is UTF-8 "
    setupcon --verbose 2>&1 | grep "The charmap is UTF-8"
    CHECK_RESULT $? 0 0 "Failed option:  -v, --verbose "
    setupcon -k 2>&1 | grep "keyboard configuration success"
    setupcon --keyboard-only 2>&1 | grep "keyboard configuration success"
    CHECK_RESULT $? 0 0 "Failed option:  -k, --keyboard-only"
      #在/etc/default/keyboard文件末尾写入一行echo "keyboard configuration success"来测试该指令成功读取了默认文件。
    setupcon -f 2>&1 | grep "font configuration success"
    setupcon --font-only 2>&1 | grep "font configuration success"
    CHECK_RESULT $? 0 0 "Failed option:  -f, --font-only "
      #在/etc/default/console-setup文件末尾写入一行echo "font configuration success"来测试该指令成功读取了默认文件。
   setupcon -t 2>&1 | grep "success"
   setupcon --terminal-only 2>&1 | grep "success"
   CHECK_RESULT $? 0 0 "Failed option:  -t,--terminal-only"
   setupcon --current-tty 2>&1 | grep "success"
   CHECK_RESULT $? 0 0 "Failed option:  --current-tty"
   setupcon --force 2>&1 | grep "success"
   CHECK_RESULT $? 0 0 "Failed option:  --force"
   
}


function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./tmp
    LOG_INFO "Finish environment cleanup!"
}

main "$@"