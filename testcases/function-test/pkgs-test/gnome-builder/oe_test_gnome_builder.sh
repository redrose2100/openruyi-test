
#!/usr/bin/bash
# 本测试用例用于测试gnome-builder命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "gnome-builder"
    # 准备测试数据
    touch "./test_project.vala"
    touch "./test_manifest.json"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    gnome-builder --help
    CHECK_RESULT $? 0 0 "gnome-builder --help failed"
    gnome-builder --help-all
    CHECK_RESULT $? 0 0 "gnome-builder --help-all failed"
    gnome-builder --help-gapplication
    CHECK_RESULT $? 0 0 "gnome-builder --help-gapplication failed"
    gnome-builder --help-gtk
    CHECK_RESULT $? 0 0 "gnome-builder --help-gtk failed"

    # 测试应用选项
    gnome-builder --preferences
    CHECK_RESULT $? 0 0 "gnome-builder --preferences failed"
    gnome-builder -p ./test_project.vala
    CHECK_RESULT $? 0 0 "gnome-builder -p ./test_project.vala failed"
    gnome-builder -V
    CHECK_RESULT $? 0 0 "gnome-builder -V failed"
    gnome-builder -v
    CHECK_RESULT $? 0 0 "gnome-builder -v failed"
    gnome-builder -e
    CHECK_RESULT $? 0 0 "gnome-builder -e failed"
    gnome-builder -i ./test_project.vala
    CHECK_RESULT $? 0 0 "gnome-builder -i ./test_project.vala failed"
    gnome-builder --dspy
    CHECK_RESULT $? 0 0 "gnome-builder --dspy failed"
    gnome-builder -g
    CHECK_RESULT $? 0 0 "gnome-builder -g failed"
    gnome-builder --clone "https://example.com/repo"
    CHECK_RESULT $? 0 0 "gnome-builder --clone failed"
    gnome-builder --create-project
    CHECK_RESULT $? 0 0 "gnome-builder --create-project failed"
    gnome-builder -m ./test_manifest.json
    CHECK_RESULT $? 0 0 "gnome-builder -m ./test_manifest.json failed"
    gnome-builder --display ":0"
    CHECK_RESULT $? 0 0 "gnome-builder --display failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "gnome-builder"
    # 清理测试中间产物文件
    rm -f "./test_project.vala"
    rm -f "./test_manifest.json"
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
