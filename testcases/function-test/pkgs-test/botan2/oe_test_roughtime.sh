
#!/usr/bin/bash
# 测试botan2的roughtime命令，包括不同的参数组合和参数顺序

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "botan2"
    # 准备测试数据
    echo "Cloudflare-Roughtime ed25519 gD63hSj3ScS+wuOeGrubXlq35N1c5Lby/S+T7MNTjxo= udp roughtime.cloudflare.com:2002" > servers.txt
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试roughtime命令的基本用法
    botan2 roughtime --servers-file=servers.txt
    CHECK_RESULT $? 0 0 "botan2 roughtime --servers-file=servers.txt failed"

    # 测试roughtime命令的--chain-file参数
    botan2 roughtime --servers-file=servers.txt --chain-file=chain.txt
    CHECK_RESULT $? 0 0 "botan2 roughtime --servers-file=servers.txt --chain-file=chain.txt failed"

    # 测试roughtime命令的--max-chain-size参数
    botan2 roughtime --servers-file=servers.txt --chain-file=chain.txt --max-chain-size=64
    CHECK_RESULT $? 0 0 "botan2 roughtime --servers-file=servers.txt --chain-file=chain.txt --max-chain-size=64 failed"

    # 测试roughtime命令的--check-local-clock参数
    botan2 roughtime --servers-file=servers.txt --chain-file=chain.txt --check-local-clock=30
    CHECK_RESULT $? 0 0 "botan2 roughtime --servers-file=servers.txt --chain-file=chain.txt --check-local-clock=30 failed"

    # 测试roughtime命令的--raw-time参数
    botan2 roughtime --servers-file=servers.txt --chain-file=chain.txt --raw-time
    CHECK_RESULT $? 0 0 "botan2 roughtime --servers-file=servers.txt --chain-file=chain.txt --raw-time failed"

    # 测试参数顺序
    botan2 roughtime --raw-time --check-local-clock=30 --max-chain-size=64 --chain-file=chain.txt --servers-file=servers.txt
    CHECK_RESULT $? 0 0 "botan2 roughtime --raw-time --check-local-clock=30 --max-chain-size=64 --chain-file=chain.txt --servers-file=servers.txt failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "botan2"
    # 清理测试中间产物文件
    rm -f servers.txt chain.txt
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
