
#!/usr/bin/bash
# 测试用例描述：测试 gnustep-tests --clean 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gnustep-make"
    # 设置环境变量
    export GNUSTEP_MAKEFILES="/usr/lib64/GNUstep/Makefiles"
    # 创建测试目录
    mkdir -p ./test_dir
    touch ./test_dir/TestInfo
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 运行待测命令
    gnustep-tests --clean
    CHECK_RESULT $? 0 0 "gnustep-tests --clean failed"
    # 检查测试目录是否被清理
    if [ ! -f ./test_dir/TestInfo ]; then
        LOG_INFO "TestInfo file removed successfully."
    else
        LOG_INFO "TestInfo file not removed."
        CHECK_RESULT 1 0 0 "TestInfo file not removed after --clean"
    fi
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
