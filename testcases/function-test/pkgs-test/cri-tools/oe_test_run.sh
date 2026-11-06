
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl run 命令，验证其参数组合和行为

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/cri_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 为每次 run 测试准备不同的容器配置（crictl run 不允许同名容器/沙箱重复创建）
    cri_make_pod_config ./pod-config.json test-pod
    cri_make_container_config ./container-config.json test-container busybox echo hello
    cp ./container-config.json ./container-config-no-pull.json
    cp ./container-config.json ./container-config-with-pull.json
    cp ./container-config.json ./container-config-auth.json
    cp ./container-config.json ./container-config-creds.json
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    crictl run --runtime "runc" ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run command failed"
    # 同名容器/沙箱不能重复创建，删除后再测下一个参数
    crictl rmp -f $(crictl pods -q)
    crictl run --no-pull ./container-config-no-pull.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run --no-pull command failed"
    crictl rmp -f $(crictl pods -q)
    crictl run --with-pull ./container-config-with-pull.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run --with-pull command failed"
    crictl rmp -f $(crictl pods -q)
    crictl run --auth "dXNlcm5hbWU6cGFzc3dvcmQ=" ./container-config-auth.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run --auth command failed"
    crictl rmp -f $(crictl pods -q)
    crictl run --creds "username:password" ./container-config-creds.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run --creds command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "cri-tools"
    rm -f ./container-config*.json ./pod-config.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
