source ${OET_PATH}/libs/locallibs/common_lib.sh
# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/22
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of mpich command
# ############################################

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL gperf
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
#
#cat >test.gperf <<EOL
#%{
#    /* C code that goes verbatim in output */
##include <stdio.h>
##include <stdlib.h>
##include <string.h>
#%}
#    struct tl{ const char* name ; const char s2;};
#%%
#"--name",'n'
#"--love",'l'
#%%
#
#int main(int argc,char **argv)
#{
#    const struct tl * str2;
#    int i;
#    char *test;
#
#    for(i=1; i<argc; i++)
#    {
#
#        if((str2 = in_word_set(argv[i],strlen(argv[i]))) != 0)
#        {
#            switch (str2->s2)
#            {
#                case 'n':
#                    test=argv[i+1];
#                    printf("My name is %s.\n",test);
#                    i++;
#                    break;
#                case 'l':
#                    printf("successed !\n");
#                    break;
#            }
#        }
#    }
#
#    return 0;
#}
#EOL
    mkdir tmp

    gperf --help 2>&1 | grep "GNU 'gperf' generates"
    CHECK_RESULT $? 0 0 "Check '--help  failed"

    gperf -h 2>&1 | grep "GNU 'gperf' generates"
    CHECK_RESULT $? 0 0 "Check gperf -h failed."

    gperf  --version 2>&1 | grep "GNU gperf "
    CHECK_RESULT $? 0 0 "Check gperf --version failed."

    gperf  -v 2>&1 | grep "GNU gperf "
    CHECK_RESULT $? 0 0 "Check gperf -v failed."

    gperf  -d -e 2>&1 | grep "Starting program gperf"
    CHECK_RESULT $? 0 0 "Check gperf -d failed."

    gperf --debug -e 2>&1 | grep "Starting program gperf"
    CHECK_RESULT $? 0 0 "Check gperf -d failed."

    gperf -d -e ',' ../common/test.gperf > ./tmp/test.hpp
    CHECK_RESULT $? 0 0 "Check gperf -e failed."

    gperf --delimiters=',' ../common/test.gperf   > ./tmp/test.hpp
    CHECK_RESULT $? 0 0 "Check gperf --delimiters failed."

    gperf -t ../common/test.gperf  > ./tmp/test.hpp
    CHECK_RESULT $? 0 0 "Check gperf -t failed."

    gperf --struct-type ../common/test.gperf  > ./tmp/test.h
    CHECK_RESULT $? 0 0 "Check gperf --struct-type failed."

    rm -rf tmp
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE gperf

    LOG_INFO "Finish restoring the test environment."
}

main $@