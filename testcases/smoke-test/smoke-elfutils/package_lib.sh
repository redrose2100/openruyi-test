#!/bin/bash

tmp_result=0
flag_remote=0
flag_local=0
testxml="testxml$(date +%N).xml"
set +e
hostinfo=$(get_host_info_and_vm_name "$ETS_REMOTE_IP")
hostip=$(echo "$hostinfo" | awk -F "," '{print $1}')
hostuser=$(echo "$hostinfo" | awk -F "," '{print $2}')
hostpasswd=$(echo "$hostinfo" | awk -F "," '{print $3}')
vmname=$(echo "$hostinfo" | awk -F "," '{print $4}')
hostinfo_local=$(get_host_info_and_vm_name "$ETS_LOCAL_IP")
hostip_local=$(echo "$hostinfo_local" | awk -F "," '{print $1}')
hostuser_local=$(echo "$hostinfo_local" | awk -F "," '{print $2}')
hostpasswd_local=$(echo "$hostinfo_local" | awk -F "," '{print $3}')
vmname_local=$(echo "$hostinfo_local" | awk -F "," '{print $4}')

multi_server_ip='9.82.211.28'
multi_server_pwd='Huawei12#$'
ldap_guest_pwd='ldaptest'
ldap_guest_user='ldaptest'
ldap_olcRootPW='Huawei123'
ldap_RootPW='huawei'
ad_server_ip="9.82.150.150"
ad_server_pwd="huawei12#$"
ad_user_name="aduser"
ad_user_pwd="Huawei12#$"
source_ip="9.82.21.3"
version_iso_ip="10.120.107.75"
PATTERN_IP="[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
PATTERN_ETS_IP="(8|9|96)\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
PATTERN_ETH="^[e|v].+[0-9][:| ]" ## for ifconfig only
PATTERN_IPV6="((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))"
PXE_SERVER="10.175.124.178" ## 9.82.1.253

# ETS任务环境id
[ ! -z "${ETS_ENVID}" ] && ENVID="-e id${ETS_ENVID}"
# 用例编号
TS_NUM="-r $(basename "${0%.sh}")"

