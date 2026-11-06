
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl rmp 命令，包括删除单个 pod 和多个 pod，以及使用 --all 和 --force 选项

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/cri_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    # 创建一些测试用的 pod
    cri_run_pod pod1
    CHECK_RESULT $? 0 0 "Failed to create pod1"
    cri_run_pod pod2
    CHECK_RESULT $? 0 0 "Failed to create pod2"
    cri_run_pod pod3
    CHECK_RESULT $? 0 0 "Failed to create pod3"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试删除单个 pod
    crictl rmp $(crictl pods -q | head -1)
    CHECK_RESULT $? 0 0 "Failed to remove pod1"
    
    # 测试删除多个 pod
    crictl rmp $(crictl pods -q | head -2)
    CHECK_RESULT $? 0 0 "Failed to remove pod2 and pod3"
    
    # 测试使用 --all 选项删除所有 pod
    cri_run_pod pod4
    CHECK_RESULT $? 0 0 "Failed to create pod4"
    cri_run_pod pod5
    CHECK_RESULT $? 0 0 "Failed to create pod5"
    crictl rmp --all
    CHECK_RESULT $? 0 0 "Failed to remove all pods with --all option"
    
    # 测试使用 --force 选项强制删除 pod
    cri_run_pod pod6
    CHECK_RESULT $? 0 0 "Failed to create pod6"
    crictl rmp --force $(crictl pods -q | head -1)
    CHECK_RESULT $? 0 0 "Failed to remove pod6 with --force option"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -rf ./pod-config.json ./container-config.json
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
