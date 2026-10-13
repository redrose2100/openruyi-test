# elinks

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/elinks` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_elinks_base_01 | verify the uasge of elinks command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_elinks_base_02 | verify the uasge of elinks command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_elinks_base_03 | verify the uasge of elinks command | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_elinks_base_01

- 描述：verify the uasge of elinks command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check elinks -anonymous failed"
  CHECK_RESULT $? 0 0 "Check elinks -auto-submit failed"
  CHECK_RESULT $? 0 0 "Check elinks -dump -base-session failed"
  CHECK_RESULT $? 0 0 "Check elinks -config-dir failed"
  CHECK_RESULT $? 0 0 "Check elinks -config-dump failed"
  CHECK_RESULT $? 0 0 "Check elinks -config-file failed"
  CHECK_RESULT $? 0 0 "Check elinks -config-help failed"
  CHECK_RESULT $? 0 0 "Check elinks -default-mime-type failed"
  CHECK_RESULT $? 0 0 "Check elinks -default-keys -dump www.baidu.com failed"
  CHECK_RESULT $? 0 0 "Check elinks -dump -dump-charset failed"
```

- 涉及命令：elinks×5

#### oe_test_elinks_base_02

- 描述：verify the uasge of elinks command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check elinks -dump -dump-color-mode failed"
  CHECK_RESULT $? 0 0 "Check elinks -dump -dump-width failed"
  CHECK_RESULT $? 0 0 "Check elinks -eval failed"
  CHECK_RESULT $? 0 0 "Check elinks --help failed"
  CHECK_RESULT $? 0 0 "Check elinks -h failed"
  CHECK_RESULT $? 0 0 "Check elinks -version failed"
  CHECK_RESULT $? 0 0 "Check elinks -localhost failed"
  CHECK_RESULT $? 0 0 "Check elinks -long-help failed"
  CHECK_RESULT $? 0 0 "Check elinks -lookup failed"
  CHECK_RESULT $? 0 0 "Check elinks -no-connect failed"
```

- 涉及命令：elinks×7

#### oe_test_elinks_base_03

- 描述：verify the uasge of elinks command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check nohup elinks -force-html failed"
  CHECK_RESULT $? 0 0 "Check elinks -no-home failed"
  CHECK_RESULT $? 0 0 "Check elinks -no-numbering failed"
  CHECK_RESULT $? 0 0 "Check elinks -no-references failed"
  CHECK_RESULT $? 0 0 "Check elinks -remote -dump failed"
  CHECK_RESULT $? 0 0 "Check elinks -session-ring failed"
  CHECK_RESULT $? 0 0 "Check elinks -source failed"
  CHECK_RESULT $? 0 0 "Check elinks -touch-files failed"
  CHECK_RESULT $? 0 0 "Check elinks -verbose failed"
```

- 涉及命令：elinks×2
