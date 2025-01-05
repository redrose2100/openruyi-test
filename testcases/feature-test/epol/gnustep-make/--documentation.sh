
#!/usr/bin/bash
# 请填写测试用例描述：测试gnustep-tests --documentation命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gnustep-make"
    # 设置环境变量
    export GNUSTEP_MAKEFILES="/usr/lib64/GNUstep/Makefiles"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试gnustep-tests --documentation命令
    gnustep-tests --documentation
    CHECK_RESULT $? 0 0 "gnustep-tests --documentation failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "gnustep-make"
    # 清理测试中间产物文件
    unset GNUSTEP_MAKEFILES
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
