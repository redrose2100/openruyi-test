# ima-evm-utils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ima-evm-utils` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_evmctl_01 | Test evmctl installation, version and basic IMA/EVM functionality | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_evmctl_02 | Test evmctl hash algorithm and output options | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_evmctl_03 | Test evmctl file operation and recursive options | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_evmctl_01

- 描述：Test evmctl installation, version and basic IMA/EVM functionality
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "evmctl_gen_key failed to generate signing key and certificate"
  CHECK_RESULT $? 0 0 "ima-evm-utils package is not installed"
  CHECK_RESULT $? 0 0 "evmctl --version does not match rpm version"
  CHECK_RESULT $? 0 0 "evmctl --help does not show usage"
  CHECK_RESULT $? 0 0 "evmctl ima_hash failed to calculate hash"
  CHECK_RESULT $? 0 0 "evmctl ima_hash did not output hex hash"
  CHECK_RESULT $? 0 0 "evmctl ima_sign failed to sign file"
  CHECK_RESULT $? 0 0 "evmctl ima_verify failed to verify signed file"
```

- 涉及命令：mkdir×1, rpm×1, evmctl×1, grep×1

#### oe_test_evmctl_02

- 描述：Test evmctl hash algorithm and output options
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "evmctl_gen_key failed to generate signing key and certificate"
  CHECK_RESULT $? 0 0 "evmctl -a sha1 ima_hash failed"
  CHECK_RESULT $? 0 0 "evmctl -a sha256 ima_hash failed"
  CHECK_RESULT $? 0 0 "evmctl -a sha384 ima_hash failed"
  CHECK_RESULT $? 0 0 "evmctl -a sha512 ima_hash failed"
  CHECK_RESULT $? 0 0 "evmctl -a sm3 ima_hash failed"
  CHECK_RESULT $? 0 0 "evmctl -f ima_sign failed"
  CHECK_RESULT $? 0 0 "evmctl -f did not create .sig file"
  CHECK_RESULT $? 0 0 "evmctl -n ima_hash failed"
  CHECK_RESULT $? 0 0 "evmctl -n did not print hex hash to stdout"
  CHECK_RESULT $? 0 0 "evmctl -v ima_hash failed"
  CHECK_RESULT $? 0 0 "evmctl -v did not output hex digest"
```

- 涉及命令：evmctl×8, grep×2, mkdir×1, test×1

#### oe_test_evmctl_03

- 描述：Test evmctl file operation and recursive options
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "evmctl_gen_key failed to generate signing key and certificate"
  CHECK_RESULT $? 0 0 "evmctl -r ima_hash failed on directory"
  CHECK_RESULT $? 0 0 "evmctl -r -t f ima_hash failed"
  CHECK_RESULT $? 0 0 "evmctl ima_sign failed to generate IMA signature for portable sign test"
  CHECK_RESULT $? 0 0 "evmctl -o sign failed to create portable signature"
  CHECK_RESULT $? 0 0 "evmctl -f ima_sign failed to generate signature for setxattr test"
  CHECK_RESULT $? 0 0 "evmctl ima_setxattr failed to set xattr from sig file"
  CHECK_RESULT $? 0 0 "evmctl --xattr-user ima_hash failed"
  CHECK_RESULT $? 0 0 "evmctl --xattr-user did not set user.ima xattr"
```

- 涉及命令：evmctl×4, mkdir×3, getfattr×1
