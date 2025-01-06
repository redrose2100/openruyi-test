
#!/usr/bin/bash
# 请填写测试用例描述：测试 tig grep 命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "tig"
    # 准备测试数据
    mkdir -p ./test_repo
    cd ./test_repo
    git init
    echo "This is a test file." > test.txt
    git add test.txt
    git commit -m "Initial commit"
    cd ..
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 tig grep 命令的基本用法
    tig grep "test"
    CHECK_RESULT $? 0 0 "tig grep failed"

    # 测试 tig grep 命令的其他参数组合
    tig grep -v "test"
    CHECK_RESULT $? 0 0 "tig grep -v failed"

    # 测试 tig grep 命令的其他参数组合
    tig grep -- "test"
    CHECK_RESULT $? 0 0 "tig grep -- failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "tig"
    # 清理测试中间产物文件
    rm -rf ./test_repo
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
