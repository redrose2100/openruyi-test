
#!/usr/bin/bash
# 本测试脚本用于测试bashate命令，包括基本的命令使用、参数组合和错误处理

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-bashate"
    # 准备测试数据
    echo -e "#!/bin/bash\nif [ \$1 -eq 0 ]; then\n  echo 'Hello'\nfi" > ./test_script.sh
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 基本命令使用
    bashate ./test_script.sh
    CHECK_RESULT $? 1 0 "bashate command failed"
    
    # 使用 -i 参数忽略某些规则
    bashate -i E005 ./test_script.sh
    CHECK_RESULT $? 1 0 "bashate command with -i parameter failed"
    
    # 使用 -w 参数设置警告规则
    bashate -w E006 ./test_script.sh
    CHECK_RESULT $? 1 0 "bashate command with -w parameter failed"
    
    # 使用 -e 参数设置错误规则
    bashate -e E044 ./test_script.sh
    CHECK_RESULT $? 1 0 "bashate command with -e parameter failed"
    
    # 使用 --max-line-length 参数设置最大行长度
    bashate --max-line-length 80 ./test_script.sh
    CHECK_RESULT $? 1 0 "bashate command with --max-line-length parameter failed"
    
    # 使用 -v 参数显示详细信息
    bashate -v ./test_script.sh
    CHECK_RESULT $? 1 0 "bashate command with -v parameter failed"
    
    # 使用 --version 参数显示版本信息
    bashate --version
    CHECK_RESULT $? 0 0 "bashate command with --version parameter failed"
    
    # 使用 -s 参数显示详细信息
    bashate -s ./test_script.sh
    CHECK_RESULT $? 0 0 "bashate command with -s parameter failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "python-bashate"
    # 清理测试中间产物文件
    rm -f ./test_script.sh
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
