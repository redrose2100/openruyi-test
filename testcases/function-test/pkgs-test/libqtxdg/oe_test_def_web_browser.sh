
#!/usr/bin/bash
# 测试用例描述：测试 qtxdg-mat def-web-browser 命令，包括获取默认浏览器、设置默认浏览器和列出可用浏览器

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "libqtxdg"
    # 准备测试数据
    echo "firefox" > ./firefox.desktop
    echo "chrome" > ./chrome.desktop
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试获取默认浏览器
    qtxdg-mat def-web-browser
    CHECK_RESULT $? 0 0 "Failed to get default web browser"

    # 测试列出可用浏览器
    qtxdg-mat def-web-browser -l
    CHECK_RESULT $? 0 0 "Failed to list available web browsers"

    # 测试设置默认浏览器
    qtxdg-mat def-web-browser -s "./firefox.desktop"
    CHECK_RESULT $? 0 0 "Failed to set default web browser to firefox"

    # 验证设置是否成功
    qtxdg-mat def-web-browser
    CHECK_RESULT $? 0 0 "Failed to verify default web browser setting"
    CHECK_RESULT "$(qtxdg-mat def-web-browser)" "./firefox.desktop" 0 "Default web browser not set to firefox"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "libqtxdg"
    # 清理测试中间产物文件
    rm -f ./firefox.desktop ./chrome.desktop
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
