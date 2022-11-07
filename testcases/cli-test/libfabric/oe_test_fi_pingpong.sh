source ${OET_PATH}/libs/locallibs/common_lib.sh

# 需要预加载的数据、参数配置 (不需要)
function config_params() {
    LOG_INFO "Start to config params of the case."

    LOG_INFO "No params need to config."

    LOG_INFO "End to config params of the case."
}

# 测试对象、测试需要的工具等安装准备
function pre_test() {

    LOG_INFO "Start environmental preparation."

    dnf -y install libfabric
    P_SSH_CMD --node 3 --cmd "dnf -y install socat"

    LOG_INFO "End of environmental preparation!"
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."


        # 在本地机器上执行命令（如249）
        fi_pingpong -B 47592 -I 1 -S all -c -m msg &
        CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
        # 在远程机器上执行命令 监听249
        echo P_SSH_CMD --node 3 --cmd "fi_pingpong -B 47592 -I 10 -S all -c -m msg ${NODE2_IPV4} "


        # 在本地机器上执行命令（如249）
        fi_pingpong -P 47592 -p -d -e -m msg &
        CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
        # 在远程机器上执行命令 监听249
        echo P_SSH_CMD --node 3 --cmd "fi_pingpong -p verbs -e msg -v -m host  ${NODE2_IPV4} "


        # 在本地机器上执行命令（如249）
        fi_pingpong -P 47592 -p sockets &
        CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
        # 在远程机器上执行命令 监听249
        echo P_SSH_CMD --node 3 --cmd "fi_pingpong -P 47592 -p sockets  ${NODE2_IPV4} "

        # 在本地机器上执行命令（如249）
        fi_pingpong -p sockets &
        CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
        # 在远程机器上执行命令 监听249
        echo P_SSH_CMD --node 3 --cmd "fi_pingpong -p sockets   ${NODE2_IPV4} "

        # 在本地机器上执行命令（如249）
        fi_pingpong -p verbs -e msg -v &
        CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
        # 在远程机器上执行命令 监听249
        echo P_SSH_CMD --node 3 --cmd "fi_pingpong -p verbs -e msg -v host   ${NODE2_IPV4} "

        # 在本地机器上执行命令（如249）
         fi_pingpong -I 10 -S all &
        CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
        # 在远程机器上执行命令 监听249
        echo P_SSH_CMD --node 3 --cmd "fi_pingpong -I 10 -S all  ${NODE2_IPV4} "

        # 在本地机器上执行命令（如249）
         fi_pingpong -I 10 -S all &
        CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
        # 在远程机器上执行命令 监听249
        echo P_SSH_CMD --node 3 --cmd "fi_pingpong -I 10 -S all  ${NODE2_IPV4} "


        # 在本地机器上执行命令（如249）
         fi_pingpong -I 10 -S all -c &
        CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
        # 在远程机器上执行命令 监听249
        echo P_SSH_CMD --node 3 --cmd "fi_pingpong -I 10 -S all  ${NODE2_IPV4} "

        # 在本地机器上执行命令（如249）
        fi_pingpong -I 10 -S all -m msg &
        CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
        # 在远程机器上执行命令 监听249
        echo P_SSH_CMD --node 3 --cmd "fi_pingpong -I 10 -S all -m msg  ${NODE2_IPV4} "

        fi_pingpong -h 2>&1 | grep 'Usage:'
        CHECK_RESULT $? 0 0 "Check fi_pingpong -h failed"

    LOG_INFO "End of the test."
}

# 后置处理，恢复测试环境
function post_test() {

      LOG_INFO "Start to restore the test environment."
      # 将启用的监听端口停止
      P_SSH_CMD --node 3 --cmd "ps -ef | grep libfabric | grep -v grep | awk '{print $2}' | xargs kill -9"

      P_SSH_CMD --node 3 --cmd "dnf -y remove libfabric"

      dnf -y remove libfabric

      LOG_INFO "Finish restoring the test environment."

   }

main $@