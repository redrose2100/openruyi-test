# optipng

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/optipng` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_optipng_01 | Image compression tool optiPNG | pre_test/run_test/post_test | 22 | ✔ |  |  |
| oe_test_optipng_02 | Image compression tool optiPNG | pre_test/run_test/post_test | 16 | ✔ |  |  |

### 断言与命令明细

#### oe_test_optipng_01

- 描述：Image compression tool optiPNG
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $? 0 0 "Help information printing failed"
  CHECK_RESULT $? 0 0 "Version information printing failed"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to output the log file"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to set the level"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to back up files"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Overwrite file failed"
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：optipng×9, test×4

#### oe_test_optipng_02

- 描述：Image compression tool optiPNG
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Filter failure"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Interlaced scan failed"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Non-interlaced scan failed"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to set zlib"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Report printing failed"
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Failed to set nb or nc or np or nx"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：optipng×8, grep×4
