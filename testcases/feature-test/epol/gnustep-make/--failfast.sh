
#!/usr/bin/bash
# 测试用例描述：测试 gnustep-tests 命令的 --failfast 参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gnustep-make"
    # 设置环境变量
    export GNUSTEP_MAKEFILES="/usr/lib64/GNUstep/Makefiles"
    # 创建测试目录和文件
    mkdir -p ./test_dir
    touch ./test_dir/TestInfo
    touch ./test_dir/test.m
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 gnustep-tests --failfast 参数
    gnustep-tests --failfast ./test_dir
    CHECK_RESULT $? 0 0 "gnustep-tests --failfast failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "gnustep-make"
    # 清理测试中间产物文件
    rm -rf ./test_dir
    unset GNUSTEP_MAKEFILES
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
