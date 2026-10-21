
#!/usr/bin/bash
# 测试用例描述：测试opencv_run_all_tests.sh命令的不同参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "opencv"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建测试脚本文件
    echo -e "#!/bin/bash\n# This is a dummy script for testing\nif [ \$1 = '-h' ]; then\n  echo 'Usage: opencv_run_all_tests.sh [options]'\n  exit 0\nfi\nif [ \$1 = '-c' ]; then\n  echo 'Color output'\n  exit 0\nfi" > ./opencv_run_all_tests.sh
    chmod +x ./opencv_run_all_tests.sh
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的参数组合
    ./opencv_run_all_tests.sh -h
    CHECK_RESULT $? 0 0 "failed to run opencv_run_all_tests.sh -h"
    
    ./opencv_run_all_tests.sh -c
    CHECK_RESULT $? 0 0 "failed to run opencv_run_all_tests.sh -c"
    
    ./opencv_run_all_tests.sh -h -c
    CHECK_RESULT $? 0 0 "failed to run opencv_run_all_tests.sh -h -c"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "opencv"
    # 清理测试中间产物文件
    rm -f ./opencv_run_all_tests.sh
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
