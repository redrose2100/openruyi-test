
#!/usr/bin/bash
# 请填写测试用例描述：测试 kpackagetool5 的 --list 选项，列出已安装的包

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-plasma"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --list 参数
    kpackagetool5 --list
    CHECK_RESULT $? 0 0 "kpackagetool5 --list failed"
    # 测试 --list 和 --type 参数组合
    kpackagetool5 --list --type Plasma/Theme
    CHECK_RESULT $? 0 0 "kpackagetool5 --list --type Plasma/Theme failed"
    # 测试 --list 和 --global 参数组合
    kpackagetool5 --list --global
    CHECK_RESULT $? 0 0 "kpackagetool5 --list --global failed"
    # 测试 --list 和 --packageroot 参数组合
    kpackagetool5 --list --packageroot /usr/share/kde4/apps
    CHECK_RESULT $? 0 0 "kpackagetool5 --list --packageroot /usr/share/kde4/apps failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "kf5-plasma"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
