
#!/usr/bin/bash
# 请填写测试用例描述：测试stestr的run命令，验证其在不同参数组合下的行为

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-stestr"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mkdir -p ./test_dir
    touch ./test_dir/test_file.py
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    # 测试run命令的基本用法
    stestr run --test-path ./test_dir
    CHECK_RESULT $? 0 0 "stestr run --test-path ./test_dir failed"

    # 测试run命令的--verbose参数
    stestr run --test-path ./test_dir --verbose
    CHECK_RESULT $? 0 0 "stestr run --test-path ./test_dir --verbose failed"

    # 测试run命令的--quiet参数
    stestr run --test-path ./test_dir --quiet
    CHECK_RESULT $? 0 0 "stestr run --test-path ./test_dir --quiet failed"

    # 测试run命令的--debug参数
    stestr run --test-path ./test_dir --debug
    CHECK_RESULT $? 0 0 "stestr run --test-path ./test_dir --debug failed"

    # 测试run命令的--config参数
    echo "[stestr]" > ./test_dir/.stestr.conf
    echo "test_path = ./test_dir" >> ./test_dir/.stestr.conf
    stestr run --config ./test_dir/.stestr.conf
    CHECK_RESULT $? 0 0 "stestr run --config ./test_dir/.stestr.conf failed"

    # 测试run命令的--repo-type参数
    stestr run --test-path ./test_dir --repo-type file
    CHECK_RESULT $? 0 0 "stestr run --test-path ./test_dir --repo-type file failed"

    # 测试run命令的--top-dir参数
    stestr run --test-path ./test_dir --top-dir ./test_dir
    CHECK_RESULT $? 0 0 "stestr run --test-path ./test_dir --top-dir ./test_dir failed"

    # 测试run命令的--group-regex参数
    stestr run --test-path ./test_dir --group-regex "test_.*"
    CHECK_RESULT $? 0 0 "stestr run --test-path ./test_dir --group-regex 'test_.*' failed"

    # 测试run命令的--parallel-class参数
    stestr run --test-path ./test_dir --parallel-class
    CHECK_RESULT $? 0 0 "stestr run --test-path ./test_dir --parallel-class failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "python-stestr"
    rm -rf ./test_dir
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
