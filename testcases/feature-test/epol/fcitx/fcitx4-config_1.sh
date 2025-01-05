
#!/usr/bin/bash
# 请填写测试用例描述：测试fcitx4-config命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "fcitx"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --package 参数
    fcitx4-config --package
    CHECK_RESULT $? 0 0 "fcitx4-config --package failed"

    # 测试 --prefix 参数
    fcitx4-config --prefix
    CHECK_RESULT $? 0 0 "fcitx4-config --prefix failed"

    # 测试 --exec-prefix 参数
    fcitx4-config --exec-prefix
    CHECK_RESULT $? 0 0 "fcitx4-config --exec-prefix failed"

    # 测试 --libdir 参数
    fcitx4-config --libdir
    CHECK_RESULT $? 0 0 "fcitx4-config --libdir failed"

    # 测试 --includedir 参数
    fcitx4-config --includedir
    CHECK_RESULT $? 0 0 "fcitx4-config --includedir failed"

    # 测试 --addondir 参数
    fcitx4-config --addondir
    CHECK_RESULT $? 0 0 "fcitx4-config --addondir failed"

    # 测试 --configdescdir 参数
    fcitx4-config --configdescdir
    CHECK_RESULT $? 0 0 "fcitx4-config --configdescdir failed"

    # 测试 --addonconfigdir 参数
    fcitx4-config --addonconfigdir
    CHECK_RESULT $? 0 0 "fcitx4-config --addonconfigdir failed"

    # 测试 --imconfigdir 参数
    fcitx4-config --imconfigdir
    CHECK_RESULT $? 0 0 "fcitx4-config --imconfigdir failed"

    # 测试 --help 参数
    fcitx4-config --help
    CHECK_RESULT $? 0 0 "fcitx4-config --help failed"

    # 测试 --version 参数
    fcitx4-config --version
    CHECK_RESULT $? 0 0 "fcitx4-config --version failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "fcitx"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
