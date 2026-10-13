# nano

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nano` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_nano_01 | Test nano command: installation, version and display options | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_nano_02 | Test nano command: editing-behavior options | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_nano_03 | Test nano command: file-operation options | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_nano_edit | Test nano basic text editing functionality | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_rnano | Test rnano command: restricted-mode specific behaviors | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_nano_01

- 描述：Test nano command: installation, version and display options
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "nano package is not installed"
  CHECK_RESULT $? 0 0 "nano binary does not exist"
  CHECK_RESULT $? 0 0 "nano --version does not match rpm version"
  CHECK_RESULT $? 0 0 "nano --help does not show usage"
  CHECK_RESULT $? 0 0 "nano -H did not create search history file"
  CHECK_RESULT $? 0 0 "nano -l altered file content"
  CHECK_RESULT $? 0 0 "nano -m altered file content"
  CHECK_RESULT $? 0 0 "nano -x altered file content"
  CHECK_RESULT $? 0 0 "nano -Y altered file content"
  CHECK_RESULT $? 0 0 "nano -q altered file content"
```

- 涉及命令：test×2, mkdir×1, rpm×1

#### oe_test_nano_02

- 描述：Test nano command: editing-behavior options
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "nano -A failed to save content"
  CHECK_RESULT $? 0 0 "nano -E did not convert tabs to spaces"
  CHECK_RESULT $? 0 0 "nano -i missing first line"
  CHECK_RESULT $? 0 0 "nano -L failed to create file"
  CHECK_RESULT $? 0 0 "nano -N did not save tabbed content"
  CHECK_RESULT $? 0 0 "nano -R failed to save content in restricted mode"
  CHECK_RESULT $? 0 0 "nano -S failed to save content"
```

- 涉及命令：mkdir×1, test×1

#### oe_test_nano_03

- 描述：Test nano command: file-operation options
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "nano -B did not create backup file backup.txt~"
  CHECK_RESULT $? 0 0 "backup file does not contain original content"
  CHECK_RESULT $? 0 0 "view.txt content changed in view mode"
  CHECK_RESULT $? 0 0 "cursor.txt content changed after nano -c open"
  CHECK_RESULT $? 0 0 "nano -t did not save content on exit"
  CHECK_RESULT $? 0 0 "nano -C did not place backup in the specified directory"
  CHECK_RESULT $? 0 0 "backup file in directory does not contain original content"
```

- 涉及命令：mkdir×2, test×2

#### oe_test_nano_edit

- 描述：Test nano basic text editing functionality
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "nano failed to create create.txt"
  CHECK_RESULT $? 0 0 "create.txt does not contain the text written by nano"
  CHECK_RESULT $? 0 0 "edit.txt lost original content after nano edit"
  CHECK_RESULT $? 0 0 "edit.txt does not contain the appended text"
```

- 涉及命令：mkdir×1, test×1

#### oe_test_rnano

- 描述：Test rnano command: restricted-mode specific behaviors
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "rnano binary does not exist"
  CHECK_RESULT $? 0 0 "rnano --version does not output version banner"
  CHECK_RESULT $? 0 0 "rnano failed to save file in restricted mode"
  CHECK_RESULT $? 0 0 "rnano saved file missing content"
  CHECK_RESULT $? 1 0 "rnano should not create history file in restricted mode"
  CHECK_RESULT $? 1 0 "rnano should disallow Save As in restricted mode"
  CHECK_RESULT $? 0 0 "rnano -v altered file content"
```

- 涉及命令：test×4, mkdir×1
