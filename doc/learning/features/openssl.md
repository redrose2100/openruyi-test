# openssl

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/openssl` |
| 注册用例数 | 34 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_openssl_concurrent_operations | Pressure load : concurrent operations | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_openssl_create_CA_applying_certificate | Encryption algorithm: create a CA and applying for a certificate | config_params/pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_openssl_delete_configuration_file | delete the ssl-related files from httpd configuration file,acess request(Implements https based on httpd and OpenSSL) | config_params/pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_openssl_Diffie_Hellman | OpenSSL commandline tool: Diffie-Hellman(key exchange protocal/algorithm) | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_openssl_DSA_algorithm | Application scenarios: method of generating the private key,public key,and self-shared key(signature certificate) of the DSA algorithm | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_openssl_empty_private_key | Exception scenarios: the key is empty | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_openssl_empty_public_key | Exception scenarios: the public key is empty | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_openssl_encrypt_decrypt_file_asymmetrically | Application scenarios: encrypt and decrypt the file asymmetrically using RSA algorithm | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_openssl_encrypte_decrypte_emails | Application scenarios: use RSA certificates to encrypte and decrypte emails | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_openssl_encrypting_character_string | Application scenarios: encrypting character string | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_openssl_expired_certificate | the certificate has expired | config_params/pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_openssl_file_signature_verification | OpenSSL commandline tool: file signature and signature verification | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_openssl_generate_key_pair | Encryption algorithm: generate a key pair | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_openssl_generate_password | Encryption algorithm: generate a password | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_openssl_generate_random_number | Encryption algorithm: generate a random number | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_openssl_Implements_https | Application scenarios: Implements https based on httpd and OpenSSL | config_params/pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_openssl_incorrect_public_private_key | Exception scenarios: the key is incorrect,the public key is incorrect | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_openssl_message_digest | OpenSSL commandline tool: message digest algorithm | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_openssl_one_way_encryption | Encryption algorithm: one-way encryption | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_openssl_related_concurrent_operations | Pressure load : different but related operations are performed concurrently | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_openssl_reliability | Pressure load : kill process,start service,acess request (Implements https based on httpd and OpenSSL) | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_openssl_remove_mod_ssl | remove the mod_ssl.so module,restart service(Implements https based on httpd and OpenSSL) | config_params/pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_openssl_repeated_execution | Pressure load : repeated execution | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_openssl_repeat_restart | Pressure load : Repeat restart (Implements https based on httpd and OpenSSL) | config_params/pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_openssl_RSA_algorithm | Application scenarios: method of generating the private key,public key,and self-shared key(signature certificate) of the RSA algorithm | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_openssl_symmetrically_encrypts_decrypts_files | Application scenarios: symmetrically encrypts and decrypts files | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_openssl_symmetric_encryption_decryption | Encryption algorithm: symmetric encryption and decryption | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_openssl_enc | openssl encryption and decryption | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_openssl_rc4_encryption_file | Test rc4 encryption and decryption file | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_openssl_sm2 | Command openssl sm2 | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_openssl_sm4 | Command openssl sm4 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_openssl_hmac | Command openssl hmac | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_openssl_speed | Command openssl speed | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_openssl_cryptographic_services | SSL protocol encrypted transmission service | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_openssl_concurrent_operations

- 描述：Pressure load : concurrent operations
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssl_create_CA_applying_certificate

- 描述：Encryption algorithm: create a CA and applying for a certificate
- 函数：`config_params, pre_test, run_test, post_test`
#### oe_test_openssl_delete_configuration_file

- 描述：delete the ssl-related files from httpd configuration file,acess request(Implements https based on httpd and OpenSSL)
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssl_Diffie_Hellman

- 描述：OpenSSL commandline tool: Diffie-Hellman(key exchange protocal/algorithm)
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssl_DSA_algorithm

- 描述：Application scenarios: method of generating the private key,public key,and self-shared key(signature certificate) of the DSA algorithm
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssl_empty_private_key

- 描述：Exception scenarios: the key is empty
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssl_empty_public_key

- 描述：Exception scenarios: the public key is empty
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssl_encrypt_decrypt_file_asymmetrically

- 描述：Application scenarios: encrypt and decrypt the file asymmetrically using RSA algorithm
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：test×3

#### oe_test_openssl_encrypte_decrypte_emails

- 描述：Application scenarios: use RSA certificates to encrypte and decrypte emails
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×2

#### oe_test_openssl_encrypting_character_string

- 描述：Application scenarios: encrypting character string
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssl_expired_certificate

- 描述：the certificate has expired
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "error:OPENSSL and HTTPD configuration failed."
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Certificate not expired"
```

#### oe_test_openssl_file_signature_verification

- 描述：OpenSSL commandline tool: file signature and signature verification
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×2

