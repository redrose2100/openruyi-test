
#!/usr/bin/bash
# 本测试脚本用于测试codecov命令的基本功能和参数组合

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-codecov"
    # 准备测试数据
    touch ./test_file1.txt
    touch ./test_file2.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 --version 参数
    codecov --version
    CHECK_RESULT $? 0 0 "codecov --version failed"

    # 测试 --token 参数
    codecov --token "test_token"
    CHECK_RESULT $? 0 0 "codecov --token failed"

    # 测试 --file 参数
    codecov --file ./test_file1.txt --file ./test_file2.txt
    CHECK_RESULT $? 0 0 "codecov --file failed"

    # 测试 --flags 参数
    codecov --flags "flag1" --flags "flag2"
    CHECK_RESULT $? 0 0 "codecov --flags failed"

    # 测试 --env 参数
    codecov --env "env1=value1" --env "env2=value2"
    CHECK_RESULT $? 0 0 "codecov --env failed"

    # 测试 --required 参数
    codecov --required
    CHECK_RESULT $? 0 0 "codecov --required failed"

    # 测试 --name 参数
    codecov --name "test_name"
    CHECK_RESULT $? 0 0 "codecov --name failed"

    # 测试 --gcov-root 参数
    codecov --gcov-root "./"
    CHECK_RESULT $? 0 0 "codecov --gcov-root failed"

    # 测试 --gcov-glob 参数
    codecov --gcov-glob "test_file1.txt" --gcov-glob "test_file2.txt"
    CHECK_RESULT $? 0 0 "codecov --gcov-glob failed"

    # 测试 --gcov-exec 参数
    codecov --gcov-exec "gcov"
    CHECK_RESULT $? 0 0 "codecov --gcov-exec failed"

    # 测试 --no-gcov-out 参数
    codecov --no-gcov-out
    CHECK_RESULT $? 0 0 "codecov --no-gcov-out failed"

    # 测试 --gcov-args 参数
    codecov --gcov-args "--version"
    CHECK_RESULT $? 0 0 "codecov --gcov-args failed"

    # 测试 --disable 参数
    codecov --disable "search" --disable "detect"
    CHECK_RESULT $? 0 0 "codecov --disable failed"

    # 测试 --root 参数
    codecov --root "./"
    CHECK_RESULT $? 0 0 "codecov --root failed"

    # 测试 --commit 参数
    codecov --commit "test_commit"
    CHECK_RESULT $? 0 0 "codecov --commit failed"

    # 测试 --prefix 参数
    codecov --prefix "test_prefix"
    CHECK_RESULT $? 0 0 "codecov --prefix failed"

    # 测试 --branch 参数
    codecov --branch "test_branch"
    CHECK_RESULT $? 0 0 "codecov --branch failed"

    # 测试 --build 参数
    codecov --build "test_build"
    CHECK_RESULT $? 0 0 "codecov --build failed"

    # 测试 --pr 参数
    codecov --pr "123"
    CHECK_RESULT $? 0 0 "codecov --pr failed"

    # 测试 --tag 参数
    codecov --tag "test_tag"
    CHECK_RESULT $? 0 0 "codecov --tag failed"

    # 测试 --tries 参数
    codecov --tries "3"
    CHECK_RESULT $? 0 0 "codecov --tries failed"

    # 测试 --slug 参数
    codecov --slug "owner/repo"
    CHECK_RESULT $? 0 0 "codecov --slug failed"

    # 测试 --url 参数
    codecov --url "http://test.url"
    CHECK_RESULT $? 0 0 "codecov --url failed"

    # 测试 --cacert 参数
    codecov --cacert "./test_cert.pem"
    CHECK_RESULT $? 0 0 "codecov --cacert failed"

    # 测试 --dump 参数
    codecov --dump
    CHECK_RESULT $? 0 0 "codecov --dump failed"

    # 测试 --verbose 参数
    codecov --verbose
    CHECK_RESULT $? 0 0 "codecov --verbose failed"

    # 测试 --no-color 参数
    codecov --no-color
    CHECK_RESULT $? 0 0 "codecov --no-color failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    DNF_REMOVE "python-codecov"
    # 清理测试中间产物文件
    rm -f ./test_file1.txt ./test_file2.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
