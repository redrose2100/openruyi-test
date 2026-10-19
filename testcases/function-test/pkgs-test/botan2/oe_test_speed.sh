
#!/usr/bin/bash
# 请填写测试用例描述：测试botan speed命令，包括不同的参数组合和参数顺序

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "Test data" > ./test_data.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试speed命令的基本用法
    botan speed --msec=500 --format=default --ecc-groups= --provider= --buf-size=1024 --clear-cpuid= --cpu-clock-speed=0 --cpu-clock-ratio=1.0 sha256
    CHECK_RESULT $? 0 0 "botan speed command failed with default parameters"

    # 测试不同的msec参数
    botan speed --msec=1000 --format=default --ecc-groups= --provider= --buf-size=1024 --clear-cpuid= --cpu-clock-speed=0 --cpu-clock-ratio=1.0 sha256
    CHECK_RESULT $? 0 0 "botan speed command failed with msec=1000"

    # 测试不同的buf-size参数
    botan speed --msec=500 --format=default --ecc-groups= --provider= --buf-size=2048 --clear-cpuid= --cpu-clock-speed=0 --cpu-clock-ratio=1.0 sha256
    CHECK_RESULT $? 0 0 "botan speed command failed with buf-size=2048"

    # 测试不同的ecc-groups参数
    botan speed --msec=500 --format=default --ecc-groups=P-256 --provider= --buf-size=1024 --clear-cpuid= --cpu-clock-speed=0 --cpu-clock-ratio=1.0 sha256
    CHECK_RESULT $? 0 0 "botan speed command failed with ecc-groups=P-256"

    # 测试不同的provider参数
    botan speed --msec=500 --format=default --ecc-groups= --provider=openssl --buf-size=1024 --clear-cpuid= --cpu-clock-speed=0 --cpu-clock-ratio=1.0 sha256
    CHECK_RESULT $? 0 0 "botan speed command failed with provider=openssl"

    # 测试不同的cpu-clock-speed参数
    botan speed --msec=500 --format=default --ecc-groups= --provider= --buf-size=1024 --clear-cpuid= --cpu-clock-speed=2000 --cpu-clock-ratio=1.0 sha256
    CHECK_RESULT $? 0 0 "botan speed command failed with cpu-clock-speed=2000"

    # 测试不同的cpu-clock-ratio参数
    botan speed --msec=500 --format=default --ecc-groups= --provider= --buf-size=1024 --clear-cpuid= --cpu-clock-speed=0 --cpu-clock-ratio=0.5 sha256
    CHECK_RESULT $? 0 0 "botan speed command failed with cpu-clock-ratio=0.5"

    # 测试不同的algos参数
    botan speed --msec=500 --format=default --ecc-groups= --provider= --buf-size=1024 --clear-cpuid= --cpu-clock-speed=0 --cpu-clock-ratio=1.0 sha256 aes-256-cbc
    CHECK_RESULT $? 0 0 "botan speed command failed with multiple algos"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f ./test_data.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
