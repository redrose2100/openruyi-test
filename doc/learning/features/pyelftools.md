# pyelftools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/pyelftools` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pyelftools_pyreadelf_01 | verify the uasge of ninja-build command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pyelftools_pyreadelf_02 | verify the uasge of ninja-build command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pyelftools_pyreadelf_03 | verify the uasge of ninja-build command | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_pyelftools_pyreadelf_01

- 描述：verify the uasge of ninja-build command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check pyreadelf -v  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --version  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf -d sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --dynamic sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf -H  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --help  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf -h sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --file-header sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf -l sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --program-headers sample_exe64.elf  failed"
```

- 涉及命令：pyreadelf×5

#### oe_test_pyelftools_pyreadelf_02

- 描述：verify the uasge of ninja-build command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check pyreadelf --segments sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf -S sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --section-headers sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --sections sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf -e -A  sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --headers  --arch-specific sample_exe64.elf   failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf -s sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --symbols sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --syms sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf -n sample_exe64.elf  failed"
```

- 涉及命令：pyreadelf×4

#### oe_test_pyelftools_pyreadelf_03

- 描述：verify the uasge of ninja-build command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check pyreadelf --notes sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf -r sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --relocs sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf -x 1 sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --hex-dump 1 sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf -p 1 sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --string-dump 1 sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf -V sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --version-info sample_exe64.elf  failed"
  CHECK_RESULT $? 0 0 "Check pyreadelf --debug-dump info sample_exe64.elf  failed"
```

- 涉及命令：pyreadelf×4
