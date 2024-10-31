#!/bin/bash
img_url="https://repo.openeuler.org/openEuler-22.03-LTS-SP3/virtual_machine_img/x86_64/openEuler-22.03-LTS-SP3-x86_64.qcow2.xz"
filename=$(basename ${img_url})
volume=${filename%.xz}

function create_domain_xml()
{
    # 检查是否提供了足够的参数
    if [ "$#" -ne 2 ]; then
        echo "Usage: $0 UUID VOLUME_PATH"
        exit 1
    fi
    
    # 读取参数
    UUID=$1
    VOLUME=$2
    
    # 指定模板文件和输出文件
    TEMPLATE_FILE="common/template.xml"
    OUTPUT_FILE="domain_${UUID}.xml"
    
    # 读取模板文件并替换占位符，然后写入到新的文件
    sed "s|\${uuid}|${UUID}|g; s|\${volume}|${VOLUME}|g" $TEMPLATE_FILE > "$OUTPUT_FILE"
}

function create_secret_xml()
{
    # 检查是否提供了足够的参数
    if [ "$#" -ne 2 ]; then
        echo "Usage: $0 UUID VOLUME_PATH"
        exit 1
    fi
    
    # 读取参数
    UUID=$1
    VOLUME=$2
    
    # 指定模板文件和输出文件
    TEMPLATE_FILE="common/secret.xml"
    OUTPUT_FILE="secxml_${UUID}.xml"
    
    # 读取模板文件并替换占位符，然后写入到新的文件
    sed "s|\${uuid}|${UUID}|g; s|\${volume}|${VOLUME}|g" $TEMPLATE_FILE > "$OUTPUT_FILE"
}

function createsecvm_with_sm4_sm3()
{
    # 检查是否提供了足够的参数
    if [ "$#" -ne 3 ]; then
        echo "Usage: $0 UUID VOLUME_PATH ENC_VOLUME_PATH"
        exit 1
    fi
    
    # 读取参数
    uuid=$1
    volume=$2
    sec_volume=$3
    
    if [ ! -f "${volume}" ];then
      printf "not exist %s!\n" "${volume}"
      exit 1
    fi
    
    #sec_volume="${volume%.qcow2}_enc_sm34.qcow2"
    create_secret_xml "${uuid}" "${sec_volume}"
    secuuid=$(virsh secret-list |grep "${sec_volume}"|cut -d " " -f2)
    
    if [ -n "${secuuid}" ];then
    	virsh secret-undefine "${secuuid}"
    fi
    virsh secret-define secxml_"${uuid}".xml
    secret_set "${uuid}"
    qemu-img convert -O qcow2 --object secret,id=sec0,data="${uuid}" -o encrypt.format=luks,encrypt.key-secret=sec0,encrypt.cipher-alg=sm4,encrypt.cipher-mode=xts,encrypt.ivgen-alg=plain64,encrypt.hash-alg=sm3 "${volume}"  "${sec_volume}" || { printf "qemu-img convert sec img error\n";exit 1; }
    create_domain_xml "${uuid}" "${sec_volume}"
    virsh define domain_"${uuid}".xml
    virsh start "${uuid}"
}

function createsecvm_with_sm4_sha256()
{
    # 检查是否提供了足够的参数
    if [ "$#" -ne 3 ]; then
        echo "Usage: $0 UUID VOLUME_PATH ENC_VOLUME_PATH"
        exit 1
    fi
    
    # 读取参数
    uuid=$1
    volume=$2
    sec_volume=$3

    if [ ! -f "${volume}" ];then
      printf "not exist %s\n" "${volume}"
      exit 1
    fi
    
    #sec_volume="${volume%.qcow2}_enc_sm4.qcow2"
    create_secret_xml "${uuid}" "${sec_volume}"
    secuuid=$(virsh secret-list |grep "${sec_volume}"|cut -d " " -f2)
    
    if [ -n "${secuuid}" ];then
    	virsh secret-undefine "${secuuid}"
    fi
    virsh secret-define secxml_"${uuid}".xml
    secret_set "${uuid}" 
    qemu-img convert -O qcow2 --object secret,id=sec0,data="${uuid}" -o encrypt.format=luks,encrypt.key-secret=sec0,encrypt.cipher-alg=sm4,encrypt.cipher-mode=xts,encrypt.ivgen-alg=plain64,encrypt.hash-alg=sha256  "${volume}"  "${enc_volume}" || { printf "qemu-img convert sec img error\n";exit 1; }
    create_domain_xml "${uuid}" "${sec_volume}"
    virsh define domain_"${uuid}".xml
    virsh start "${uuid}"
}


function createsecvm_with_aes_sm3()
{
    # 检查是否提供了足够的参数
    if [ "$#" -ne 3 ]; then
        echo "Usage: $0 UUID VOLUME_PATH ENC_VOLUME_PATH"
        exit 1
    fi
    
    # 读取参数
    uuid=$1
    volume=$2
    sec_volume=$3
    
    if [ ! -f "${volume}" ];then
      printf "not exist %s\n" "${volume}"
      exit 1
    fi
    
    #sec_volume="${volume%.qcow2}_enc_aes_sm3.qcow2"
    create_secret_xml "${uuid}" "${sec_volume}"
    secuuid=$(virsh secret-list |grep "${sec_volume}"|cut -d " " -f2)
    
    if [ -n "${secuuid}" ];then
    	virsh secret-undefine "${secuuid}"
    fi
    virsh secret-define secxml_"${uuid}".xml
    secret_set "${uuid}"
    qemu-img convert -O qcow2 --object secret,id=sec0,data="${uuid}" -o encrypt.format=luks,encrypt.key-secret=sec0,encrypt.cipher-alg=aes-256,encrypt.cipher-mode=xts,encrypt.ivgen-alg=plain64,encrypt.hash-alg=sm3 "${volume}"  "${enc_volume}" || { printf "qemu-img convert sec img error\n"; exit 1; }
    create_domain_xml "${uuid}" "${sec_volume}"
    virsh define domain_"${uuid}".xml
    virsh start "${uuid}"
}

