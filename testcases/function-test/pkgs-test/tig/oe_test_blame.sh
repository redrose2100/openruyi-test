
#!/usr/bin/bash
# 请填写测试用例描述：测试tig blame命令的基本功能和参数组合

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
    echo "Initial content" > file.txt
    git add file.txt
    git commit -m "Initial commit"
    echo "Modified content" >> file.txt
    git add file.txt
    git commit -m "Second commit"
    cd ..
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试tig blame命令的基本功能
    tig blame HEAD -- ./test_repo/file.txt
    CHECK_RESULT $? 0 0 "tig blame command failed"

    # 测试tig blame命令的参数组合
    tig blame -C./test_repo HEAD -- ./test_repo/file.txt
    CHECK_RESULT $? 0 0 "tig blame with -C option failed"

    # 测试tig blame命令的参数顺序
    tig blame HEAD -- ./test_repo/file.txt
    CHECK_RESULT $? 0 0 "tig blame with correct parameter order failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复
    DNF_REMOVE "tig"
    rm -rf ./test_repo
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