###增加执行用例前的yum源信息打印###
cat /etc/yum.repos.d/*.repo

###判断机器为kvm虚拟化xen虚拟化还是物理环境
if type systemd-detect-virt > /dev/null; then
    platform=$(systemd-detect-virt)
elif grep -w hypervisor /proc/cpuinfo; then
    platform="kvm"
else
    platform="none"
fi
if which systemctl > /dev/null; then
    faillock --reset
else
    pam_tally2 -r
fi
if [ -z "${IS_IPV6}" ]; then
    [ -z "${IP_NET}" ] && IP_NET="99.99"
    NET_MASK=16
    IP_POOL_SIZE=30000
else
    [ -z ${IP_NET} ] && IP_NET="99:99"
    NET_MASK=64
    IP_POOL_SIZE=$((65535 * 255))
fi

#################################################################
## @Param 获取全局变量:NODE_IP[@]、NODE_USR[@]、NODE_PWD[@]、NODE_IPV6[@]
## @Usage obtain_ip
## @Return
## @Description 获取所有ip及其相关信息，以数组信息呈现
#################################################################
function obtain_ip() {
    # 机器机数量
    NODE_NUM=$(cat "${ETS_PATH}"/conf/MultiNode.conf | wc -l)

    # 获取机器机IP、user、passwd
    for ((i = 0; i < ${NODE_NUM}; i++)); do
        NODE_IP[i]="$(get_manage_ip_by_nodeid $(($i + 1)))"
        NODE_USR[i]="$(cat "${ETS_PATH}"/conf/MultiNode.conf | awk -F',' '{print $3}' | awk -F'=' '{print $2}' | sed -n $((i + 1))p)"
        NODE_PWD[i]="$(cat "${ETS_PATH}"/conf/MultiNode.conf | awk -F',' '{print $4}' | awk -F'=' '{print $2}' | sed -n $((i + 1))p)"
        NODE_IPV6[i]="$(get_manage_ipv6_by_nodeid $(($i + 1)))"
    done

    ## 判断ip、user、passwd获取是否有误
    if [ "${NODE_NUM}" -ne ${#NODE_IP[@]} ]; then
        ETS_LOG_ERROR "Failed to get machine information.Node IP:${NODE_IP[*]}"
        exit 1
    fi

    # 判断IP的值是否有问题
    for ((i = 0; i < ${#NODE_IP[@]}; i++)); do
        VALID_CHECK=$(echo "${NODE_IP[i]}" | awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
        if echo "${NODE_IP[i]}" | grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" > /dev/null; then
            if [ "${VALID_CHECK:-no}" == "yes" ]; then
                ETS_LOG_DEBUG "IP ${NODE_IP[i]} available."
            else
                ETS_LOG_ERROR "IP ${NODE_IP[i]} not available!"
                exit 1
            fi
        else
            ETS_LOG_ERROR "IP format error!"
            exit 1
        fi
    done

    if [ "${NODE_NUM}" -ne ${#NODE_USR[@]} ]; then
        ETS_LOG_ERROR "Failed to get machine information.Node USR:${NODE_USR[*]}"
        exit 1
    fi

    if [ "${NODE_NUM}" -ne ${#NODE_PWD[@]} ]; then
        ETS_LOG_ERROR "Failed to get machine information.Node PWD:${NODE_PWD[*]}"
        exit 1
    fi

    # 获取本端所使用的网卡名
    local_eht=$(ip a | grep "${NODE_IP[0]}" | awk '{print $NF}')

    # 注释检查机器网络连通性代码，优化package_test下用例执行耗时
    #for ((i = 0; i < ${NODE_NUM}; i++)); do
    #    ping -c3 "${NODE_IP[i]}"
    #    if [ $? -ne 0 ]; then
    #        ETS_LOG_ERROR "the ipv4 of ${NODE_IP[i]} is ERROR,please check it."
    #        #exit 1
    #    fi
    #done
    # 检查ipv6地址的正确性
    #for (( i=0; i<${NODE_NUM}; i++ ))
    #do
    #    ping6 -c3 ${NODE_IPV6[i]}%${local_eht}
    #    if [ $? -ne 0 ];then
    #        ETS_LOG_ERROR "the ipv6 of ${NODE_IP[i]} is ERROR,please check it."
    #        exit 1
    #    fi
    #done
}

###########检测命令是否安装，传入命令名为参数###########
function checkrpminstall() {
    check_param 1
    rpm_name=$1
    which "$rpm_name"
    if [ $? -ne 0 ]; then
        echo "$rpm_name not installed"
        exit 1
    fi
}
##########如果命令无执行权限添加命令执行权限#################
function chmod_add_exec_command() {
    check_param 1
    command=$1
    command_url=$(ls -l /bin/ | grep -w "$command" | grep -v "$command\." | grep -v "$command\-" | grep -v "\-$command" | grep -v "^l")
    if [[ x"$command_url" == x"" ]]; then
        command_url="/sbin/$command"
    else
        command_url="/bin/$command"
    fi
    permission=$(echo "$command_url" | awk '{print $1}' | grep x | wc -l)
    if [[ $permission -eq 0 ]]; then
        chmod +x "$command_url"
        chmod_flag=1
    else
        echo "command already has executable permissions "
    fi
}

#########根据chmod_flag=1标记位恢复命令权限################
function chmod_del_exec_command() {
    check_param 1
    command=$1
    command_url=$(ls -l /bin/ | grep -w "$command" | grep -v "$command\." | grep -v "$command\-" | grep -v "\-$command" | grep -v "^l")
    if [[ "$command_url" == "" ]]; then
        command_url="/sbin/$command"
    else
        command_url="/bin/$command"
    fi

    if [[ $chmod_flag -eq 1 ]]; then
        chmod -x "$command_url"
    fi
}

###########检测文件是否存在，传入文件名为参数###########
##########考虑到部分版本没有rpm命令，因此使用判断文件来判断包是否安装##########
function checkfile() {
    check_param 3
    file1=$1
    file2=$2
    ls "$file1" || ls "$file2" || el_err "$file1,$file2 not exit"
}

###########判断包是否安装，未安装则自动安装，传入包名为参数###########
function rpminstall() {
    check_param 2
    rpm_name=$1
    type=${2-local}
    command_name=${3-$rpm_name}
    if [ "$type" == "local" ]; then
        which "${command_name}" || rpm -q "$rpm_name" && return 0
        yum install -y "$rpm_name" || {
            el_err "yum install $rpm_name fail"
            return 1
        }
    elif [ "$type" == "remote" ]; then
        [ "${NODE_NUM}" == "1" ] && return 1
        for ((i = 1; i < NODE_NUM; i++)); do
            ETS_SSHCMD "which ${command_name} || rpm -q $rpm_name" "${NODE_USR[i]}" "${NODE_PWD[i]}" "${NODE_IP[i]}" > /dev/null && return 0
            ETS_SSHCMD "yum install -y $rpm_name" "${NODE_USR[i]}" "${NODE_PWD[i]}" "${NODE_IP[i]}" > /dev/null || {
                el_err "yum install $rpm_name fail in [${NODE_IP[i]}]"
            }
        done
    fi
}

###########判断包是否安装，已经安装则自动卸载，传入包名为参数###########
function rpmremove() {
    check_param 2
    rpm_name=$1
    type=${2-local}
    if [ "$type" == "local" ]; then
        yum remove -y "$rpm_name" || {
            el_err "yum remove $rpm_name fail"
            return 1
        }
    elif [ "$type" == "remote" ]; then
        for ((i = 1; i < NODE_NUM; i++)); do
            ETS_SSHCMD "yum remove -y $rpm_name" "${NODE_USR[i]}" "${NODE_PWD[i]}" "${NODE_IP[i]}" > /dev/null || {
                el_err "yum remove $rpm_name [${NODE_IP[i]}] fail"
            }
        done
    fi
}

###########判断包是否安装且为oe版本，已经安装且为oe版本的则自动卸载，传入包名为参数###########
function rpmremove_oe() {
    check_param 2
    rpm_name=$1
    type=${2-local}
    if [ "x$type" == "xlocal" ]; then
        if rpm -q "${rpm_name}" | grep oe; then
            rpmremove "${rpm_name}" "${type}"
        fi
    elif [ "x$type" == "xremote" ]; then
        if ETS_SSHCMD "rpm -q ${rpm_name}" | tail -n1 | grep oe; then
            rpmremove "${rpm_name}" "${type}"
        fi
    fi

}

###########检测ko是否存在，传入ko名为参数###########
function checksupport() {
    check_param 1
    mod_name=$1
    modinfo "$mod_name"
    if [ $? -ne 0 ]; then
        echo "$mod_name not support"
        exit 1
    fi
}

###########判断返回结果，传入测试值、预期值、判断模式（0为不等，1为相等，默认为0）、失败打印###########
function checkresult() {
    cur_result=${1}
    expect_result=${2-0}
    mode=${3-0}
    errorlog=${4}
    ETS_LOG_INFO "cur_result:$cur_result----expect_result:$expect_result----mode:$mode"
    if [ "$mode" -eq 0 ]; then
        if [ "${cur_result}x" != "${expect_result}x" ]; then
            ETS_LOG_ERROR "[$0:${FUNCNAME[1]}:${BASH_LINENO[0]}] [CHECKPOINT FAILED] - $errorlog"
            ((tmp_result++))
        fi
    else
        if [ "${cur_result}x" == "${expect_result}x" ]; then
            ETS_LOG_ERROR "[$0:${FUNCNAME[1]}:${BASH_LINENO[0]}] [CHECKPOINT FAILED] - $errorlog"
            ((tmp_result++))
        fi
    fi
}

###########检查rpm版本是否大于指定版本，传入包名，架构，及相关版本ID###########
checkrpmversion() {
    check_param 3
    rpm_name=$1
    rpm_check_version=$2
    arch=$3
    expect_version=$4
    expect_version_p=$5
    expect_version_h=$6
    if which rpm > /dev/null; then
        cur_version=$(rpm -qa | grep -E ^"$rpm_name" | sed "s/$rpm_name-//g" | sed "s/.$arch//g" | cut -d "p" -f 1 | sed 's/[^0-9]//g')
        cur_version_p=$(rpm -qa | grep -E ^"$rpm_name" | sed "s/$rpm_name-//g" | sed "s/.$arch//g" | cut -d "p" -f 2 | cut -d "h" -f 1 | sed 's/[^0-9]//g')
        cur_version_h=$(rpm -qa | grep -E ^"$rpm_name" | sed "s/$rpm_name-//g" | sed "s/.$arch//g" | cut -d "p" -f 2 | cut -d "h" -f 2 | sed 's/[^0-9]//g')
    else
        if [ x"$rpm_check_version" == "xnotsupport" ]; then
            echo "notsupport"
            exit 1
        else
            cur_version=$(echo "$rpm_check_version" | cut -d "p" -f 1 | sed 's/[^0-9]//g')
            cur_version_p=$(echo "$rpm_check_version" | cut -d "p" -f 2 | cut -d "h" -f 1 | sed 's/[^0-9]//g')
            cur_version_h=$(echo "$rpm_check_version" | cut -d "p" -f 2 | cut -d "h" -f 2 | sed 's/[^0-9]//g')
        fi
    fi
    if [ x"$expect_version" != x ]; then
        if [ "$cur_version" -lt "$expect_version" ]; then
            echo "the rpm of this system is too early"
            exit 1
        fi
    fi
    if [ x"$expect_version_p" != x ]; then
        if [ "$cur_version_p" -lt "$expect_version_p" ]; then
            echo "the rpm of this system is too early"
            exit 1
        fi
    fi
    if [ x"$expect_version_h" != x ]; then
        if [ "$cur_version_h" -lt "$expect_version_h" ]; then
            echo "the rpm of this system is too early"
            exit 1
        fi
    fi
}

checkrpmversion_new() {
    check_param 3
    rpm_name=$1
    rpm_check_version=$2
    expect_version=$3
    if which rpm > /dev/null; then
        cur_version=$(rpm -qa | grep -E ^"$rpm_name" | sed "s/$rpm_name-//g" | sed "s/.euleros.*//g" | sed "s/.x86_64//g" | sed 's/[^0-9]//g')
    else
        if [ x"$rpm_check_version" == "xnotsupport" ]; then
            echo "notsupport"
            exit 1
        else
            cur_version=$(echo "$rpm_check_version" | sed 's/[^0-9]//g')
        fi
    fi
    if [ x"$expect_version" != x ]; then
        if [[ "$cur_version" < "$expect_version" ]]; then
            echo "the rpm of this system is too early"
            return 1
        fi
    fi
}
###########检查服务是否存在D/Z状态进程，服务ID是否包含传入ID###########
function checkservice() {
    check_param 2
    service_name=$1
    service_pid=$2
    mainpid=$(pidof -x "$service_name")
    if [ "${service_pid}" != "" ]; then
        echo "$mainpid" | grep "$service_pid"
        if [ $? != 0 ]; then
            return 1
        fi
        checkpid "$service_pid"
        childpid=$(ps -ef | awk 'NR>1{print$2$3}' | grep -E "$service_pid" | awk -F "$service_pid" '{print$1}')
        if [ "${childpid}x" != "x" ]; then
            for pid in $childpid; do
                if [ "${pid}x" != "x" ]; then
                    checkpid "$pid"
                fi
            done
        fi
    fi
}

###########检查服务子函数###########
function checkpid() {
    ls "/proc/$1/status" && {
        grep "State:.*D" "/proc/$1/status" && el_err "$1 is D status"
        grep "State:.*Z" "/proc/$1/status" && el_err "$1 is Z status"
    }
}

##########服务操作类函数，可以通过传入服务名与操作命令自动匹配操作指令，兼容suse/redhat##############
function fn_service() {
    check_param 2
    service_name=$1
    operation=$2
    type=${3-"local"}
    remote_cmd_username=$4
    remote_cmd_password=$5
    remote_cmd_ip=$6
    if [ "$type" == "local" ]; then
        systemctl "$operation" "$service_name"
    elif [ "$type" == "remote" ]; then
        ETS_SSHCMD "systemctl $operation $service_name" "$remote_cmd_username" "$remote_cmd_password" "$remote_cmd_ip"
    fi
}
function fn_service_new() {
    check_param 3
    service_name1=$1
    service_name2=$2
    operation=$3
    type=${4-"local"}
    remote_cmd_username=$5
    remote_cmd_password=$6
    remote_cmd_ip=$7
    if [ "$type" == "local" ]; then
        systemctl "$operation" "$service_name1"
    elif [ "$type" == "remote" ]; then
        ETS_SSHCMD "systemctl $operation $service_name1" "$remote_cmd_username" "$remote_cmd_password" "$remote_cmd_ip"
    fi
}

