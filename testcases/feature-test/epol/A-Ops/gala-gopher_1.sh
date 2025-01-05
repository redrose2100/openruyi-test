
#!/usr/bin/bash
# 本测试用例用于测试gala-gopher命令的基本功能，包括帮助信息和配置文件路径参数。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "A-Ops"
    # 准备测试数据
    echo "test_config" > ./test_config.conf
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助信息
    gala-gopher -h
    CHECK_RESULT $? 0 0 "gala-gopher -h failed"
    # 测试配置文件路径参数
    gala-gopher --config_path ./test_config.conf
    CHECK_RESULT $? 0 0 "gala-gopher --config_path ./test_config.conf failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "A-Ops"
    # 清理测试中间产物文件
    rm -f ./test_config.conf
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
