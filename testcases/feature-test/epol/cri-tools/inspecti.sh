
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl inspecti 命令，包括不同输出格式和多个镜像ID的情况

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 拉取一个测试镜像
    crictl pull busybox
    # 获取镜像ID
    IMAGE_ID=$(crictl images | grep busybox | awk '{print $3}')
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试默认输出
    crictl inspecti $IMAGE_ID
    CHECK_RESULT $? 0 0 "crictl inspecti failed with default output"
    
    # 测试json输出
    crictl inspecti --output json $IMAGE_ID
    CHECK_RESULT $? 0 0 "crictl inspecti failed with json output"
    
    # 测试yaml输出
    crictl inspecti --output yaml $IMAGE_ID
    CHECK_RESULT $? 0 0 "crictl inspecti failed with yaml output"
    
    # 测试go-template输出
    crictl inspecti --output go-template --template="{{.id}}" $IMAGE_ID
    CHECK_RESULT $? 0 0 "crictl inspecti failed with go-template output"
    
    # 测试多个镜像ID
    crictl inspecti $IMAGE_ID $IMAGE_ID
    CHECK_RESULT $? 0 0 "crictl inspecti failed with multiple image IDs"
    
    # 测试quiet模式
    crictl inspecti --quiet $IMAGE_ID
    CHECK_RESULT $? 0 0 "crictl inspecti failed with quiet mode"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    DNF_REMOVE "cri-tools"
    # 清理测试镜像
    crictl rmi $IMAGE_ID
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