##########检查ipmi服务状态、内核模块、进程状态等##############
function checkipmi_base() {
    fn_service ipmi status | grep "active (exited)"
    checkresult $?
    lsmod | grep -E ipmi_si && lsmod | grep -E ipmi_devintf && lsmod | grep -E ipmi_msghandler
    checkresult $?
    if version_compare "$ETS_VERSION" "<" "V200R008C00"; then
        dmidecode | grep -i bt || cat /proc/ipmi/0/si_stats | grep "interrupts_enabled.*1"
        if [ $? -ne 0 ]; then
            ps -aux | grep kipmi | grep -v grep
            checkresult $?
        fi
    fi
}

check_param() {
    local i=
    for ((i = 0; i < $1; i++)); do
        if [ "$i"x = x ]; then
            el_err "some parameter are null"
            exit 1
        fi
    done
}

###########删除文件########################
function rmfile() {
    if [ -f "$1" ]; then
        rm -f "$1"
    fi
}

###########按照指定正则表达式分割文件，传入待分割文件，分割后文件和正则表达式####################
function format() {
    check_param 3
    file=$1
    result=$2
    regex=$2
    file_start=1
    file_end=$(wc -l < "${file}")
    num=$(grep -ancE "^$" "${file}")
    lines=$(grep -a -n -e "^$" "${file}" | awk -F : '{print $1}')
    if [ "${file_end}" -eq 0 ]; then
        echo "test file is null"
        return 1
    fi
    lines=(${lines[@]} ${file_end})
    start_line=${lines[0]}
    for ((i = 1; i <= num; i++)); do
        tmp=${lines[i]}
        end_line=$(expr "${tmp}" - 1)
        sed -n "${start_line},${end_line}p" "${file}" > "${result}"$i
        start_line=$tmp
    done
}

function add_normal_user() {
    username=$1
    ETS_SSHCMD "useradd -m $username"
    ETS_SSHCMD "echo $2 | passwd $1 --stdin" || el_err "set passwd failed for $username"
    ETS_SSHCMD "usermod -G wheel ${username}"
    ETS_SSHCMD "cp /etc/sudoers /etc/sudoers.bak"
    ETS_SSHCMD "chmod +w /etc/sudoers"
    ETS_SSHCMD "sed -i 's/# *%wheel/ %wheel/g' /etc/sudoers"
}

##############获取未使用的bond号，随机分配#################
function getunusedbond() {
    check_param 1
    type=$1
    random=$((RANDOM % 99 + 1))
    bondname="bond${random}"
    while true; do
        if [ "$type" == local ]; then
            ifconfig $bondname > /dev/null || break
            random=$((RANDOM % 99 + 1))
            bondname="bond${random}"
        elif [ "$type" == remote ]; then
            ETS_SSHCMD "ifconfig $bondname" > /dev/null || break
            random=$((RANDOM % 99 + 1))
            bondname="bond${random}"
        fi
    done
    echo $bondname
}

##############插入内核模块，传参为模块名################
function fn_modprobe_ko() {
    check_param 2
    type=$2
    modname=$1
    modname_1=$(echo "$modname" | awk '{print $1}')
    if [ x"$type" == xlocal ]; then
        if lsmod | grep ^"${modname_1}"; then
            echo "${modname_1} has insmod"
        else
            eval modprobe "$modname"
            checkresult $?
            flag_local=1
        fi
    elif [ x"$type" == xremote ]; then
        if ETS_SSHCMD "lsmod" | grep ^"${modname_1}"; then
            echo "${modname_1} has insmod"
        else
            ETS_SSHCMD "modprobe $1"
            checkresult $?
            flag_remote=1
        fi
    fi
}

##############拔出内核模块，传参为模块名################
function fn_rmmod_ko() {
    check_param 2
    type=$2
    modname=$1
    if [ x"$type" == xlocal ]; then
        if [ $flag_local -eq 1 ]; then
            rmmod "$modname"
        else
            echo "$modname don't need rmmod"
        fi
    elif [ x"$type" == xremote ]; then
        if [ $flag_remote -eq 1 ]; then
            ETS_SSHCMD "rmmod $modname"
        else
            echo "$modname don't need rmmod"
        fi
    fi
}

##############获取当前主网卡################
function get_eth_main() {
    check_param 1
    type=$1
    if [ x"$type" == xlocal ]; then
        eth_main_name=$(ip a | grep "$ETS_LOCAL_IP" | awk '{print $NF}')
    elif [ x"$type" == xremote ]; then
        eth_main_name=$(ETS_SSHCMD "ip a" | grep "$ETS_REMOTE_IP" | tail -1 | awk '{print $NF}' | sed 's/\r//')
    fi
    echo "$eth_main_name"
}

##############获取所有网卡################
function get_eth_list() {
    check_param 2
    mode=$1
    type=$2
    grep_items="docker\|bond\|br\|lo\|vrf"
    if [ x"$type" == xlocal ]; then
        eth_all=$(ls /sys/class/net | grep -v $grep_items)
        eth_all=$(echo "$eth_all")
        eth_all_cmd="ls /sys/class/net"
        for eth in ${eth_all}; do
            ifconfig "$eth" up
            sleep 1
            cat /sys/class/net/"$eth"/speed > /dev/null
            ret_speed=$?
            netstatus=$(ethtool "${eth}" | grep "Link detected" | awk -F: '{print $2}')
            if [[ "$netstatus" = " no" ]] || [[ "$netstatus" = "" ]]; then
                grep_items="$grep_items\|${eth}"
            fi
        done
        upeth_all="$($eth_all_cmd | grep -v "$grep_items")"
        #upeth_all=`echo $upeth_all`
    elif [ "x$type" == "xremote" ]; then
        eth_all=$(ETS_SSHCMD "ls /sys/class/net" | grep -v "$grep_items" | grep -v " " | sed 's/\r//')
        eth_all_cmd="ls /sys/class/net"
        for eth in ${eth_all}; do
            ETS_SSHCMD "ifconfig $eth up;sleep 1" > /dev/null
            netstatus=$(ETS_SSHCMD "ethtool ${eth}" | grep "Link detected" | awk -F: '{print $2}' | sed 's/\r//')
            ETS_SSHCMD "cat /sys/class/net/$eth/speed" > /dev/null
            ret_speed=$?
            if [[ "$netstatus" = " no" ]] || [[ "$netstatus" = "" ]]; then
                grep_items="$grep_items\|${eth}"
            fi
        done
        upeth_all="$(ETS_SSHCMD "$eth_all_cmd" | grep -v " " | sed 's/\r//' | grep -v "$grep_items")"
        #upeth_all=`echo $upeth_all`
    fi
    if [ "x$mode" == "xall" ]; then
        echo "$upeth_all"
    elif [ "x$mode" == "xunused" ]; then
        used_eth=$(get_eth_main "$type")
        for tmp_eth in $upeth_all; do
            ifconfig "${tmp_eth}" | grep -qw "${PATTERN_IP}" && continue
            if [ "x$tmp_eth" != "x$used_eth" ]; then
                if [ "x$upeth_unsed" == "x" ]; then
                    upeth_unsed="$tmp_eth"
                else
                    upeth_unsed="$upeth_unsed $tmp_eth"
                fi
            fi
        done
        echo "$upeth_unsed"
    fi
}

##############获取所有磁盘################
function get_disk_list() {
    check_param 2
    mode=$1
    type=$2
    if [ "x$type" == "xlocal" ]; then
        for tmp_disk in $(fdisk -l | grep "Disk.*/dev/" | grep -v mapper | awk -F ":" '{print $1}' | awk '{print $2}'); do
            if ! df -hl | grep "$tmp_disk" > /dev/null; then
                if [ "x$unused_disk" == "x" ]; then
                    unused_disk="$tmp_disk"
                else
                    unused_disk="$unused_disk $tmp_disk"
                fi
            else
                if [ "x$used_disk" == "x" ]; then
                    used_disk="$tmp_disk"
                else
                    used_disk="$used_disk $tmp_disk"
                fi
            fi
        done
    elif [ "x$type" == "xremote" ]; then
        for tmp_disk in $(ETS_SSHCMD "fdisk -l" | grep "Disk.*/dev/" | grep -v mapper | awk -F ":" '{print $1}' | awk '{print $2}'); do
            if ! df -hl | grep "$tmp_disk" > /dev/null; then
                if [ "x$unused_disk" == "x" ]; then
                    unused_disk="$tmp_disk"
                else
                    unused_disk="$unused_disk $tmp_disk"
                fi
            else
                if [ "x$used_disk" == "x" ]; then
                    used_disk="$tmp_disk"
                else
                    used_disk="$used_disk $tmp_disk"
                fi
            fi
        done
    fi
    if [ "x$mode" == "xused" ]; then
        echo "$used_disk"
    elif [ "x$mode" == "xunused" ]; then
        echo "$unused_disk"
    fi
}

