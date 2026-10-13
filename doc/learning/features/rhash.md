# rhash

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rhash` |
| 注册用例数 | 6 |
| 环境约束 | machine num = 1；machine type = kvm |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_rhash_base_rhash_01 | Take the test rhash command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_rhash_base_rhash_02 | Take the test rhash command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rhash_base_rhash_03 | Take the test rhash command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rhash_base_rhash_04 | Take the test rhash command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rhash_base_rhash_05 | Take the test rhash command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_rhash_base_rhash_06 | Take the test rhash command | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_rhash_base_rhash_01

- 描述：Take the test rhash command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "error --gost12-256"
  CHECK_RESULT $? 0 0 "error --gost12-512"
  CHECK_RESULT $? 0 0 "error --gost94"
  CHECK_RESULT $? 0 0 "error --gost94-cryptopro"
  CHECK_RESULT $? 0 0 "error --ripemd160"
  CHECK_RESULT $? 0 0 "error --has160"
  CHECK_RESULT $? 0 0 "error --edonr256"
```

#### oe_test_rhash_base_rhash_02

- 描述：Take the test rhash command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "error --sha512"
  CHECK_RESULT $? 0 0 "error --sha3-224"
  CHECK_RESULT $? 0 0 "error --sha3-256"
  CHECK_RESULT $? 0 0 "error --sha3-384"
  CHECK_RESULT $? 0 0 "error --sha3-512"
  CHECK_RESULT $? 0 0 "error --tth"
  CHECK_RESULT $? 0 0 "error --btih"
  CHECK_RESULT $? 0 0 "error --aich"
  CHECK_RESULT $? 0 0 "error --ed2k"
  CHECK_RESULT $? 0 0 "error --ed2k-link"
```

#### oe_test_rhash_base_rhash_03

- 描述：Take the test rhash command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "error --version"
  CHECK_RESULT $? 0 0 "error --help"
  CHECK_RESULT $? 0 0 "error --crc32"
  CHECK_RESULT $? 0 0 "error --crc32c"
  CHECK_RESULT $? 0 0 "error --md4"
  CHECK_RESULT $? 0 0 "error --md5"
  CHECK_RESULT $? 0 0 "error --sha1"
  CHECK_RESULT $? 0 0 "error --sha224"
  CHECK_RESULT $? 0 0 "error --sha256"
  CHECK_RESULT $? 0 0 "error --sha384"
```

#### oe_test_rhash_base_rhash_04

- 描述：Take the test rhash command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "error --tiger"
  CHECK_RESULT $? 0 0 "error --snefru128"
  CHECK_RESULT $? 0 0 "error --snefru256"
  CHECK_RESULT $? 0 0 "error --all"
  CHECK_RESULT $? 0 0 "error --check"
  CHECK_RESULT $? 0 0 "error --update or error --ignore-case "
  CHECK_RESULT $? 0 0 "error --embed-crc"
  CHECK_RESULT $? 0 0 "error --check-embedded"
  CHECK_RESULT $? 0 0 "error --list-hashes"
  CHECK_RESULT $? 0 0 "error --benchmark"
```

#### oe_test_rhash_base_rhash_05

- 描述：Take the test rhash command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "error recursive or error --maxdepth"
  CHECK_RESULT $? 0 0 "error --file-list"
  CHECK_RESULT $? 0 0 "error -skip-ok"
  CHECK_RESULT $? 0 0 "error --message"
  CHECK_RESULT $? 0 0 "error --percents or error --speeds"
  CHECK_RESULT "$(ls / | grep -cE 'tmp_dir/tmp_output')" 0 0 "error--output"
  CHECK_RESULT "$(ls / | grep -cE 'tmp_dir/tmp_log')" 0 0 "error--output"
  CHECK_RESULT $? 0 0 "error --bsd"
  CHECK_RESULT $? 0 0 "error --sfv"
  CHECK_RESULT $? 0 0 "error --simple"
```

#### oe_test_rhash_base_rhash_06

- 描述：Take the test rhash command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "error --verbose"
  CHECK_RESULT $? 0 0 "error --hex"
  CHECK_RESULT $? 0 0 "error --base32"
  CHECK_RESULT $? 0 0 "error --base64"
  CHECK_RESULT $? 0 0 "error --magnet"
  CHECK_RESULT "$(ls / | grep -cE 'tmp_dir/test1K.data.torrent')" 0 0 "error --torrent"
  CHECK_RESULT $? 0 0 "error --template"
  CHECK_RESULT $? 0 0 "error --test1K.data"
```

- 涉及命令：rhash×1
