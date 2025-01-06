
#!/usr/bin/bash
# 请填写测试用例描述：测试 nmstatectl set 命令及其参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "nmstate"
    # 准备测试数据
    cat <<EOF > ./test_state.yaml
interfaces:
  - name: eth0
    type: ethernet
    state: up
EOF
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 nmstatectl set 命令
    nmstatectl set ./test_state.yaml
    CHECK_RESULT $? 0 0 "nmstatectl set failed"

    # 测试 --no-verify 参数
    nmstatectl set --no-verify ./test_state.yaml
    CHECK_RESULT $? 0 0 "nmstatectl set --no-verify failed"

    # 测试 --no-commit 参数
    nmstatectl set --no-commit ./test_state.yaml
    CHECK_RESULT $? 0 0 "nmstatectl set --no-commit failed"

    # 测试 --timeout 参数
    nmstatectl set --timeout 60 ./test_state.yaml
    CHECK_RESULT $? 0 0 "nmstatectl set --timeout failed"

    # 测试 --memory-only 参数
    nmstatectl set --memory-only ./test_state.yaml
    CHECK_RESULT $? 0 0 "nmstatectl set --memory-only failed"

    # 测试多个参数组合
    nmstatectl set --no-verify --no-commit --timeout 60 --memory-only ./test_state.yaml
    CHECK_RESULT $? 0 0 "nmstatectl set with multiple parameters failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "nmstate"
    # 清理测试中间产物文件
    rm -f ./test_state.yaml
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
