
#!/usr/bin/bash
# 本测试用例用于测试gnome-maps命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gnome-maps"
    # 准备测试数据
    mkdir -p ./local_tiles
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    gnome-maps --help
    CHECK_RESULT $? 0 0 "Failed to show help options"
    
    gnome-maps --help-all
    CHECK_RESULT $? 0 0 "Failed to show all help options"
    
    gnome-maps --help-gapplication
    CHECK_RESULT $? 0 0 "Failed to show GApplication options"
    
    gnome-maps --help-gtk
    CHECK_RESULT $? 0 0 "Failed to show GTK+ options"
    
    # 测试版本信息
    gnome-maps --version
    CHECK_RESULT $? 0 0 "Failed to show version information"
    
    # 测试本地地图目录结构
    gnome-maps --local=./local_tiles
    CHECK_RESULT $? 0 0 "Failed to use local tiles directory"
    
    # 测试本地地图目录结构和tile size
    gnome-maps --local=./local_tiles --local-tile-size=256
    CHECK_RESULT $? 0 0 "Failed to use local tiles directory with tile size"
    
    # 测试忽略网络可用性
    gnome-maps --force-online
    CHECK_RESULT $? 0 0 "Failed to ignore network availability"
    
    # 测试X display
    gnome-maps --display=:0
    CHECK_RESULT $? 0 0 "Failed to use X display"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "gnome-maps"
    # 清理测试中间产物文件
    rm -rf ./local_tiles
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