#### oe_test_openssl_generate_key_pair

- 描述：Encryption algorithm: generate a key pair
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssl_generate_password

- 描述：Encryption algorithm: generate a password
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssl_generate_random_number

- 描述：Encryption algorithm: generate a random number
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1

#### oe_test_openssl_Implements_https

- 描述：Application scenarios: Implements https based on httpd and OpenSSL
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 'error:OPENSSL and HTTPD configuration failed.'
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 'The HTTPS access on openEuler failed'
```

#### oe_test_openssl_incorrect_public_private_key

- 描述：Exception scenarios: the key is incorrect,the public key is incorrect
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Incorrect public key succeeded in encrypting the file"
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "The wrong private key successfully decrypted the file"
```

- 涉及命令：test×1

#### oe_test_openssl_message_digest

- 描述：OpenSSL commandline tool: message digest algorithm
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssl_one_way_encryption

- 描述：Encryption algorithm: one-way encryption
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_openssl_related_concurrent_operations

- 描述：Pressure load : different but related operations are performed concurrently
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1

#### oe_test_openssl_reliability

- 描述：Pressure load : kill process,start service,acess request (Implements https based on httpd and OpenSSL)
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssl_remove_mod_ssl

- 描述：remove the mod_ssl.so module,restart service(Implements https based on httpd and OpenSSL)
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_openssl_repeated_execution

- 描述：Pressure load : repeated execution
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1

#### oe_test_openssl_repeat_restart

- 描述：Pressure load : Repeat restart (Implements https based on httpd and OpenSSL)
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssl_RSA_algorithm

- 描述：Application scenarios: method of generating the private key,public key,and self-shared key(signature certificate) of the RSA algorithm
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_openssl_symmetrically_encrypts_decrypts_files

- 描述：Application scenarios: symmetrically encrypts and decrypts files
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1

#### oe_test_openssl_symmetric_encryption_decryption

- 描述：Encryption algorithm: symmetric encryption and decryption
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1

#### oe_test_openssl_enc

- 描述：openssl encryption and decryption
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $str1 "Welcom to linuxCareer.com" 1 "encryption fail"
  CHECK_RESULT $str2 "Welcom to linuxCareer.com" 0 "decryption fail"
```

#### oe_test_openssl_rc4_encryption_file

- 描述：Test rc4 encryption and decryption file
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Generation failure 1"
  CHECK_RESULT $? 0 0 "Generation failure 2"
  CHECK_RESULT $? 0 0 "Generation failure 3"
  CHECK_RESULT $? 0 0 "Generation failure 2"
  CHECK_RESULT $? 0 0 "Generation failure 3"
  CHECK_RESULT $? 0 0 "decryption failure"
```

- 涉及命令：test×5

#### oe_test_openssl_sm2

- 描述：Command openssl sm2
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "openssl do not support sm2 encryption"
  CHECK_RESULT $? 0 0 "generate private key failed"
  CHECK_RESULT $? 0 0 "generate public key failed"
  CHECK_RESULT $? 0 0 "priv.key permission error"
  CHECK_RESULT $? 0 0 "pub.key permission error"
```

- 涉及命令：stat×2

#### oe_test_openssl_sm4

- 描述：Command openssl sm4
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "sm4 encrypt file fail "
  CHECK_RESULT $? 0 0 "sm4 decrypt file fail"
```

#### oe_test_openssl_hmac

- 描述：Command openssl hmac
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "hmac algorithm with sm3  fail"
  CHECK_RESULT $? 0 0 "hmac algorithm with sha256  fail"
  CHECK_RESULT $? 0 0 "hmac algorithm with sha512  fail"
  CHECK_RESULT $? 0 0 "hmac algorithm with md5 fail"
```

#### oe_test_openssl_speed

- 描述：Command openssl speed
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "rsa512 encryption and decryption operation speed fail"
  CHECK_RESULT $? 0 0 "aes-128-cbc encryption and decryption operation speed fail"
  CHECK_RESULT $? 0 0 "aes-192-cbc encryption and decryption operation speed fail"
  CHECK_RESULT $? 0 0 "aes-256-cbc encryption and decryption operation speed fail"
  CHECK_RESULT $? 0 0 "sm3 encryption and decryption operation speed fail"
  CHECK_RESULT $? 0 0 "sm4 encryption and decryption operation speed fail"
```

- 涉及命令：grep×5

#### oe_test_openssl_cryptographic_services

- 描述：SSL protocol encrypted transmission service
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "File generation failed"
  CHECK_RESULT $? 0 0 "File generation failed"
  CHECK_RESULT $? 0 0 "File generation failed"
  CHECK_RESULT $? 0 0 "Script execution failed"
  CHECK_RESULT $? 0 0 "Access failed"
```

- 涉及命令：test×2, mkdir×1, expect×1
