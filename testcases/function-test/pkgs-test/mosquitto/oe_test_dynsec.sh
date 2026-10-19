
#!/usr/bin/bash
# 测试用例描述：测试mosquitto_ctrl dynsec模块的命令

# 测试框架固定行
source "${OET_PATH}/libs/locallibs/common_lib.sh"

# 测试前函数
function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 安装待测试的软件包
    DNF_INSTALL "mosquitto"
    # 启动Mosquitto服务
    systemctl start mosquitto
    # 准备测试数据等,如果要创建文件请使用"./你要创建的文件"直接把文件创建到当前目录下
    mosquitto_ctrl dynsec init ./test_config.conf admin adminpassword
    LOG_INFO "End of environmental preparation!"
}

# 测试函数
function run_test() {
    LOG_INFO "Start to run test."
    # 测试内容,请尽可能详尽的测试命令的参数,如命令的参数组合,命令的参数顺序等
    # 初始化
    mosquitto_ctrl dynsec init ./test_config2.conf admin2 adminpassword2
    CHECK_RESULT $? 0 0 "failed to initialize new config file"

    # 获取ACL默认访问权限
    mosquitto_ctrl dynsec getDefaultACLAccess
    CHECK_RESULT $? 0 0 "failed to get default ACL access"

    # 设置ACL默认访问权限
    mosquitto_ctrl dynsec setDefaultACLAccess publishClientSend allow
    CHECK_RESULT $? 0 0 "failed to set default ACL access"

    # 创建新客户端
    mosquitto_ctrl dynsec createClient testclient -c testclientid -p testpassword
    CHECK_RESULT $? 0 0 "failed to create client"

    # 删除客户端
    mosquitto_ctrl dynsec deleteClient testclient
    CHECK_RESULT $? 0 0 "failed to delete client"

    # 创建新角色
    mosquitto_ctrl dynsec createRole testrole
    CHECK_RESULT $? 0 0 "failed to create role"

    # 删除角色
    mosquitto_ctrl dynsec deleteRole testrole
    CHECK_RESULT $? 0 0 "failed to delete role"

    # 创建新组
    mosquitto_ctrl dynsec createGroup testgroup
    CHECK_RESULT $? 0 0 "failed to create group"

    # 删除组
    mosquitto_ctrl dynsec deleteGroup testgroup
    CHECK_RESULT $? 0 0 "failed to delete group"

    # 列出所有客户端
    mosquitto_ctrl dynsec listClients
    CHECK_RESULT $? 0 0 "failed to list clients"

    # 列出所有角色
    mosquitto_ctrl dynsec listRoles
    CHECK_RESULT $? 0 0 "failed to list roles"

    # 列出所有组
    mosquitto_ctrl dynsec listGroups
    CHECK_RESULT $? 0 0 "failed to list groups"

    LOG_INFO "End of the test."
}

# 测试后函数
function post_test() {
    LOG_INFO "start environment cleanup."
    # 测试后环境恢复：
        # 卸载安装的软件包
        # 清理测试中间产物文件
    systemctl stop mosquitto
    DNF_REMOVE "mosquitto"
    rm -f ./test_config.conf ./test_config2.conf
    LOG_INFO "End of environment cleanup!"
}

# 测试框架固定行
main "$@"
