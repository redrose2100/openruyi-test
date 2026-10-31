# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2020/05/28
# @License   :   Mulan PSL v2
# @Desc      :   Set password validity
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    # 时钟、login.defs 与测试用户全部落在 NODE2，避免污染 NODE1 的时间与账号。
    # 先记录 NODE2 的绝对时间戳，post_test 用它做绝对回滚（不依赖 date -s '-6 day' 这类相对回退）。
    SSH_CMD "
    cp /etc/login.defs /etc/login.defs-bak
    grep '^test:' /etc/passwd && userdel -rf test || true
    rm -rf /tmp/spv_testlog /tmp/spv_log /run/faillock/test
    date +%s > /tmp/spv_orig_time
    # 没有可用的 ntp 服务时 set-ntp 会返回非 0，不应因此判定用例失败
    timedatectl set-ntp false || true
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Failed to prepare NODE2 for password validity test"
    rm -rf testlog log
    rm -f /root/.ssh/known_hosts
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    SSH_CMD "
    sed -i -E 's/^[[:space:]]*PASS_MAX_DAYS.*/PASS_MAX_DAYS   5/' /etc/login.defs
    sed -i -E 's/^[[:space:]]*PASS_WARN_AGE.*/PASS_WARN_AGE   2/' /etc/login.defs
    useradd test
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Failed to configure login.defs and test user on NODE2"
    SSH_CMD "echo 'test:${NODE2_PASSWORD}' | chpasswd" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Failed to set password for test on NODE2"
    SSH_CMD "date -s '4 day'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Failed to shift NODE2 clock by 4 days"

    expect <<EOF1
        log_file testlog
        set timeout 15
        spawn ssh test@${NODE2_IPV4}
        expect {
               "*yes/no*" {
               send "yes\\r"
               }
        }
        expect {
               "assword:" {
               send "${NODE2_PASSWORD}\\r"
               }
        }
        expect {
               "]" {
               send "exit\\r"
               }
        }
        expect eof
EOF1
    grep 'your password will expire in 1 day' testlog
    CHECK_RESULT $?
    rm -f /root/.ssh/known_hosts
    SSH_CMD "date -s '2 day'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Failed to shift NODE2 clock by 2 more days"
    expect <<EOF1
        set timeout 15
        log_file log
        spawn ssh test@${NODE2_IPV4}
        expect {
               "*yes/no*" {
                send "yes\\r"
                }
        }
        expect {
                "assword:" {
                send "${NODE2_PASSWORD}\\r"
                }
        }
        expect {
                "assword:" {
                send "${NODE2_PASSWORD}\\r"
                }
        }
        expect {
                "assword:" {
                send "Administritor45##\\r"
                }
        }
        expect {
                "assword:" {
                send "Administritor45##\\r"
                }
        }
        expect {
                "]" {
                send "exit\\r"
                }
        }
        expect eof
EOF1
    grep 'Current password' log && grep 'all authentication tokens updated successfully' log
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    # 用绝对时间戳回滚 NODE2 时钟：即使中途 skip/失败，只要 post_test 跑到就不会累积偏移
    SSH_CMD "
    if [ -s /tmp/spv_orig_time ]; then
        date -s \"@\$(cat /tmp/spv_orig_time)\"
    fi
    timedatectl set-ntp true || true
    rm -rf /tmp/spv_testlog /tmp/spv_log /tmp/spv_orig_time /run/faillock/test
    userdel -rf test
    if [ -f /etc/login.defs-bak ]; then
        mv /etc/login.defs-bak /etc/login.defs -f
    fi
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    rm -rf testlog log
    rm -f /root/.ssh/known_hosts
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

