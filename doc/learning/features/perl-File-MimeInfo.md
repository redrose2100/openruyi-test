# perl-File-MimeInfo

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/perl-File-MimeInfo` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_perl-File-MimeInfo_mimetype_01 | Test perl-File-Mimeinfo | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_perl-File-MimeInfo_mimetype_02 | Test perl-File-Mimeinfo | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_perl-File-MimeInfo_mimetype_03 | Test perl-File-Mimeinfo | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_perl-File-MimeInfo_mimetype_04 | Test perl-File-Mimeinfo | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_perl-File-MimeInfo_mimeopen_01 | Test perl-File-Mimeinfo | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_perl-File-MimeInfo_mimeopen_02 | Test perl-File-Mimeinfo | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_perl-File-MimeInfo_mimetype_01

- 描述：Test perl-File-Mimeinfo
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check mimetype -a failed"
  CHECK_RESULT $? 0 0 "Check mimetype --all failed"
  CHECK_RESULT $? 0 0 "Check mimetype -b failed"
  CHECK_RESULT $? 0 0 "Check mimetype --brief failed"
  CHECK_RESULT $? 0 0 "Check mimetype --database failed"
  CHECK_RESULT $? 0 0 "Check mimetype -d failed"
  CHECK_RESULT $? 0 0 "Check mimetype --describ failed"
  CHECK_RESULT $? 0 0 "Check mimetype --D failed"
  CHECK_RESULT $? 0 0 "Check mimetype --debug failed"
```

- 涉及命令：mimetype×3, tar×1, mkdir×1

#### oe_test_perl-File-MimeInfo_mimetype_02

- 描述：Test perl-File-Mimeinfo
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check mimetype -f failed"
  CHECK_RESULT $? 0 0 "Check mimetype --namefile failed"
  CHECK_RESULT $? 0 0 "Check mimetype --file-compat failed"
  CHECK_RESULT $? 0 0 "Check mimetype -F failed"
  CHECK_RESULT $? 0 0 "Check mimetype --separator failed"
  CHECK_RESULT $? 0 0 "Check mimetype --help failed"
  CHECK_RESULT $? 0 0 "Check mimetype -h failed"
  CHECK_RESULT $? 0 0 "Check mimetype --help failed"
  CHECK_RESULT $? 0 0 "Check mimetype -h failed"
  CHECK_RESULT $? 0 0 "Check mimetype -v failed"
```

- 涉及命令：mimetype×5, tar×1, mkdir×1

#### oe_test_perl-File-MimeInfo_mimetype_03

- 描述：Test perl-File-Mimeinfo
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check mimetype --version failed"
  CHECK_RESULT $? 0 0 "Check mimetype -i failed"
  CHECK_RESULT $? 0 0 "Check mimetype --mimetype failed"
  CHECK_RESULT $? 0 0 "Check mimetype -L failed"
  CHECK_RESULT $? 0 0 "Check mimetype --dereference failed"
  CHECK_RESULT $? 0 0 "Check mimetype -l failed"
  CHECK_RESULT $? 0 0 "Check mimetype --language failed"
  CHECK_RESULT $? 0 0 "Check mimetype -M failed"
  CHECK_RESULT $? 0 0 "Check mimetype --agic-only failed"
  CHECK_RESULT $? 0 0 "Check mimetype -N failed"
```

- 涉及命令：mimetype×5, tar×1, mkdir×1

#### oe_test_perl-File-MimeInfo_mimetype_04

- 描述：Test perl-File-Mimeinfo
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check mimetype --noalign failed"
  CHECK_RESULT $? 0 0 "Check mimetype --output-format failed"
  CHECK_RESULT $? 0 0 "Check mimetype --stdin failed"
```

- 涉及命令：tar×1, mkdir×1

#### oe_test_perl-File-MimeInfo_mimeopen_01

- 描述：Test perl-File-Mimeinfo
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check mimeopen -a failed"
  CHECK_RESULT $? 0 0 "Check mimeopen --ask failed"
  CHECK_RESULT $? 0 0 "Check mimeopen -d failed"
  CHECK_RESULT $? 0 0 "Check mimeopen --ask-default failed"
  CHECK_RESULT $? 0 0 "Check mimeopen -n failed"
  CHECK_RESULT $? 0 0 "Check mimeopen --no-ask failed"
  CHECK_RESULT $? 0 0 "Check mimeopen -M failed"
  CHECK_RESULT $? 0 0 "Check mimeopen --magic-only failed"
  CHECK_RESULT $? 0 0 "Check mimeopen --database failed"
  CHECK_RESULT $? 0 0 "Check mimeopen -D failed"
```

- 涉及命令：tar×1, mkdir×1

#### oe_test_perl-File-MimeInfo_mimeopen_02

- 描述：Test perl-File-Mimeinfo
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check mimeopen --debug failed"
  CHECK_RESULT $? 0 0 "Check mimeopen --help failed"
  CHECK_RESULT $? 0 0 "Check mimeopen -h failed"
  CHECK_RESULT $? 0 0 "Check mimeopen --usage failed"
  CHECK_RESULT $? 0 0 "Check mimeopen -u failed"
  CHECK_RESULT $? 0 0 "Check mimeopen --version failed"
  CHECK_RESULT $? 0 0 "Check mimeopen -v failed"
```

- 涉及命令：mimeopen×3, tar×1, mkdir×1
