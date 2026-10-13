# qemu

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/qemu` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_qemu-guest-agent | Test qemu-guest-agent.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_qemu-pr-helper | Test qemu-pr-helper.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_qemu-pr-helper | Test qemu-pr-helper.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_crypto_qcow2_sm4_sha256 | Test qemu-crypto-sm4-sha256 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_crypto_qcow2_aes_sm3 | Test qemu-crypto-aes-sm3 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_crypto_qcow2_sm4_sm3 | Test qemu-crypto-sm4-sm3 | pre_test/run_test/post_test | 1 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_qemu-guest-agent

- 描述：Test qemu-guest-agent.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_qemu-pr-helper

- 描述：Test qemu-pr-helper.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_qemu-pr-helper

- 描述：Test qemu-pr-helper.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_crypto_qcow2_sm4_sha256

- 描述：Test qemu-crypto-sm4-sha256
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "qcow2 sm4 sha256 test failed"
```

#### oe_test_crypto_qcow2_aes_sm3

- 描述：Test qemu-crypto-aes-sm3
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "qcow2 aes sm3 test failed"
```

#### oe_test_crypto_qcow2_sm4_sm3

- 描述：Test qemu-crypto-sm4-sm3
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "qcow2 sm4 sm3 test failed"
```