function secret_set()
{
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 UUID"
        exit 1
    fi
    
    # 读取参数
    uuid=$1
    seuuid=$(echo -n "${uuid}" |base64)
    echo "${seuuid}" >/tmp/secuuid_"${uuid}"
    virsh secret-set-value "${uuid}" --file /tmp/secuuid_"${uuid}"
    rm -f /tmp/secuuid_"${uuid}"
}

function download_openeuler_img()
{
    if [ ! -e "${volume}" ];then
        curl -C - -O -fsSL "${img_url}"
        xz -d "${volume}".xz
    fi
}

function test_crypto_qcow2_sm4_sha256()
{
    uuid=$1
    enc_volume=$2
    if [ ! -e "${volume}" ];then
        download_openeuler_img
    fi
    createsecvm_with_sm4_sha256 "${uuid}" "$(pwd)/${volume}" "$(pwd)/${enc_volume}"  
    get_openeuler_runing "${uuid}"
}

function test_crypto_qcow2_aes_sm3()
{
    uuid=$1
    enc_volume=$2
    if [ ! -e "${volume}" ];then
        download_openeuler_img
    fi
    createsecvm_with_aes_sm3 "${uuid}" "$(pwd)/${volume}" "$(pwd)/${enc_volume}"  
    get_openeuler_runing "${uuid}"
}

function test_crypto_qcow2_sm4_sm3()
{
    uuid=$1
    enc_volume=$2
    if [ ! -e "${volume}" ];then
        download_openeuler_img
    fi
    createsecvm_with_sm4_sm3 "${uuid}" "$(pwd)/${volume}" "$(pwd)/${enc_volume}"
    get_openeuler_runing "${uuid}"
}

function get_openeuler_runing()
{
    uuid=$1
    if virsh domstate "${uuid}"|grep -q running;then
       get_openeuler_vendor "${uuid}"
       return 0
    else
       return 1
    fi 
}

function get_openeuler_vendor()
{
    uuid=$1
    serial_device=$(virsh dumpxml "${uuid}" | sed -n "s/.*tty='\(\/dev\/pts\/[0-9]\+\)'.*/\1/p")
    username="root" 
    password="openEuler12#$" 
    command="echo __START__; cat /etc/os-release; echo __END__"
    timeout=120
    
    # 检查是否成功提取串口设备路径
    if [ -z "$serial_device" ]; then
        echo "未能提取到串口设备路径。请检查虚拟机的串口配置。
    "
        exit 1
    fi
    
    # 将变量传递给 Expect 脚本
    export username password command timeout serial_device
    
    # 运行 Expect 脚本
    expect << 'EOF'
        log_user 1
        #exp_internal 1;   
    
        # 从环境变量中获取变量
        set username $env(username)
        set password $env(password)
        set command $env(command)
        set timeout [expr {$env(timeout)}]
        set serial_device $env(serial_device)
    
        # 启动 socat 与串口设备的连接
        spawn socat - $serial_device
    
        # 发送初始回车以触发登录提示符
        send "\r"
    
        # 等待提示符
        expect {
            -re {login: *$} {
                send "$username\r"
                exp_continue
            }
            -re {Password: *$} {
                send "$password\r"
                exp_continue
            }
            -re {[\$#] *$} {
                # 已登录，发送命令
                send "$command\r"
                # 等待命令回显结束
                expect -re "\r\n"
            }
            timeout {
                puts "等待提示符超时"
                exit 1
            }
        }
    
        # 跳过命令回显和可能的额外输出，直到匹配到 `__START__`
        expect {
            -re {\r*__START__\r*\n} {
                # 已匹配到 `__START__`，开始捕获内容
            }
            timeout {
                puts "等待 __START__ 标识符超时"
                exit 1
            }
        }
    
        # 捕获输出直到 `__END__`
        set output ""
        expect {
            -re "(?ms)(.*?)\r*__END__\r*\n" {
                append output $expect_out(1,string)
                # 去除多余的空白字符
                set output [string trim $output]
                puts "Captured Output: $output"
                # 检查输出是否包含 "openEuler"
                if {[string match "*openEuler*" $output]} {
                    puts "检测成功：输出包含 'openEuler'"
                    exit 0
                } else {
                    puts "检测失败：输出不包含 'openEuler'"
                    exit 1
                }
            }
            timeout {
                puts "等待 __END__ 标识符超时"
                exit 1
            }
        }
EOF
    
    # 获取 Expect 脚本的退出码
    RESULT=$?
    
    # 根据 Expect 脚本的退出码执行操作
    if [ "$RESULT" -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
    
}

function destroy_vm()
{
    uuid=$1
    if virsh list |grep -q "${uuid}";then
      virsh destroy "${uuid}"
    fi
}

function undefine_vm()
{
    uuid=$1
    if virsh list --inactive|grep -q "${uuid}";then
      virsh undefine "${uuid}"
    fi
}

function deletesecvm()
{
    uuid=$1
    destroy_vm "${uuid}"
    undefine_vm "${uuid}"
}

function delete_openeuler_img()
{
    local sec_volume=$1
    local volume=$2
    rm -f "${sec_volume}" 
    rm -f "${volume}" 
}

function cleanup()
{
    local sec_volume=$1
    local volume=$2
    delete_openeuler_img "${sec_volume}" "${volume}"
    rm -rf ./*.xml*
}
