#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujuan
# @Contact   :   liujuan@xfusion.com
# @Date      :   2024/10/14
# @License   :   Mulan PSL v2
# @Desc      :   Verify the usage of the keytool command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
	LOG_INFO "Start to prepare the test environment!"
	if dnf list | grep "java-17-openjdk"; then
		DNF_INSTALL "java-17-openjdk java-17-openjdk-devel java-17-openjdk-headless"
	else
		LOG_WARN "The java-17-openjdk package does not exist in the system."
		exit 0
	fi
	LOG_INFO "End to prepare the test environment!"
}

function run_test() {
	LOG_INFO "Start to run test."
	keytool --help 2>&1 | grep "Usage:\|keytool"
	CHECK_RESULT $? 0 0 "Failed to check option : --help"
	keytool -h 2>&1 | grep "Usage:\|keytool"
	CHECK_RESULT $? 0 0 "Failed to check option : -h"
	keytool -? 2>&1 | grep "Usage:\|keytool"
	CHECK_RESULT $? 0 0 "Failed to check option : -?"

	# 创建密钥库文件
	# 方式一：创建时不使用-storepass参数设置密钥库的密码，因此需要提供密钥库的密码，首次会自动创建密码
	expect <<EOF
        log_file log1
        spawn keytool -genkeypair -alias mykey -keyalg RSA -keysize 2048 -keystore mykeystore.jks
        expect "Enter keystore password:*" {send "123@Come\r"}
        expect "Re-enter new password:*" {send "123@Come\r"}
        expect ":*" {send "ming\r"}
        expect ":*" {send "xiao\r"}
        expect ":*" {send "wang\r"}
        expect ":*" {send "Xi'an\r"}
        expect ":*" {send "Shaanxi\r"}
        expect ":*" {send "123456\r"}
        expect ":*" {send "yes\r"}
        expect eof
EOF
	test -s mykeystore.jks && grep "Generating 2,048 bit RSA key pair and self-signed certificate (SHA256withRSA) with a validity of 90 days" log1
	CHECK_RESULT $? 0 0 "Failed to create mykeystore.jks keystore file."
	# 方式二：创建时使用-storepass参数设置密钥库的密码
	expect <<EOF
        log_file log2
        spawn keytool -genkeypair -alias myalias -keyalg RSA -keystore mykeystore2.jks -storepass mypassword -validity 365
        expect ":*" {send "shan\r"}
        expect ":*" {send "da\r"}
        expect ":*" {send "zhang\r"}
        expect ":*" {send "chengdu\r"}
        expect ":*" {send "sichuang\r"}
        expect ":*" {send "567890\r"}
        expect ":*" {send "yes\r"}
        expect eof
EOF
	test -s mykeystore2.jks && grep "Generating 2,048 bit RSA key pair and self-signed certificate (SHA256withRSA) with a validity of 365 days" log2
	CHECK_RESULT $? 0 0 "Failed to create mykeystore2.jks keystore file."

	# 查看密钥库中的内容
	# 方式一：查看时不使用-storepass参数设置密钥库的密码，因此需要提供密钥库的密码
	expect <<EOF
        log_file checklog
        spawn keytool -list -keystore mykeystore.jks
        expect "Enter keystore password:*" {send "123@Come\r"}
        expect eof
EOF
	grep -E "Your keystore contains 1 entry|mykey.*PrivateKeyEntry" checklog
	CHECK_RESULT $? 0 0 "Failed to view the contents of the mykeystore.jks keystore."
	# 方式二：查看时使用-storepass参数设置密钥库的密码
	keytool -list -keystore mykeystore2.jks -storepass mypassword | grep -E "Your keystore contains 1 entry|myalias.*PrivateKeyEntry"
	CHECK_RESULT $? 0 0 "Failed to view the contents of the mykeystore2.jks keystore."

	# 从密钥库中导出证书
	keytool -exportcert -alias mykey -keystore mykeystore.jks -file mycert.cer -storepass 123@Come
	CHECK_RESULT $? 0 0 "Failed to export cert from keystore."
	test -s mycert.cer
	CHECK_RESULT $? 0 0 "Failed to create mycert.cer file."

	# 删除mykeystore.jks密钥库中的条目
	keytool -delete -alias mykey -keystore mykeystore.jks -storepass 123@Come
	CHECK_RESULT $? 0 0 "Failed to delete keystore file."
	# 查看密钥库中的条目是否删除成功
	keytool -list -keystore mykeystore.jks -storepass 123@Come | grep "Your keystore contains 0 entries"
	CHECK_RESULT $? 0 0 "Failed to verify that the keystore contents are empty."

	# 导入证书
	echo "yes" | keytool -importcert -alias mykey -file mycert.cer -keystore mykeystore.jks -storepass 123@Come 2>&1 | grep "Certificate was added to keystore"
	CHECK_RESULT $? 0 0 "Certificate import failed."
	# 查看导入证书是否成功
	keytool -list -keystore mykeystore.jks -storepass 123@Come | grep -E "Your keystore contains 1 entry|mykey|trustedCertEntry"
	CHECK_RESULT $? 0 0 "Failed to import cert into keystore."

	# 打印证书内容
	keytool -printcert -file mycert.cer | grep -E "Certificate fingerprints|Signature algorithm name|Serial number|Valid from|KeyIdentifier|[0-9][A-Z]"
	CHECK_RESULT $? 0 0 "Failed to print cert content."

	# 更改密钥库的密码
	expect <<EOF
        spawn keytool -storepasswd -keystore mykeystore.jks
        expect "Enter keystore password:*" {send "123@Come\r"}
        expect "New keystore password:*" {send "mypassword\r"}
        expect "Re-enter new keystore password:*" {send "mypassword\r"}
        expect eof
EOF
	# 检查密码是否更改成功并生效：使用新改的密码mypassword查看密钥库mykeystore.jks中的内容，看能否成功
	keytool -list -keystore mykeystore.jks -storepass mypassword | grep "mykey"
	CHECK_RESULT $? 0 0 "Failed to modify the keystore password."

	# 更改密钥库中条目的别名
	keytool -changealias -keystore mykeystore2.jks -alias myalias -destalias mynewalias -storepass mypassword
	CHECK_RESULT $? 0 0 "Changing the alias of an entry in the keystore failed."
	# 检查别名是否更改成功
	keytool -list -keystore mykeystore2.jks -storepass mypassword | grep "mynewalias"
	CHECK_RESULT $? 0 0 "Failed to change alias."

	# 删除不使用的密钥条目
	keytool -delete -alias mynewalias -keystore mykeystore2.jks -storepass mypassword
	keytool -delete -alias mykey -keystore mykeystore.jks -storepass mypassword
	# 查看密钥库中的条目是否删除成功
	keytool -list -keystore mykeystore2.jks -storepass mypassword | grep "Your keystore contains 0 entries"
	CHECK_RESULT $? 0 0 "Failed to delete an entry in the mykeystore2.jks keystore."
	keytool -list -keystore mykeystore.jks -storepass mypassword | grep "Your keystore contains 0 entries"
	CHECK_RESULT $? 0 0 "Failed to delete an entry in the mykeystore.jks keystore."
	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "start environment cleanup."
	DNF_REMOVE "$@"
	rm -rf $(ls | grep -vE ".sh")
	LOG_INFO "Finish environment cleanup!"
}

main "$@"
