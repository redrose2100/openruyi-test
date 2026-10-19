
#!/usr/bin/bash
# 请填写测试用例描述：测试 crictl completion 命令，输出不同 shell 的自动补全代码

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "cri-tools"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试 bash 自动补全代码
    crictl completion bash > ./crictl_bash_completion
    CHECK_RESULT $? 0 0 "Failed to generate bash completion code"
    
    # 测试 zsh 自动补全代码
    crictl completion zsh > ./crictl_zsh_completion
    CHECK_RESULT $? 0 0 "Failed to generate zsh completion code"
    
    # 测试 fish 自动补全代码
    crictl completion fish > ./crictl_fish_completion
    CHECK_RESULT $? 0 0 "Failed to generate fish completion code"
    
    # 测试 --help 参数
    crictl completion --help > ./crictl_completion_help
    CHECK_RESULT $? 0 0 "Failed to generate help information for completion command"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
    # 卸载安装的软件包
    DNF_REMOVE "cri-tools"
    # 清理测试中间产物文件
    rm -f ./crictl_bash_completion ./crictl_zsh_completion ./crictl_fish_completion ./crictl_completion_help
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
