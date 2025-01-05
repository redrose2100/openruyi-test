
#!/usr/bin/bash
# 本测试用例用于测试xfce4-screenshooter命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "xfce4-screenshooter"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./test_dir
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试命令的基本用法
    xfce4-screenshooter -f
    CHECK_RESULT $? 0 0 "failed to take fullscreen screenshot"
    
    # 测试命令的延迟参数
    xfce4-screenshooter -d 5 -f
    CHECK_RESULT $? 0 0 "failed to take fullscreen screenshot with delay"
    
    # 测试命令的保存参数
    xfce4-screenshooter -s ./test_dir/screenshot.png
    CHECK_RESULT $? 0 0 "failed to save screenshot to file"
    
    # 测试命令的区域选择参数
    xfce4-screenshooter -r -s ./test_dir/region.png
    CHECK_RESULT $? 0 0 "failed to capture region screenshot"
    
    # 测试命令的窗口截图参数
    xfce4-screenshooter -w -s ./test_dir/window.png
    CHECK_RESULT $? 0 0 "failed to capture window screenshot"
    
    # 测试命令的鼠标显示参数
    xfce4-screenshooter -m -s ./test_dir/mouse.png
    CHECK_RESULT $? 0 0 "failed to capture screenshot with mouse"
    
    # 测试命令的剪贴板参数
    xfce4-screenshooter -c
    CHECK_RESULT $? 0 0 "failed to copy screenshot to clipboard"
    
    # 测试命令的版本信息参数
    xfce4-screenshooter -V
    CHECK_RESULT $? 0 0 "failed to get version information"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "xfce4-screenshooter"
    # 清理测试中间产物文件
    rm -rf ./test_dir
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
