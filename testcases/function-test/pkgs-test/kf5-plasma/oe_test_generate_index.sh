
#!/usr/bin/bash
# 请填写测试用例描述：测试 kpackagetool5 的 --generate-index 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-plasma"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --generate-index 命令
    kpackagetool5 --generate-index
    CHECK_RESULT $? 0 0 "failed to generate index without type or global option"

    # 测试 --generate-index 与 -t 选项组合
    kpackagetool5 --generate-index -t Plasma/Theme
    CHECK_RESULT $? 0 0 "failed to generate index with type option"

    # 测试 --generate-index 与 -g 选项组合
    kpackagetool5 --generate-index -g
    CHECK_RESULT $? 0 0 "failed to generate index with global option"

    # 测试 --generate-index 与 -t 和 -g 选项组合
    kpackagetool5 --generate-index -t Plasma/Theme -g
    CHECK_RESULT $? 0 0 "failed to generate index with type and global options"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "kf5-plasma"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
