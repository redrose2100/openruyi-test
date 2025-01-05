
#!/usr/bin/bash
# 测试 botan has_command 命令，验证其是否能正确检测命令是否存在

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令存在的情况
    botan has_command config
    CHECK_RESULT $? 0 0 "botan has_command config failed"

    # 测试命令不存在的情况
    botan has_command non_existent_command
    CHECK_RESULT $? 1 0 "botan has_command non_existent_command should fail"
    
    # 测试命令参数顺序
    botan has_command
    CHECK_RESULT $? 2 0 "botan has_command without argument should fail"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -rf ./testfile*
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
