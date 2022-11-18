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

   setupcon --print-commands-only 2>&1 | grep "setfont '-C' '/dev/tty1' '/usr/share/consolefonts/Uni2-TerminusBold16.psf.gz' "
   CHECK_RESULT $? 0 0 "Failed option:  --print-commands-only"
   setupcon --save-keyboard 2>&1 | grep "success"
   CHECK_RESULT $? 0 0 "Failed option:  --save-keyboard"
   setupcon --setup-dir 2>&1 | grep "success"
   CHECK_RESULT $? 0 0 "Failed option:  --setup-dir"
   setupcon -h 2>&1 | grep "Sets up the font and the keyboard on Linux console."
   setupcon --help 2>&1 | grep "Sets up the font and the keyboard on Linux console."
   CHECK_RESULT $? 0 0 "Failed option:  -h,--help"
}


function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf ./tmp
    LOG_INFO "Finish environment cleanup!"
}

main "$@"