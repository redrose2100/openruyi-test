# argus

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/argus` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_argus_01 | Test argus | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_argus_02 | Test argus | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_argus_03 | Test argus | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_argusbug | Test argusbug | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_service_argus | Test argus.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_argus_01

- 描述：Test argus
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check argus -h failed"
  CHECK_RESULT $? 0 0 "Check argus -r failed"
  CHECK_RESULT $? 0 0 "Check argus -w failed"
  CHECK_RESULT $? 0 0 "Check argus -A failed"
  CHECK_RESULT $? 0 0 "Check argus -b failed"
  CHECK_RESULT $? 0 0 "Check argus -B failed"
  CHECK_RESULT $? 0 0 "Check argus -c failed"
  CHECK_RESULT $? 0 0 "Check argus -C failed"
  CHECK_RESULT $? 0 0 "Check argus -d failed"
  CHECK_RESULT $? 0 0 "Check argus -e failed"
```

- 涉及命令：argus×10, curl×7, kill×7, tar×1, test×1

#### oe_test_argus_02

- 描述：Test argus
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check argus -f failed"
  CHECK_RESULT $? 0 0 "Check argus -F failed"
  CHECK_RESULT $? 0 0 "Check argus -i failed"
  CHECK_RESULT $? 0 0 "Check argus -J failed"
  CHECK_RESULT $? 0 0 "Check argus -M failed"
  CHECK_RESULT $? 0 0 "Check argus -m failed"
  CHECK_RESULT $? 0 0 "Check argus -O failed"
  CHECK_RESULT $? 0 0 "Check argus -p failed"
  CHECK_RESULT $? 0 0 "Check argus -P failed"
```

- 涉及命令：argus×9, kill×9, curl×8, tar×1, test×1, netstat×1

#### oe_test_argus_03

- 描述：Test argus
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check argus -R failed"
  CHECK_RESULT $? 0 0 "Check argus -s failed"
  CHECK_RESULT $? 0 0 "Check argus -S failed"
  CHECK_RESULT $? 0 0 "Check argus -t failed"
  CHECK_RESULT $? 0 0 "Check argus -u failed"
  CHECK_RESULT $? 0 0 "Check argus -g failed"
  CHECK_RESULT $? 0 0 "Check argus -U failed"
  CHECK_RESULT $? 0 0 "Check argus -X failed"
  CHECK_RESULT $? 0 0 "Check argus -Z failed"
```

- 涉及命令：argus×9, curl×9, kill×9, tar×1

#### oe_test_argusbug

- 描述：Test argusbug
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check argus-extip failed"
  CHECK_RESULT $? 0 0 "Check argus-lsof failed"
  CHECK_RESULT $? 0 0 "Check argus-snmp failed"
```

- 涉及命令：sed×1

#### oe_test_service_argus

- 描述：Test argus.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3
