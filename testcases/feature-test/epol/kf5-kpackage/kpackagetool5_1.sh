
#!/usr/bin/bash
# 本测试脚本用于测试kf5-kpackage软件包中的kpackagetool5命令，包括其主要参数和功能。

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "kf5-kpackage"
    # 准备测试数据
    mkdir -p ./test_package
    touch ./test_package/test_package.kpackage
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试显示版本信息
    kpackagetool5 --version
    CHECK_RESULT $? 0 0 "failed to display version information"
    
    # 测试显示帮助信息
    kpackagetool5 --help
    CHECK_RESULT $? 0 0 "failed to display help information"
    
    # 测试生成SHA1哈希值
    kpackagetool5 --hash ./test_package/test_package.kpackage
    CHECK_RESULT $? 0 0 "failed to generate SHA1 hash"
    
    # 测试安装包
    kpackagetool5 -i ./test_package/test_package.kpackage
    CHECK_RESULT $? 0 0 "failed to install package"
    
    # 测试显示包信息
    kpackagetool5 -s test_package
    CHECK_RESULT $? 0 0 "failed to show package information"
    
    # 测试升级包
    kpackagetool5 -u ./test_package/test_package.kpackage
    CHECK_RESULT $? 0 0 "failed to upgrade package"
    
    # 测试列出已安装的包
    kpackagetool5 -l
    CHECK_RESULT $? 0 0 "failed to list installed packages"
    
    # 测试列出所有已知的包类型
    kpackagetool5 --list-types
    CHECK_RESULT $? 0 0 "failed to list known package types"
    
    # 测试删除包
    kpackagetool5 -r test_package
    CHECK_RESULT $? 0 0 "failed to remove package"
    
    # 测试生成插件索引
    kpackagetool5 --generate-index -t KPackage/Generic
    CHECK_RESULT $? 0 0 "failed to generate plugin index"
    
    # 测试删除插件索引
    kpackagetool5 --remove-index -t KPackage/Generic
    CHECK_RESULT $? 0 0 "failed to remove plugin index"
    
    # 测试输出包的元数据
    kpackagetool5 --appstream-metainfo ./test_package/test_package.kpackage
    CHECK_RESULT $? 0 0 "failed to output package metadata"
    
    # 测试输出包的元数据到指定路径
    kpackagetool5 --appstream-metainfo-output ./test_package/test_package.metainfo ./test_package/test_package.kpackage
    CHECK_RESULT $? 0 0 "failed to output package metadata to specified path"
    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 卸载安装的软件包
    DNF_REMOVE "kf5-kpackage"
    # 清理测试中间产物文件
    rm -rf ./test_package
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
