
#!/usr/bin/bash
# 请填写测试用例描述：测试 kpackagetool5 的 --remove-index 命令，包括全局和特定类型的插件索引移除

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
    # 测试 --remove-index 命令
    /usr/bin/kpackagetool5 --remove-index
    CHECK_RESULT $? 0 0 "Failed to remove index without specifying type or global option"

    # 测试 --remove-index 和 --global 选项
    /usr/bin/kpackagetool5 --remove-index --global
    CHECK_RESULT $? 0 0 "Failed to remove global index"

    # 测试 --remove-index 和 --type 选项
    /usr/bin/kpackagetool5 --remove-index --type Plasma/Theme
    CHECK_RESULT $? 0 0 "Failed to remove index for specific type Plasma/Theme"

    # 测试 --remove-index 和 --type 选项的其他类型
    /usr/bin/kpackagetool5 --remove-index --type Plasma/Wallpaper
    CHECK_RESULT $? 0 0 "Failed to remove index for specific type Plasma/Wallpaper"

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
