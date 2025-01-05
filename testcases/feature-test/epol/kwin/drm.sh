
#!/usr/bin/bash
# 测试 kwin_wayland --drm 参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kwin"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    kwin_wayland --drm
    CHECK_RESULT $? 0 0 "kwin_wayland --drm failed"
    
    # 测试 --drm 参数与其他参数的组合
    kwin_wayland --drm --lock
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --lock failed"
    
    kwin_wayland --drm --crashes 1
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --crashes 1 failed"
    
    kwin_wayland --drm --xwayland
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --xwayland failed"
    
    kwin_wayland --drm --socket wayland-1
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --socket wayland-1 failed"
    
    kwin_wayland --drm --wayland-fd 3
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --wayland-fd 3 failed"
    
    kwin_wayland --drm --xwayland-fd 4
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --xwayland-fd 4 failed"
    
    kwin_wayland --drm --xwayland-display :1
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --xwayland-display :1 failed"
    
    kwin_wayland --drm --xwayland-xauthority /tmp/xauth
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --xwayland-xauthority /tmp/xauth failed"
    
    kwin_wayland --drm --replace
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --replace failed"
    
    kwin_wayland --drm --x11-display :0
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --x11-display :0 failed"
    
    kwin_wayland --drm --wayland-display wayland-1
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --wayland-display wayland-1 failed"
    
    kwin_wayland --drm --virtual
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --virtual failed"
    
    kwin_wayland --drm --width 1280
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --width 1280 failed"
    
    kwin_wayland --drm --height 720
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --height 720 failed"
    
    kwin_wayland --drm --scale 2
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --scale 2 failed"
    
    kwin_wayland --drm --output-count 2
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --output-count 2 failed"
    
    kwin_wayland --drm --inputmethod /path/to/imserver
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --inputmethod /path/to/imserver failed"
    
    kwin_wayland --drm --lockscreen
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --lockscreen failed"
    
    kwin_wayland --drm --no-lockscreen
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --no-lockscreen failed"
    
    kwin_wayland --drm --no-global-shortcuts
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --no-global-shortcuts failed"
    
    kwin_wayland --drm --no-kactivities
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --no-kactivities failed"
    
    kwin_wayland --drm --exit-with-session /path/to/session
    CHECK_RESULT $? 0 0 "kwin_wayland --drm --exit-with-session /path/to/session failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "kwin"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
