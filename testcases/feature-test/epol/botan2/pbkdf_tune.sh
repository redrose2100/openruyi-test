
#!/usr/bin/bash
# 本测试用例用于测试botan的pbkdf_tune命令，包括不同的参数组合和参数顺序。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "test_password" > ./test_password.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试基本参数组合
    botan pbkdf_tune --algo=Scrypt --max-mem=256 --output-len=32 --check 1
    CHECK_RESULT $? 0 0 "pbkdf_tune command failed with basic parameters"

    # 测试不同的max-mem值
    botan pbkdf_tune --algo=Scrypt --max-mem=512 --output-len=32 --check 1
    CHECK_RESULT $? 0 0 "pbkdf_tune command failed with max-mem=512"

    # 测试不同的output-len值
    botan pbkdf_tune --algo=Scrypt --max-mem=256 --output-len=64 --check 1
    CHECK_RESULT $? 0 0 "pbkdf_tune command failed with output-len=64"

    # 测试不同的check次数
    botan pbkdf_tune --algo=Scrypt --max-mem=256 --output-len=32 --check 3
    CHECK_RESULT $? 0 0 "pbkdf_tune command failed with check=3"

    # 测试参数顺序
    botan pbkdf_tune --check 1 --output-len=32 --max-mem=256 --algo=Scrypt
    CHECK_RESULT $? 0 0 "pbkdf_tune command failed with different parameter order"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_password.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
