
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

    # 引导 CRI 服务（containerd）：cri-tools 只提供客户端，服务端须自行拉起
    cri_ensure_runtime || cri_abort "CRI runtime (containerd) is not available"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # crictl run --no-pull 要求镜像已在本地，故先显式拉取，避免把 registry 问题
    # 误报成 --no-pull 参数缺陷
    crictl pull busybox:latest
    CHECK_RESULT $? 0 0 "Failed to pull busybox:latest"
    # 为每次 run 测试准备不同的容器配置
    # 注意：CRI 中同一 namespace 下容器名唯一，多次 run 必须用不同容器名，
    # 否则第二次会因同名冲突失败（原实现复用同一 name，属于脚本缺陷）
    cri_make_pod_config ./pod-config.json test-pod
    cri_make_container_config ./container-config.json run-basic busybox:latest
    cri_make_container_config ./container-config-no-pull.json run-no-pull busybox:latest
    cri_make_container_config ./container-config-with-pull.json run-with-pull busybox:latest
    cri_make_container_config ./container-config-auth.json run-auth busybox:latest
    cri_make_container_config ./container-config-creds.json run-creds busybox:latest
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    # sandbox 同样不允许同名重复创建，每次 run 后先清理干净再测下一个参数
    crictl run --runtime "runc" ./container-config.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run command failed"
    crictl rm -f --all >/dev/null 2>&1
    crictl rmp -f --all >/dev/null 2>&1

    crictl run --no-pull ./container-config-no-pull.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run --no-pull command failed"
    crictl rm -f --all >/dev/null 2>&1
    crictl rmp -f --all >/dev/null 2>&1

    crictl run --with-pull ./container-config-with-pull.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run --with-pull command failed"
    crictl rm -f --all >/dev/null 2>&1
    crictl rmp -f --all >/dev/null 2>&1

    # --auth / --creds 只校验参数被命令行识别（镜像已在本地，不触发真实鉴权拉取）
    crictl run --auth "dXNlcm5hbWU6cGFzc3dvcmQ=" ./container-config-auth.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run --auth command failed"
    crictl rm -f --all >/dev/null 2>&1
    crictl rmp -f --all >/dev/null 2>&1

    crictl run --creds "username:password" ./container-config-creds.json ./pod-config.json
    CHECK_RESULT $? 0 0 "crictl run --creds command failed"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 先清理 CRI 对象，再卸载软件包（否则 crictl 已不存在）
    crictl rm -f --all >/dev/null 2>&1
    crictl rmp -f --all >/dev/null 2>&1
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -f ./container-config*.json ./pod-config.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
