
#!/usr/bin/bash
# 测试 crictl stats 命令及其参数

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 crictl stats 命令及其参数
    crictl stats
    CHECK_RESULT $? 0 0 "crictl stats failed"

    crictl stats --all
    CHECK_RESULT $? 0 0 "crictl stats --all failed"

    crictl stats --output json
    CHECK_RESULT $? 0 0 "crictl stats --output json failed"

    crictl stats --output yaml
    CHECK_RESULT $? 0 0 "crictl stats --output yaml failed"

    crictl stats --output table
    CHECK_RESULT $? 0 0 "crictl stats --output table failed"

    crictl stats --seconds 2
    CHECK_RESULT $? 0 0 "crictl stats --seconds 2 failed"

    crictl stats --watch
    CHECK_RESULT $? 0 0 "crictl stats --watch failed"

    # 假设有一个容器ID和Pod ID
    local container_id="container_id_example"
    local pod_id="pod_id_example"
    crictl stats --id $container_id
    CHECK_RESULT $? 0 0 "crictl stats --id $container_id failed"

    crictl stats --pod $pod_id
    CHECK_RESULT $? 0 0 "crictl stats --pod $pod_id failed"

    crictl stats --label key=value
    CHECK_RESULT $? 0 0 "crictl stats --label key=value failed"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
