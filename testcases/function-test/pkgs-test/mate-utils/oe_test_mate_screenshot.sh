
#!/usr/bin/bash
# 本测试脚本用于测试mate-screenshot命令的各种参数组合和功能

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mate-utils"
    # 准备测试数据等
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    mate-screenshot --help
    CHECK_RESULT $? 0 0 "Failed to show help options"
    
    # 测试版本信息
    mate-screenshot --version
    CHECK_RESULT $? 0 0 "Failed to show version information"
    
    # 测试截取整个屏幕
    mate-screenshot
    CHECK_RESULT $? 0 0 "Failed to take screenshot of the entire screen"
    
    # 测试截取窗口
    mate-screenshot -w
    CHECK_RESULT $? 0 0 "Failed to take screenshot of a window"
    
    # 测试截取区域
    mate-screenshot -a
    CHECK_RESULT $? 0 0 "Failed to take screenshot of an area"
    
    # 测试截取并发送到剪贴板
    mate-screenshot -c
    CHECK_RESULT $? 0 0 "Failed to send screenshot to clipboard"
    
    # 测试包含窗口边框
    mate-screenshot -b
    CHECK_RESULT $? 0 0 "Failed to include window border"
    
    # 测试移除窗口边框
    mate-screenshot -B
    CHECK_RESULT $? 0 0 "Failed to remove window border"
    
    # 测试延迟截图
    mate-screenshot -d 5
    CHECK_RESULT $? 0 0 "Failed to take screenshot with delay"
    
    # 测试边框效果
    mate-screenshot -e shadow
    CHECK_RESULT $? 0 0 "Failed to add shadow effect to border"
    mate-screenshot -e border
    CHECK_RESULT $? 0 0 "Failed to add border effect to border"
    mate-screenshot -e none
    CHECK_RESULT $? 0 0 "Failed to add none effect to border"
    
    # 测试交互模式
    mate-screenshot -i
    CHECK_RESULT $? 0 0 "Failed to enter interactive mode"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "mate-utils"
    # 清理测试中间产物文件
    rm -f ./screenshot*.png
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
