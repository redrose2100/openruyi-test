
#!/usr/bin/bash
# 测试用例描述：测试 python-dulwich 软件包的基本命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "python-dulwich"
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试查看版本信息
    dulwich --version
    CHECK_RESULT $? 0 0 "failed to get version"
    
    # 测试查看帮助信息
    dulwich --help
    CHECK_RESULT $? 0 0 "failed to get help"
    
    # 测试其他基本命令
    dulwich archive --help
    CHECK_RESULT $? 0 0 "failed to get help for archive"
    
    dulwich branch --help
    CHECK_RESULT $? 0 0 "failed to get help for branch"
    
    dulwich cat-file --help
    CHECK_RESULT $? 0 0 "failed to get help for cat-file"
    
    dulwich check --help
    CHECK_RESULT $? 0 0 "failed to get help for check"
    
    dulwich clone --help
    CHECK_RESULT $? 0 0 "failed to get help for clone"
    
    dulwich commit --help
    CHECK_RESULT $? 0 0 "failed to get help for commit"
    
    dulwich config --help
    CHECK_RESULT $? 0 0 "failed to get help for config"
    
    dulwich describe --help
    CHECK_RESULT $? 0 0 "failed to get help for describe"
    
    dulwich diff --help
    CHECK_RESULT $? 0 0 "failed to get help for diff"
    
    dulwich fetch --help
    CHECK_RESULT $? 0 0 "failed to get help for fetch"
    
    dulwich grep --help
    CHECK_RESULT $? 0 0 "failed to get help for grep"
    
    dulwich init --help
    CHECK_RESULT $? 0 0 "failed to get help for init"
    
    dulwich log --help
    CHECK_RESULT $? 0 0 "failed to get help for log"
    
    dulwich ls-tree --help
    CHECK_RESULT $? 0 0 "failed to get help for ls-tree"
    
    dulwich merge --help
    CHECK_RESULT $? 0 0 "failed to get help for merge"
    
    dulwich mv --help
    CHECK_RESULT $? 0 0 "failed to get help for mv"
    
    dulwich pack-objects --help
    CHECK_RESULT $? 0 0 "failed to get help for pack-objects"
    
    dulwich prune-packed --help
    CHECK_RESULT $? 0 0 "failed to get help for prune-packed"
    
    dulwich pull --help
    CHECK_RESULT $? 0 0 "failed to get help for pull"
    
    dulwich push --help
    CHECK_RESULT $? 0 0 "failed to get help for push"
    
    dulwich reflog --help
    CHECK_RESULT $? 0 0 "failed to get help for reflog"
    
    dulwich remote --help
    CHECK_RESULT $? 0 0 "failed to get help for remote"
    
    dulwich reset --help
    CHECK_RESULT $? 0 0 "failed to get help for reset"
    
    dulwich rev-list --help
    CHECK_RESULT $? 0 0 "failed to get help for rev-list"
    
    dulwich rev-parse --help
    CHECK_RESULT $? 0 0 "failed to get help for rev-parse"
    
    dulwich show --help
    CHECK_RESULT $? 0 0 "failed to get help for show"
    
    dulwich status --help
    CHECK_RESULT $? 0 0 "failed to get help for status"
    
    dulwich tag --help
    CHECK_RESULT $? 0 0 "failed to get help for tag"
    
    dulwich unpack-objects --help
    CHECK_RESULT $? 0 0 "failed to get help for unpack-objects"
    
    dulwich update-ref --help
    CHECK_RESULT $? 0 0 "failed to get help for update-ref"
    
    dulwich update-server-info --help
    CHECK_RESULT $? 0 0 "failed to get help for update-server-info"
    
    dulwich version --help
    CHECK_RESULT $? 0 0 "failed to get help for version"
    
    dulwich web-status --help
    CHECK_RESULT $? 0 0 "failed to get help for web-status"
    
    dulwich worktree --help
    CHECK_RESULT $? 0 0 "failed to get help for worktree"
    
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "python-dulwich"
    # 清理测试中间产物文件
    rm -rf ./testfile
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
