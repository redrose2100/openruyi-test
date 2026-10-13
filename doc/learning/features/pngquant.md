# pngquant

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/pngquant` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pngquant | test command pngquant | pre_test/run_test/post_test | 15 | ✔ |  |  |

### 断言与命令明细

#### oe_test_pngquant

- 描述：test command pngquant
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: pngquant --help"
  CHECK_RESULT $? 0 0 "Failed to run command: pngquant --verbose"
  CHECK_RESULT $? 0 0 "Failed to run command: pngquant test.png"
  CHECK_RESULT $? 0 0 "Failed to test stdin and stdout"
  CHECK_RESULT $? 0 0 "Failed to test more than one file"
  CHECK_RESULT "$(find . -maxdepth 1 | grep -cE 'test-fs8.png')" 1 0 "Failed to run command: pngquant --posterize"
  CHECK_RESULT $? 0 0 "Failed to run command: pngquant --strip"
  CHECK_RESULT $? 0 0 "Failed to run command: pngquant --ext"
  CHECK_RESULT $? 0 0 "Failed to run command: pngquant --output"
  CHECK_RESULT $? 0 0 "Failed to test option [ncolors]"
  CHECK_RESULT $? 0 0 "Failed to run command: pngquant --force"
  CHECK_RESULT $? 0 0 "Failed to run command: pngquant --skip-if-larger"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：test×13, wget×1