# 检查空闲网卡数量，若数据不足则自动添加网卡(仅虚拟机)
# 空闲网卡数量足够或添加网卡成功成功0，不足且添加失败返回1
# input: 参数1 初始网卡数，参数2 要使用的空闲网卡数量 , 参数3 local|remote 本端，对端
# default: 参数1 1 ，参数2 1，参数3 local
check_netcard_num() {
    local eth_num=${1:-1}
    local need_num=${2:-1}
    local m_type=${3:-local}
    local m_vmname="$vmname_local"
    local m_hostuser="$hostuser_local"
    local m_hostpasswd="$hostpasswd_local"
    local m_hostip="$hostip_local"
    local m_testdir="/home/add_netcard"
    if [ "$m_type" != "local" ]; then
        m_vmname="$vmname"
        m_hostuser="$hostuser"
        m_hostpasswd="$hostpasswd"
        m_hostip="$hostip"
    fi
    # 空闲网卡不足时，自动添加网卡(虚拟机)
    if [ "$eth_num" -lt "$need_num" ]; then
        if [ x$platform == xnone ]; then
            echo "no more eth device satisfy the required"
            return 1
        else
            for ((num = $eth_num; num < $need_num; num++)); do
                if [ "x$platform" == "xkvm" ] || [ "x$platform" == "xqemu" ]; then
                    ETS_SSHCMD "virsh attach-interface $m_vmname bridge br0 --model virtio" "$m_hostuser" "$m_hostpasswd" "$m_hostip"
                    checkresult $?
                elif [ "x$platform" == "xxen" ]; then
                    fn_add_testxml "network" "$((num + 1))"
                    checkresult $?
                    ETS_SSHCMD "rm -fr $m_testdir;mkdir -p $m_testdir;cd $m_testdir" "$m_hostuser" "$m_hostpasswd" "$m_hostip"
                    checkresult $?
                    ETS_SSHSCP ./"$testxml" "${m_hostuser}"@"${m_hostip}":$m_testdir "${m_hostpasswd}"
                    checkresult $?
                    ETS_SSHCMD "virsh attach-device $m_vmname \"$m_testdir/$testxml\"" "$m_hostuser" "$m_hostpasswd" "$m_hostip"
                    checkresult $?
                fi
                if [ "$m_type" == "local" ]; then
                    testmac_local[$num]=$(ETS_SSHCMD "virsh domiflist $m_vmname" "$m_hostuser" "$m_hostpasswd" "$m_hostip" | sed 's/\r//' | awk '{print $5}' | grep "^." | tail -1)
                else
                    testmac_remote[$num]=$(ETS_SSHCMD "virsh domiflist $m_vmname" "$m_hostuser" "$m_hostpasswd" "$m_hostip" | sed 's/\r//' | awk '{print $5}' | grep "^." | tail -1)
                fi
            done
        fi
    fi
    return 0
}

# 与 check_netcard_num 成对使用，用于还原环境中的网卡
# 还原成功返回0 失败返卸载网失败的数量
# input: 参数1 初始空闲网卡数
#        参数2 需要还原的网卡数，最好与使用check_netcard_num时增加的网卡数量一致
#        参数3 local|remote 本端，对端
# default: 参数1 1 , 参数2 1 参数3 local
restore_netcard() {
    local eth_num=${1:-1}
    # 用例需要使用的网卡数量
    local need_num=${2:-1}
    local m_type=${3:-local}
    local restore_ret=0
    local m_testdir="/home/add_netcard"
    for ((i = $eth_num; i < $need_num; i++)); do
        if [ "$m_type" == "local" ]; then
            ETS_SSHCMD "virsh detach-interface $vmname_local bridge --mac ${testmac_local[$i]}" "$hostuser_local" "$hostpasswd_local" "$hostip_local"
            if [ $? -ne 0 ]; then
                ((restore_ret++))
            fi
        else
            ETS_SSHCMD "virsh detach-interface $vmname bridge --mac ${testmac_remote[$i]}" "$hostuser" "$hostpasswd" "$hostip"
            if [ $? -ne 0 ]; then
                ((restore_ret++))
            fi
        fi
    done
    if [ $restore_ret -eq 0 ]; then
        ETS_SSHCMD "rm -rf $m_testdir"
    fi
    return $restore_ret
}

# 获取存储着当前版本的iso或tar包地址的文件的地址
# 成功返回0 ，失败返回1
# input: 参数1 想要获取的文件类型(iso或tar)
# default: 参数1 iso
fn_get_iso_file_path() {
    local file_type=${1:-"iso"}
    local file_tail="_iso"
    local file_path=""
    if [ "$file_type" != "iso" ]; then
        file_tail=""
    fi
    if [ "$(arch)" == "x86_64" ]; then
        if echo "$ETS_PRODUCT_VERSION" | grep "V200R003"; then
            file_path=${v2r3_storage_x86_release}${file_tail}
        elif echo "$ETS_PRODUCT_VERSION" | grep "V200R005"; then
            file_path=${v2r5_standard_release}${file_tail}
        elif echo "$ETS_PRODUCT_VERSION" | grep "V200R007C00SPC5"; then
            file_path=${v2r7_standard_release}${file_tail}
        elif echo "$ETS_PRODUCT_VERSION" | grep "V200R007"; then
            file_path=${v2r7_7_5_standard_release}${file_tail}
        fi
    else
        if echo "$ETS_PRODUCT_VERSION" | grep "V200R003"; then
            file_path=${v2r3_storage_arm64_release}${file_tail}
        elif echo "$ETS_PRODUCT_VERSION" | grep "V200R005"; then
            file_path=${v2r5_ARM64_release}${file_tail}
        elif echo "$ETS_PRODUCT_VERSION" | grep "V200R007" | grep -v "SPC5"; then
            file_path=${v2r7_ARM64_release}${file_tail}
        elif echo "$ETS_PRODUCT_VERSION" | grep "V200R008"; then
            file_path=${v2r8c00_ARM64_release}${file_tail}
        fi
    fi

    if [ "$file_path" == "" ]; then
        echo "not support"
        return 1
    else
        echo "$file_path"
        return 0
    fi
}

##########################################################################
## @Param disktype:硬盘类型["virtio","scis"] diskimg:写入xml的img路径 xmlname:要生成的xml名字
## @Usage fn_add_diskxml disktype diskimg xmlname
## @Return
## @Description 生成硬盘xml
##########################################################################
fn_add_diskxml() {
    disktype=$1
    diskimg=$2
    devAttr="name='qemu' type='raw' cache='none' io='native'"
    if [ "$disktype" == "virtio" ]; then
        devName="vdi"
        if [ "x$platform" == "xxen" ]; then
            devName="xvdi"
            disktype="xen"
            devAttr="name='tap2' type='raw' o_persistent='off' io_multiring='off' io_indirect='off'"
        fi
        echo "create $3"
        (
            echo "<disk type='file' device='disk'>"
            echo "<driver $devAttr/>"
            echo "<source file='$diskimg'/>"
            echo "<target dev='$devName' bus='$disktype'/>"
            echo "</disk>"
        ) > ./"$3"
    else
        devName="sdi"
        if [ "x$platform" == "xxen" ]; then
            devName="xsdi"
            devAttr="name='tap2' type='raw' o_persistent='off' io_multiring='off' io_indirect='off'"
        fi
        echo "create $3"
        (
            echo "<disk type='file' device='disk'>"
            echo "<driver $devAttr/>"
            echo "<source file='$diskimg'/>"
            echo "<target dev='$devName' bus='$disktype'/>"
            echo "</disk>"
        ) > ./"$3"
    fi
    chmod 755 ./"$3"
    if ls ./"$3"; then
        return 0
    else
        return 1
    fi
}

##############热插拔磁盘和网卡xml建立，自动识别kvm和xen，kvm网卡热插拔不使用该方法，可查看udev SCEN 003用例################

