source ${OET_PATH}/libs/locallibs/common_lib.sh

# 需要预加载的数据、参数配置 (不需要)
function config_params() {
    LOG_INFO "Start to config params of the case."

    LOG_INFO "No params need to config."

    LOG_INFO "End to config params of the case."
}

# 测试对象、测试需要的工具等安装准备
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL gperf
    LOG_INFO "End of environmental preparation!"
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."


cat >test.gperf <<EOL
%{
    /* C code that goes verbatim in output */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}
    struct tl{ const char* name ; const char s2;};
%%
"--name",'n'
"--love",'l'
%%

int main(int argc,char **argv)
{
    const struct tl * str2;
    int i;
    char *test;

    for(i=1; i<argc; i++)
    {

        if((str2 = in_word_set(argv[i],strlen(argv[i]))) != 0)
        {
            switch (str2->s2)
            {
                case 'n':
                    test=argv[i+1];
                    printf("My name is %s.\n",test);
                    i++;
                    break;
                case 'l':
                    printf("successed !\n");
                    break;
            }
        }
    }

    return 0;
}
EOL


    gperf --ignore-case test.gperf > test.hpp
    CHECK_RESULT $? 0 0 "Check gperf --ignore-case failed."

    gperf -L 'C' test.gperf > test.hpp
    CHECK_RESULT $? 0 0 "Check gperf  -L  failed."

    gperf --language='C' test.gperf > test.hpp
    CHECK_RESULT $? 0 0 "Check gperf --lanaguage   failed."

    gperf -t -K "NAME" test.gperf > test.hpp
    CHECK_RESULT $? 0 0 "Check gperf  -t -K  failed."

    gperf -t --initializer-suffix=1 test.gperf > test.hpp
    CHECK_RESULT $? 0 0 "Check gperf -t --initializer-suffix   failed."

    gperf -H 'HASH' test.gperf > test.hpp
    CHECK_RESULT $? 0 0 "Check gperf  -H  failed."

    gperf --hash-function-name='HASH'  test.gperf  > test.hpp
    CHECK_RESULT $? 0 0 "Check gperf --hash-function-name   failed."

    gperf -N 'NAME' test.gperf  > test.hpp
    CHECK_RESULT $? 0 0 "Check gperf  -N  failed."

    gperf -Z 'NAME' test.gperf > test.hpp
    CHECK_RESULT $? 0 0 "Check gperf  -Z  failed."

    gperf --class-name='NAME' test.gperf > test.hpp
    CHECK_RESULT $? 0 0 "Check gperf --class-name   failed."

    LOG_INFO "End of the test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."

    DNF_REMOVE gperf

    LOG_INFO "Finish restoring the test environment."
}

main $@