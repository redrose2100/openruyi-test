
#!/usr/bin/bash
# 测试用例描述：测试 imsettings-switch 命令的各种参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "imsettings"
    # 准备测试数据
    echo "input-method-name" > ./input-method-name
    echo "xinput.conf" > ./xinput.conf
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 -h 参数
    imsettings-switch -h
    CHECK_RESULT $? 0 0 "imsettings-switch -h failed"

    # 测试 --help 参数
    imsettings-switch --help
    CHECK_RESULT $? 0 0 "imsettings-switch --help failed"

    # 测试 -f 参数
    imsettings-switch -f "input-method-name"
    CHECK_RESULT $? 1 0 "imsettings-switch -f failed"

    # 测试 --force 参数
    imsettings-switch --force "input-method-name"
    CHECK_RESULT $? 1 0 "imsettings-switch --force failed"

    # 测试 -d 参数
    imsettings-switch -d "gnome" "input-method-name"
    CHECK_RESULT $? 1 0 "imsettings-switch -d failed"

    # 测试 --desktop 参数
    imsettings-switch --desktop "gnome" "input-method-name"
    CHECK_RESULT $? 1 0 "imsettings-switch --desktop failed"

    # 测试 -n 参数
    imsettings-switch -n "input-method-name"
    CHECK_RESULT $? 1 0 "imsettings-switch -n failed"

    # 测试 --no-update 参数
    imsettings-switch --no-update "input-method-name"
    CHECK_RESULT $? 1 0 "imsettings-switch --no-update failed"

    # 测试 -q 参数
    imsettings-switch -q "input-method-name"
    CHECK_RESULT $? 1 0 "imsettings-switch -q failed"

    # 测试 --quiet 参数
    imsettings-switch --quiet "input-method-name"
    CHECK_RESULT $? 1 0 "imsettings-switch --quiet failed"

    # 测试 -r 参数
    imsettings-switch -r "input-method-name"
    CHECK_RESULT $? 1 0 "imsettings-switch -r failed"

    # 测试 --restart 参数
    imsettings-switch --restart "input-method-name"
    CHECK_RESULT $? 1 0 "imsettings-switch --restart failed"

    # 测试 -x 参数
    imsettings-switch -x "xinput.conf"
    CHECK_RESULT $? 0 0 "imsettings-switch -x failed"

    # 测试 --read-xinputrc 参数
    imsettings-switch --read-xinputrc "xinput.conf"
    CHECK_RESULT $? 0 0 "imsettings-switch --read-xinputrc failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "imsettings"
    # 清理测试中间产物文件
    rm -f ./input-method-name ./xinput.conf
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