fn_add_testxml() {
    check_param 1
    type=$1
    eth_model=${3-virtio}
    static_mac=$4
    testxml="${5:-${testxml}}"
    if [ "x$platform" == "xkvm" ]; then
        if [ "x$type" == "xdisk" ]; then
            diskid="vdi"
            echo "create $testxml"
            (
                echo "<disk type='file' device='disk'>"
                echo "<driver name='qemu' type='raw' cache='none' io='native'/>"
                echo "<source file='$2'/>"
                echo "<target dev='$diskid' bus='virtio'/>"
                echo "</disk>"
            ) > ./"$testxml"
        fi
    elif [ "x$platform" == "xxen" ]; then
        if [ "x$type" == "xdisk" ]; then
            diskid="xvdi"
            echo "create $testxml"
            (
                echo "<disk type='file' device='disk'>"
                echo "<driver name='tap2' type='raw' io_persistent='off' io_multiring='off' io_indirect='off'/>"
                echo "<source file='$2'/>"
                echo "<target dev='$diskid' bus='xen'/>"
                echo "</disk>"
            ) > ./"$testxml"
        elif [ "x$type" == "xnetwork" ]; then
            if [ x"$static_mac" == x ]; then
                echo "create $testxml"
                (
                    echo "<interface type='bridge'>"
                    echo "<vif pci='$2'/>"
                    echo "<source bridge='br0'/>"
                    echo "<script path='/etc/xen/scripts/vif-bridge'/>"
                    echo "</interface>"
                ) > ./"$testxml"
            else
                echo "create $testxml"
                (
                    echo "<interface type='bridge'>"
                    echo "<mac address='$static_mac'/>"
                    echo "<vif pci='$2'/>"
                    echo "<source bridge='br0'/>"
                    echo "<script path='/etc/xen/scripts/vif-bridge'/>"
                    echo "</interface>"
                ) > ./"$testxml"
            fi
        fi
    else
        if [ "x$type" == "xdisk" ]; then
            diskid="vdi"
            echo "create $testxml"
            (
                echo "<disk type='file' device='disk'>"
                echo "<driver name='qemu' type='raw' cache='none' io='native'/>"
                echo "<source file='$2'/>"
                echo "<target dev='$diskid' bus='virtio'/>"
                echo "</disk>"
            ) > ./"$testxml"
        fi
    fi

    chmod 755 ./"$testxml"
    if ls ./"$testxml"; then
        return 0
    else
        return 1
    fi
}
function check_log() {
    local message_name="$1"
    local key_word="$2"
    local message_raw_limit="$3"
    if [ -z "$message_name" -o ! -f "${message_name}" ]; then
        echo "parement error or $message_name not exist。"
        return 1
    fi

    grep -E "${key_word}" "${message_name}"
    if [ "$?" = "0" ]; then
        echo "check ${key_word} error."
        return 1
    fi
    message_raw=$(wc -l "$message_name" | awk '{print $1}')
    if [ "$message_raw" -gt "$message_raw_limit" ]; then
        echo "check ${message_raw_limit} error."
        return 1
    fi
    return 0
}

#################################################################
## @Param
## @Usage turn_off_security_services
## @Return
## @Description turn off security services
#################################################################
function turn_off_security_services() {
    for ((i = 0; i < ${NODE_NUM}; i++)); do
        ETS_SSHCMD "
        # 清除iptables的规则
        whereis iptables | grep -i '/usr/sbin/iptables'
        if \[ \$? -eq 0 \];then
            iptables -F
        fi

        # 关闭firewalld服务
        whereis firewalld | grep -i '/usr/sbin/firewalld'
        if \[ \$? -eq 0 \];then
            systemctl stop firewalld.service
        fi

        # Selinux开启状态下openldap-servers安装会报错
        whereis setenforce | grep -i '/usr/sbin/setenforce'
        if \[ \$? -eq 0 \];then
            sestatus | grep enabled
            if \[ \$? -eq 0 \];then
                setenforce 0
            fi
        fi
        " "${NODE_USR[i]}" "${NODE_PWD[i]}" "${NODE_IP[i]}"
        if [ $? -ne 0 ]; then
            ETS_LOG_ERROR "Failed to turn off security services.Failed address:${NODE_IP[i]}"
            exit 1
        fi
    done
}

#################################################################
## @Param
## @Usage ssh_timeout
## @Return
## @Description Modify ssh connection timeout
#################################################################
function ssh_timeout() {
    for ((i = 0; i < ${NODE_NUM}; i++)); do
        ETS_SSHCMD "
        sed -i 's/^ClientAliveInterval.*/ClientAliveInterval 0/g' /etc/ssh/sshd_config
        sed -i 's/^ClientAliveCountMax.*/ClientAliveCountMax 9999/g' /etc/ssh/sshd_config
        sed -i '/export TMOUT/d' /etc/profile
        sed -i 's/#MaxSessions.*/MaxSessions 1000/g' /etc/ssh/sshd_config
        source /etc/profile
        systemctl restart sshd.service
        " "${NODE_USR[i]}" "${NODE_PWD[i]}" "${NODE_IP[i]}"
        if [ $? -ne 0 ]; then
            ETS_LOG_ERROR "Failed to set the ssh timeout.Failed address:${NODE_IP[i]}"
            exit 1
        fi
    done
}

