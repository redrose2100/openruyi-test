
#!/usr/bin/bash
# 本测试用例用于测试xfce4-dict命令的基本功能，包括不同的搜索选项和参数组合。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-dict"
    # 准备测试数据
    echo "test text" > ./test_data.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试-d, --dict参数
    xfce4-dict --dict "test text"
    CHECK_RESULT $? 0 0 "failed to use --dict option"
    
    # 测试-w, --web参数
    xfce4-dict --web "test text"
    CHECK_RESULT $? 0 0 "failed to use --web option"
    
    # 测试-s, --spell参数
    xfce4-dict --spell "test text"
    CHECK_RESULT $? 0 0 "failed to use --spell option"
    
    # 测试-t, --text-field参数
    xfce4-dict --text-field
    CHECK_RESULT $? 0 0 "failed to use --text-field option"
    
    # 测试-i, --ignore-plugin参数
    xfce4-dict --ignore-plugin
    CHECK_RESULT $? 0 0 "failed to use --ignore-plugin option"
    
    # 测试-c, --clipboard参数
    xfce4-dict --clipboard
    CHECK_RESULT $? 0 0 "failed to use --clipboard option"
    
    # 测试-v, --verbose参数
    xfce4-dict --verbose
    CHECK_RESULT $? 0 0 "failed to use --verbose option"
    
    # 测试-V, --version参数
    xfce4-dict --version
    CHECK_RESULT $? 0 0 "failed to use --version option"
    
    # 测试组合参数
    xfce4-dict --dict "test text" --verbose
    CHECK_RESULT $? 0 0 "failed to use combination of --dict and --verbose options"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-dict"
    # 清理测试中间产物文件
    rm -f ./test_data.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
