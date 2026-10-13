# utsudo

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/utsudo` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_utsudo_s | using the utsudo -S command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utsudo_b | using the utsudo -S command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utsudo_p | using the utsudo -S command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utsudo_u | using the utsudo -S command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_utsudo_e | using the utsudo -S command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utsudo_h | using the utsudo -S command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utsudo_l | using the utsudo -S command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_utsudoreplay_h | using the utsudoreplay -h command | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_utsudo_s

- 描述：using the utsudo -S command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "su -c 'utsudo -S useradd user' uos fail"
  CHECK_RESULT $? 0 0 "su -c id user fail"
```

- 涉及命令：sed×4, utsudo×1

#### oe_test_utsudo_b

- 描述：using the utsudo -S command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "create file failed"
  CHECK_RESULT $? 0 0 "utsudo -b /root/test.sh fail"
```

- 涉及命令：sed×4, test×1

#### oe_test_utsudo_p

- 描述：using the utsudo -S command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "utsudo -u admin2 groups fail"
  CHECK_RESULT $? 0 0 "utsudo -u admin2 groups fail"
```

- 涉及命令：sed×8

#### oe_test_utsudo_u

- 描述：using the utsudo -S command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "echo qwert > /home/admin1/test.txt admin1 fail"
  CHECK_RESULT $? 0 0 "su -c 'ls -l /home/admin1/test.txt' admin1 fail"
  CHECK_RESULT $? 0 0 "su -c 'ls -l /home/admin1/test.txt' 660 admin1 fail"
  CHECK_RESULT $? 1 0 "utsudo -S -u admin2 cat /home/admin1/test.txt fail"
  CHECK_RESULT $? 0 0 "utsudo chown admin2 /home/admin1/test.txt fail"
  CHECK_RESULT $? 0 0 "utsudo -u admin1 cat /home/admin1/test.txt fail"
```

- 涉及命令：sed×8

#### oe_test_utsudo_e

- 描述：using the utsudo -S command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1 0 "utsudo sh /home/admin3/test.sh fail"
  CHECK_RESULT $? 0 0 "utsudo -E sh /home/admin3/test.sh fail"
```

- 涉及命令：sed×4

#### oe_test_utsudo_h

- 描述：using the utsudo -S command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "su -c 'utsudo -h' fail"
  CHECK_RESULT $? 0 0 "su -c 'utsudo -V' fail"
```

- 涉及命令：sed×4, userdel×2

#### oe_test_utsudo_l

- 描述：using the utsudo -S command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "su -c 'utsudo -l' fail"
  CHECK_RESULT $? 0 0 "su -c 'utsudo -l -U uos' fail"
```

- 涉及命令：sed×4, userdel×1

#### oe_test_utsudoreplay_h

- 描述：using the utsudoreplay -h command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "su -c 'utsudoreplay -h' fail"
  CHECK_RESULT $? 0 0 "su -c 'utsudoreplay -V' fail"
```

- 涉及命令：sed×4, userdel×2