#################################################################
## @Param
## @Usage syn_time
## @Return
## @Description 同步服务器时间
#################################################################
function syn_time() {
    if [ ! "$(which ntpd)" ]; then
        yum install -y ntp
    fi
    grep -i 'server 127.127.1.0' /etc/ntp.conf || echo -e "server 127.127.1.0" >> /etc/ntp.conf
    grep -i 'fudge 127.127.1.0 startum 8' /etc/ntp.conf || echo 'fudge 127.127.1.0 startum 8' >> /etc/ntp.conf
    systemctl restart ntpd

    for ((i = 1; i < ${#NODE_IP[@]}; i++)); do
        ETS_SSHCMD "
    yum install -y ntp
        ntpdate ${NODE_IP[0]}
        " "${NODE_USR[i]}" "${NODE_PWD[i]}" "${NODE_IP[i]}"
    done
}

#################################################################
## @Param
## @Usage ssh_sessions_modify
## @Return
## @Description 修改ssh连接的最大连接、鉴权的数量
#################################################################
function ssh_sessions_modify() {
    # 修改ssh的配置
    for ((i = 0; i < ${NODE_NUM}; i++)); do
        ETS_SSHCMD "
        sed -i '/MaxSessions/d' /etc/ssh/sshd_config
        sed -i '/MaxAuthTries/d' /etc/ssh/sshd_config
        sed -i '/MaxStartups/d' /etc/ssh/sshd_config
        echo -e 'MaxSessions 1000' >> /etc/ssh/sshd_config
        echo -e 'MaxAuthTries 100' >> /etc/ssh/sshd_config
        echo -e 'MaxStartups 1000' >> /etc/ssh/sshd_config
        systemctl restart sshd
        " "${NODE_USR[i]}" "${NODE_PWD[i]}" "${NODE_IP[i]}"
    done
}

#################################################################
## @Param
## @Usage VerDiffTest
## @Return
## @Description 版本差异性测试通用函数
#################################################################
function VerDiffTest() {
    # 参数判断
    if [ -z "$1" ]; then
        log_error "Missing parameters about pkg'name!!!"
    else
        pkg_name=$1
    fi

    # 删除结果文件
    rm -rf "${pkg_name}"_failure_result failure_result

    # 获取命令存放文件
    cmd_files="$(find -name '*_command' | grep -o '[a-zA-Z0-9.+_-]\+_command')"

    # 遍历出命令存放的文件
    for cmd_file in ${cmd_files}; do
        # 读取文件中的命令
        while read line; do
            # 到远端执行命令
            ETS_SSHCMD "$line" "${NODE_USR[1]}" "${NODE_PWD[1]}" "${NODE_IP[1]}"
            # 获取命令执行返回结果
            res_tmp=$?
            [ "$res_tmp" -eq 0 ] && continue
            # 差异结果输出到文件中，进行保存
            cmd=$(echo "$cmd_file" | sed 's/_command//g')
            fail_cmd=$(cat "$cmd_file" | sed 's/||.*//g;s/| *grep .*//g' | sed -n "${res_tmp}p" | grep -i -o "$cmd \(-\{0,2\}[a-z0-9-]\+.*\)\+")
            [ -n "$fail_cmd" ] && echo -e "$fail_cmd" >> failure_result || echo -e "$line" >> failure_result
        done < "$cmd_file"
        expect_eq $? 0
    done
    expect_eq $? 0

    # 去重失败结果中重复部分
    if [ -f failure_result ]; then
        sort failure_result | uniq > "${pkg_name}"_failure_result
        rm -rf failure_result
    fi

    # 查找是否存在差异结果（打印出错命令，方便调试）
    test -s "${pkg_name}"_failure_result && cat "${pkg_name}"_failure_result
    expect_eq $? 1 || return 1
}

#################################################################
## @Param
## @Usage VerDiffTest_callvar
## @Return
## @Description 版本差异性测试通用函数:命令文件中存在变量
#################################################################
function VerDiffTest_callvar() {
    # 参数判断
    if [ -z "$1" ]; then
        log_error "Missing parameters about pkg'name!!!"
    else
        pkg_name=$1
    fi

    # 删除结果文件
    rm -rf "${pkg_name}"_failure_result

    # 获取命令存放文件,增加sort,解决命令随机执行导致用例概率失败的问题
    cmd_files="$(find -name '*_command' | grep -o '[a-zA-Z0-9._+-]\+_command' | sort)"

    # 获取变量
    filename=$(basename "$0")
    var_tmp=$(cat "$filename" | grep -o '^[a-zA-Z0-9_]\+=.*' | awk -F '=' '{print $1}')
    for i in ${var_tmp}; do
        tmp_var=$(set | grep -w -o "${i}=.*")
        local_var="$tmp_var $local_var"
    done

    # 遍历出命令存放的文件
    for cmd_file in ${cmd_files}; do
        ETS_SSHSCP "$(pwd)"/"$cmd_file" "${NODE_USR[1]}"@"${NODE_IP[1]}":~ "${NODE_PWD[1]}"
        expect_eq $? 0

        ETS_SSHCMD "${local_var}; source ./$cmd_file; echo \${re_tmp} > /root/fail_re" "${NODE_USR[1]}" "${NODE_PWD[1]}" "${NODE_IP[1]}"
        expect_eq $? 0

        ETS_SSHSCP "${NODE_USR[1]}"@"${NODE_IP[1]}":/root/fail_re "$(pwd)" "${NODE_PWD[1]}"
        expect_eq $? 0

        re_tmp=$(cat fail_re)
        cmd=$(echo "$cmd_file" | sed 's/_command//g')
        for res_tmp in ${re_tmp}; do
            #此句解决一个failure_result返回空的BUG
            res_tmp=$(echo "$res_tmp" | tr '\r' ' ')
            fail_cmd=$(cat "$cmd_file" | sed 's/||.*//g;s/| *grep .*//g' | sed -n "${res_tmp}p")
            echo -e "$fail_cmd" >> failure_result
        done
        expect_eq $? 0
    done
    expect_eq $? 0

    # 去重失败结果中重复部分
    if [ -f failure_result ]; then
        sort failure_result | uniq > "${pkg_name}"_failure_result
    fi

    ETS_SSHCMD "rm -rf fail_re failure_result *_command" "${NODE_USR[1]}" "${NODE_PWD[1]}" "${NODE_IP[1]}"
    rm -rf fail_re failure_result

    # 查找是否存在差异结果（打印出错命令，方便调试）
    test -s "${pkg_name}"_failure_result && cat "${pkg_name}"_failure_result
    expect_eq $? 1 || return 1
}

#################################################################
## @Param
## @Usage $(check_ipv6 | grep 'IPV6   ' | awk '{print $2}')
## @Return ipv6_address
## @Description 检查ipv6地址是否可以，如果不可以则替换ipv6地址
##              默认网关：2019:2021::1
#################################################################
function check_ipv6() {
    NET_MASK=64
    echo -n 'IPV6   '
    find_unused_ip_by 2019:2021
}

#################################################################
## @Param $1:rpm name $2:install flag name
## @Usage check_rpm_install ipmitool rpm_ipmitool_flag
## @Return
## @Description 检查rpm包是否安装，未安装时进行安装并将安装标记置1
#################################################################
function check_rpm_install() {
    local rpm_name=$1
    local install_flag_name=${2-rpm_flag}

    eval "${install_flag_name}"=0
    rpm -q "$rpm_name"
    if [ $? -ne 0 ]; then
        rpminstall "$rpm_name"
        eval "${install_flag_name}"=1
    fi
}

#################################################################
## @Param $1:rpm name $2:install flag value
## @Usage check_rpm_remove ipmitool $rpm_ipmitool_flag
## @Return
## @Description 当rpm包的安装标记置1时进行卸载，用于恢复环境
#################################################################
function check_rpm_remove() {
    local rpm_name=$1
    local install_flag=${2-$rpm_flag}

    if [ "$install_flag" -eq 1 ]; then
        rpmremove "$rpm_name"
    fi
}

#################################################################
## @Param $1:service name $2:service status flag name
## @Usage check_service_active ipmi service_ipmi_flag
## @Return
## @Description 检查服务是否启动，未启动时启动服务并将状态标记置1
#################################################################
function check_service_active() {
    local service_name=$1
    local status_flag_name=${2-service_flag}

    eval "${status_flag_name}"=0
    fn_service "$service_name" status
    if [ $? -ne 0 ]; then
        fn_service "$service_name" restart
        eval "${status_flag_name}"=1
    fi
}

#################################################################
## @Param $1:service name $2:service status flag value
## @Usage check_service_stop ipmi $service_ipmi_flag
## @Return
## @Description 当服务的状态标记置1时停止服务，用于恢复环境
#################################################################
function check_service_stop() {
    local service_name=$1
    local status_flag=${2-$service_flag}

    if [ "$status_flag" -eq 1 ]; then
        fn_service "$service_name" stop
    fi
}

##############必执行函数集合################
function main() {
    obtain_ip
}

main "$@"
##############local remote环境添加网卡######################
function eth_add_remote() {
    local eth_need_remote=$1
    #get the Ethernet device name from remote
    eth_unused_list_remote=$(get_eth_list unused remote)
    eth_num_remote=$(echo "$eth_unused_list_remote" | awk '{print NF}')
    if [ "$eth_num_remote" -lt "$eth_need_remote" ]; then
        if [ x$platform == xnone ]; then
            echo "no more eth device satisfy the required"
            exit 1
        else
            for ((num = $eth_num_remote; num < $eth_need_remote; num++)); do
                if [ "x$platform" == "xkvm" ] || [ "x$platform" == "xqemu" ]; then
                    ETS_SSHCMD "virsh attach-interface $vmname bridge br0 --model virtio" "$hostuser" "$hostpasswd" "$hostip"
                    checkresult $?
                elif [ "x$platform" == "xxen" ]; then
                    fn_add_testxml "network" "$((num + 1))"
                    checkresult $?
                    ETS_SSHCMD "mkdir -p /home/$(basename "$0");cd /home/$(basename "$0")" "$hostuser" "$hostpasswd" "$hostip"
                    checkresult $?
                    ETS_SSHSCP ./"$testxml" "${hostuser}"@"${hostip}":/home/"$(basename "$0")" "${hostpasswd}"
                    checkresult $?
                    ETS_SSHCMD "virsh attach-device $vmname \"/home/$(basename "$0")/$testxml\"" "$hostuser" "$hostpasswd" "$hostip"
                    checkresult $?
                fi
                testmac_remote[$num]=$(ETS_SSHCMD "virsh domiflist $vmname" "$hostuser" "$hostpasswd" "$hostip" | sed 's/\r//' | awk '{print $5}' | grep "^." | tail -1)
            done
        fi
    fi
}
function eth_add_local() {
    local eth_need_local=$1
    #get the Ethernet device name from local
    eth_unused_list_local=$(get_eth_list unused local)
    eth_num_local=$(echo "$eth_unused_list_local" | awk '{print NF}')
    if [ "$eth_num_local" -lt "$eth_need_local" ]; then
        if [ x$platform == xnone ]; then
            echo "no more eth device satisfy the required"
            exit 1
        else
            for ((num = $eth_num_local; num < $eth_need_local; num++)); do
                if [ "x$platform" == "xkvm" ] || [ "x$platform" == "xqemu" ]; then
                    ETS_SSHCMD "virsh attach-interface $vmname_local bridge br0 --model virtio" "$hostuser_local" "$hostpasswd_local" "$hostip_local"
                    checkresult $?
                elif [ "x$platform" == "xxen" ]; then
                    fn_add_testxml "network" "$((num + 1))"
                    checkresult $?
                    ETS_SSHCMD "mkdir -p /home/$(basename "$0");cd /home/$(basename "$0")" "$hostuser_local" "$hostpasswd_local" "$hostip_local"
                    checkresult $?
                    ETS_SSHSCP ./"$testxml" "${hostuser_local}"@"${hostip_local}":/home/"$(basename "$0")" "${hostpasswd_local}"
                    checkresult $?
                    ETS_SSHCMD "virsh attach-device $vmname_local \"/home/$(basename "$0")/$testxml\"" "$hostuser_local" "$hostpasswd_local" "$hostip_local"
                    checkresult $?
                fi
                testmac_local[$num]=$(ETS_SSHCMD "virsh domiflist $vmname_local" "$hostuser_local" "$hostpasswd_local" "$hostip_local" | sed 's/\r//' | awk '{print $5}' | grep "^." | tail -1)
            done
        fi
    fi
}

function eth_del_remote() {
    local eth_need_remote=$1
    for ((num = $eth_num_remote; num < $eth_need_remote; num++)); do
        ETS_SSHCMD "virsh detach-interface $vmname bridge --mac ${testmac_remote[$num]}" "$hostuser" "$hostpasswd" "$hostip"
    done
}
function eth_del_local() {
    local eth_need_local=$1
    for ((num = $eth_num_local; num < $eth_need_local; num++)); do
        ETS_SSHCMD "virsh detach-interface $vmname_local bridge --mac ${testmac_local[$num]}" "$hostuser_local" "$hostpasswd_local" "$hostip_local"
    done
}

function date_set() {
    local ntpflag=0
    local type=${1-local}
    if fn_service ntpd status "$type" | grep running; then
        fn_service ntpd stop
        ntpflag=1
    fi
    if [ x"$type" == xlocal ]; then
        ntpdate szxntp01-in.huawei.com
    elif [ x"$type" == xremote ]; then
        ETS_SSHCMD "ntpdate szxntp01-in.huawei.com"
    fi
    checkresult $?
    if [ x$ntpflag = x1 ]; then
        fn_service ntpd restart "$type"
    fi
}

function get_ping6_version() {
    vertion=$(ping6 -V | awk '{print $NF}' | tr -cd "[0-9]")
}

# 检查ipv6地址是否可用
# input: $1:待检测ipv6地址   $2:可用网卡名
# default: N/A
# return: 0:匹配到未使用的ip地址 1:未匹配到合适的ip地址

function ipv6_find_unused_ip() {
    addr=$1
    eth=$2
    local net
    net=$(echo "$addr" | awk -F '::' '{print $1"::"}')
    for ((i = 0; i < 30; i++)); do
        ip addr add "$addr"/64 dev "$eth"
        sleep 2
        ip a | grep "$addr" | grep dadfailed > /dev/null
        if [ $? -eq 0 ]; then
            ip addr del "$addr"/64 dev "$eth"
            local last
            last=$(printf %x $(($RANDOM % 252 + 2)))
            addr=${net}${last}
        else
            echo "$addr"
            return 0
        fi
    done
    return 1
}

# 获取安全上下文
# input: $1:待检测的文件
# default: N/A
# return: 返回安全上下文描述

function get_se_context() {
    # 判断是否2020及以上版本或者是arm架构
    if [ "$(rpm -qa | grep openEuler)" ] || [ "$(arch)" == "aarch64" ]; then
        ls -Zl "$1" | awk '{print $5}'
    else
        ls -Zl "$1" | awk '{print $3}'
    fi
}
function check_ip_unused() {
    local tmp_ip=$1
    local -r tmp_eth=$(route | grep default | head -1 | awk '{print $NF}')
    if [[ ${tmp_ip} =~ \. ]]; then
        arping "${tmp_ip}" -I "${tmp_eth}" -c 3 -f &> /dev/null && return 1
        return 0
    else
        local dad_failed=1
        ip -6 addr add "${tmp_ip}"/${NET_MASK} dev "${tmp_eth}" &> /dev/null
        for i in $(seq 10); do
            tmp_state=$(ip a s "${tmp_eth}" | grep -w "${tmp_ip}" | awk '{print $NF}')
            [[ global,link =~ ${tmp_state} ]] && dad_failed=0 && break
            sleep 1
        done
        ip -6 addr del "${tmp_ip}"/${NET_MASK} dev "${tmp_eth}" &> /dev/null
        return ${dad_failed}
    fi
}
function num_to_ip() {
    local test_num=$1
    local test_net=$2
    local part_3
    local part_4
    if [[ ${test_net} =~ \. ]]; then
        part_3=$((test_num / 256 + 1))
        part_4=$((test_num % 256))
        echo "${test_net}.${part_3}.${part_4}"
    else
        part_3=$(printf "%x" $((test_num / 65536 + 1)))
        part_4=$(printf "%x" $((test_num % 65536)))
        echo "${test_net}::${part_3}:${part_4}"
    fi
}
function find_unused_ip_by() {
    local ip_net=${1}
    local in_pool=${2-true}
    local rand_num rand_ip
    for i in $(seq 30); do
        if [[ ${ip_net} =~ \. ]]; then
            rand_num=$((RANDOM % IP_POOL_SIZE))
        else
            rand_num=$((RANDOM * RANDOM % IP_POOL_SIZE))
        fi
        [ "${in_pool}" != true ] && rand_num=$((rand_num + IP_POOL_SIZE))

        rand_ip=$(num_to_ip ${rand_num} "${ip_net}")
        check_ip_unused "${rand_ip}" && {
            echo "${rand_ip}"
            return 0
        }
    done
    return 1
}
function version_compare() {
    local v1=$1
    local op=$2
    local v2=$3
    python -c "from distutils.version import LooseVersion as v; \
    print(v('${v1}') ${op} v('${v2}'))" | grep -q True
}

function coredump_set() {
    enforce_status=0
    oldulimit=$(ulimit -c)
    ulimit -c unlimited
    if getenforce | grep Enforcing; then
        setenforce 0
        enforce_status=1
    fi
    echo 1 > /proc/sys/fs/suid_dumpable
    old_core_pattern=$(cat /proc/sys/kernel/core_pattern)
    echo "$(pwd)"/test_app_core-%e-%p-%t > /proc/sys/kernel/core_pattern
    chmod 777 "$(pwd)"
    rm -rf "$(pwd)"/test_app_core*
}

function coredump_reset() {
    [ -n "$enforce_status" ] && [ "$enforce_status" == 1 ] && setenforce 1
    [ -n "$oldulimit" ] && ulimit -c "$oldulimit"
    echo 0 > /proc/sys/fs/suid_dumpable
    [ -n "$old_core_pattern" ] && echo "$old_core_pattern" > /proc/sys/kernel/core_pattern
    chmod 755 "$(pwd)"

}
function find_unused_eth() {
    local all_eth_list=($(ifconfig -a | grep -E "${PATTERN_ETH}" | awk -F"[ |:]" '{print $1}'))

    local tmp_eth
    for tmp_eth in "${all_eth_list[@]}"; do
        ifconfig "${tmp_eth}" | grep -qwE "${PATTERN_IP}" && continue
        echo "${tmp_eth}"
        return 0
    done
    return 1
}
function iptables_save() {
    setenforce 0
    ETS_SSHCMD "setenforce 0"
    systemctl stop firewalld
    ETS_SSHCMD "systemctl stop firewalld"
}
function iptables_restore() {
    setenforce 1
    ETS_SSHCMD "setenforce 1"
    systemctl restart firewalld
    sleep 2
    ETS_SSHCMD "systemctl restart firewalld"
}
function docker_prepare() {
    local image_name="$1"
    yum install -y docker
    if ! cat /etc/sysconfig/docker | grep rnd-dockerhub.huawei.com; then
        sed -i 's/--live-restore/--live-restore --insecure-registry rnd-dockerhub.huawei.com/g' /etc/sysconfig/docker
    fi
    systemctl restart docker
    docker images | grep -w package_test
    if [ $? -ne 0 ]; then
        docker pull "${image_name}"
        docker tag "${image_name}" package_test
    fi
}

function isula_prepare() {
    local image_name="$1"

    if [[ "$ETS_BRANCH_VERSION" =~ EulerOS_V200R008C00 ]]; then
        mkdir -p /tmp/rpm_tmp
        wget -P /tmp/rpm_tmp -r -nd -np -A rpm "${ETS_COMMON_RELEASE%/*}"/"${ETS_PRODUCT_VERSION}"-"${ETS_PRODUCT_TIME}"/Software/aarch64/DockerStack
        which createrepo || yum install -y createrepo
        createrepo /tmp/rpm_tmp
        repo_file="$(ls /etc/yum.repos.d/*.repo)"
        cp -arf "${repo_file}" "${repo_file}"_bak
        cat >> "${repo_file}" << EOF
[local]
name=local
baseurl=file:///tmp/rpm_tmp
enabled=1
gpgcheck=0
EOF
        yum clean all
        isula_cmd=lcrc
        isula_serv=lcrd
        tool_cmd=docker-tools
        hook_file='/etc/docker-tools/hookspec.json'
        yum install -y iSulad authz lxcfs docker-toolkit docker-tools docker-lxcfs-toolkit
        mv "${repo_file}"_bak "${repo_file}"
        yum clean all
    else
        isula_cmd=isula
        isula_serv=isulad
        tool_cmd=syscontainer-tools
        hook_file='/etc/syscontainer-tools/hookspec.json'
        if version_compare "$ETS_VERSION" ">=" "V200R011C00"; then
            yum install -y iSulad lxcfs-tools lxcfs docker-toolkit syscontainer-tools
        else
            yum install -y iSulad authz lxcfs-tools lxcfs docker-toolkit syscontainer-tools
        fi
    fi
    grep rnd-dockerhub.huawei.com /etc/isulad/daemon.json \
        || sed -i '/insecure-registries/a "rnd-dockerhub.huawei.com"' /etc/isulad/daemon.json
    systemctl restart "${isula_serv}"
    systemctl start lxcfs
    systemctl start authz
    export isula_cmd
    export isula_serv
    export tool_cmd
    export hook_spec

    # 制作系统容器镜像
    if ! "${isula_cmd}" images | grep -w "${image_name}"; then
        "${isula_cmd}" pull "${image_name}" || return 1
    fi
    export rootfs_parent='/home/package_test_system_image'
    rm -rf "${rootfs_parent}"
    mkdir -p "${rootfs_parent}"
    docker_convert -i "${image_name}" -o "${rootfs_parent}" || return 1

    # 准备容器网卡和ip
    for nic in $(ls /sys/class/net/ | grep -vE 'lo|bonding_masters'); do
        ifconfig "${nic}" | grep inet && continue
        isula_nic="${nic}"
        break
    done
    [ -z "${isula_nic}" ] && return 1
    while ((1)); do
        isula_ip=9.82."$(($RANDOM % 200 + 10)).$(($RANDOM % 200 + 10))"
        ping -c 3 "${isula_ip}" || break
    done
    export isula_nic
    export isula_ip
}

# 删除环境中无用的NetworkManager connection
# 成功返回0 ，失败返回1
# input: 参数1 可用网卡
# default:
function del_unused_con() {
    local eth_unused=$1
    nmcli connection show
    con_name=$(nmcli connection show | grep -E "${eth_unused}" | awk '{print $1}')
    [ "$con_name" = "" ] || nmcli connection delete "${eth_unused}"
}

# 获取grub相关文件路径
function get_grub_path() {
    grep -w EulerOS /etc/os-release && product="euleros" || product="openEuler"

    grub_default=/etc/default/grub
    if [ "$(uname -m | grep x86_64)" ] && [ ! -d /sys/firmware/efi ]; then
        grub_conf=/boot/grub2/grub.cfg
        grubenv=/boot/grub2/grubenv
        grub_dir=/boot/grub2/
    else
        grub_conf=/boot/efi/EFI/"${product}"/grub.cfg
        grubenv=/boot/efi/EFI/"${product}"/grubenv
        grub_dir=/boot/efi/EFI/"${product}"/
    fi
}

# 部署编译环境到指定文件夹
function deploy_compile_env() {
    local test_dir="$1"
    [ -e "$test_dir" ] || rm -rf "$test_dir"
    mkdir "$test_dir"
    pushd "$test_dir" || exit
    source "${ETS_PATH}"/libs/download.sh
    cmc_download "Euler_compile_env.tar.gz"
    expect_eq $? 0
    tar xf Euler_compile_env.tar.gz
    expect_eq $? 0
    popd || exit
}

# 清理指定文件夹下的编译环境
function clean_compile_env() {
    local test_dir="$1"
    sh "$test_dir/Euler_compile_env/chroot.sh" umount
    rm -rf "$test_dir/Euler_compile_env"
}

# CPU加压
function cpustress() {
    local stress="${1:-90}"

    if [[ "$(arch)" = x86_64 ]]; then
        stress_cmd="cpu_stress.sh"
    else
        stress_cmd="arm_cpulimit"
    fi
    cd "$ETS_PATH"/tools/gen_stress || exit 1
    ./$stress_cmd "$stress" &
    for ((i = 0; i < 60; i++)); do
        top -n 1 -N 5 -b # debug info
        cpu_use_per=$(top -n 1 -N 5 -b | grep '%Cpu(s):' | awk '{print $2}' | awk -F. '{print $1}')
        [[ $cpu_use_per -ge $((stress - 2)) ]] && break
        sleep 1
    done
    [[ $cpu_use_per -ge $((stress - 2)) ]]
    expect_eq $? 0
    cd - || exit 1
}

# 清理CPU加压进程
function clean_cpustress() {
    ps aux | grep cpulimit | grep -v grep | awk '{print $2}' | xargs kill -9
    ps aux | grep stress | grep -v grep | awk '{print $2}' | xargs kill -9
    wait_cmd_nok 'ps aux | grep cpulimit | grep -v grep' 1 10
    wait_cmd_nok 'ps aux | grep stress | grep -v grep' 1 10
}

function mem_press() {
    local mem_press=${1:-60}

    tmp_mem_press=$((mem_press + 1))
    mem=$(free -l | grep -w 'Mem')
    mtotal=$(echo "$mem" | awk '{print $2}')
    mused=$(echo "$mem" | awk '{print $3}')
    mfree=$(echo "$mem" | awk '{print $4}')
    meat=$((mtotal * tmp_mem_press / 100 - mused))
    meat=$((meat / 1024))
    meat=$((meat + 10))
    sync
    echo 3 > /proc/sys/vm/drop_caches
    local i
    uname -r | grep 'aarch64'
    if [ $? -eq 0 ]; then
        for i in $(seq 5); do
            "${ETS_PATH}"/tools/gen_stress/arm_eatmem "${mem_press}" > /dev/null 2>&1 &
            sleep 5
            ps aux | grep arm_eatmem && break
        done
    else
        cd /root || exit 1
        wget -N http://${PXE_SERVER}/Public_Software_Tools/press_tools/memtester
        cd - || exit 1
        chmod +x /root/memtester
        /root/memtester ${meat}M < /dev/tty2 > /dev/null 2>&1 &
    fi
    c=0
    mem_free=$((mfree * 100 / mtotal))
    #有可能host环境压力导致没法加压到精确期望，放宽检查值
    mem_rest=$((100 - mem_press + 10))
    while [ "$mem_free" -gt ${mem_rest} ]; do
        sleep 10
        mem=$(free -l | grep -w 'Mem')
        mfree=$(echo "$mem" | awk '{print $4}')
        mem_free=$((mfree * 100 / mtotal))
        ((c++))
        [ $c -ge 60 ] && break
    done
    [ "$mem_free" -le ${mem_rest} ]
    expect_eq $? 0
}

function recover_mem() {
    uname -r | grep 'aarch64'
    if [ $? -eq 0 ]; then
        pkill -9 arm_eatmem
    else
        pkill -9 memtester
    fi
    rm -rf /root/memtester
}

function check_libcgroup() {
    #checking whether product is unifiedstorage
    if [[ $ETS_PRODUCT_NAME =~ ^(SVP)|(EVR)|(DORADO)|(PANGEA)$ ]]; then
        if [ "$(which systemctl)x" != "x" ]; then
            which cgcreate
            [[ "0" -ne "$?" ]] && exit "$ETS_FAILED"
        fi
    else
        which cgcreate || yum install -y libcgroup
        [[ "0" -ne "$?" ]] && exit "$ETS_FAILED"
    fi
}
