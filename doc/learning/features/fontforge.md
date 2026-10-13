# fontforge

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/fontforge` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_fontforge_fontforge | verify the uasge of fontforge command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_fontforge_fontimage | verify the uasge of fontforge command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_fontforge_fontlint | verify the uasge of fontforge command | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_fontforge_fontforge

- 描述：verify the uasge of fontforge command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check fontforge -help failed"
  CHECK_RESULT $? 0 0 "Check fontforge -version failed"
  CHECK_RESULT $? 0 0 "Check fontforge -docs failed"
  CHECK_RESULT $? 0 0 "Check fontforge -script failed"
```

- 涉及命令：fontforge×4

#### oe_test_fontforge_fontimage

- 描述：verify the uasge of fontforge command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check fontimage --version failed"
  CHECK_RESULT $? 0 0 "Check fontimage --width failed"
  CHECK_RESULT $? 0 0 "Check fontimage --height failed"
  CHECK_RESULT $? 0 0 "Check fontimage --fontname failed"
  CHECK_RESULT $? 0 0 "Check fontimage --text failed"
  CHECK_RESULT $? 0 0 "Check fontimage --pixelsize failed"
  CHECK_RESULT $? 0 0 "Check fontimage --o failed"
```

#### oe_test_fontforge_fontlint

- 描述：verify the uasge of fontforge command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check fontlint --help failed"
  CHECK_RESULT $? 0 0 "Check fontlint -l failed"
  CHECK_RESULT $? 0 0 "Check fontlint --warning failed"
  CHECK_RESULT $? 0 0 "Check fontlint -i failed"
  CHECK_RESULT $? 0 0 "Check fontlint -f failed"
```

- 涉及命令：fontlint×3
