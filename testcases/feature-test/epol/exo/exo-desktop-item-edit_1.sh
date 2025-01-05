
#!/usr/bin/bash
# 请填写测试用例描述：测试 exo-desktop-item-edit 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "exo"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./test_dir
    touch ./test_dir/test.desktop
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试帮助选项
    exo-desktop-item-edit --help
    CHECK_RESULT $? 0 0 "exo-desktop-item-edit --help failed"
    
    exo-desktop-item-edit --help-all
    CHECK_RESULT $? 0 0 "exo-desktop-item-edit --help-all failed"
    
    exo-desktop-item-edit --help-gtk
    CHECK_RESULT $? 0 0 "exo-desktop-item-edit --help-gtk failed"
    
    # 测试创建新的桌面文件
    exo-desktop-item-edit --create-new --type Application --name "Test App" --command "echo Hello" --icon "application-x-executable" ./test_dir
    CHECK_RESULT $? 0 0 "exo-desktop-item-edit --create-new failed"
    
    # 测试创建链接类型的桌面文件
    exo-desktop-item-edit --create-new --type Link --name "Test Link" --url "http://example.com" --icon "internet-web-browser" ./test_dir
    CHECK_RESULT $? 0 0 "exo-desktop-item-edit --create-new --type Link failed"
    
    # 测试版本信息
    exo-desktop-item-edit --version
    CHECK_RESULT $? 0 0 "exo-desktop-item-edit --version failed"
    
    # 测试指定显示
    exo-desktop-item-edit --display=:0.0
    CHECK_RESULT $? 0 0 "exo-desktop-item-edit --display=:0.0 failed"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "exo"
    # 清理测试中间产物文件
    rm -rf ./test_dir
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
