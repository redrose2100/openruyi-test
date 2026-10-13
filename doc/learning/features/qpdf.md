# qpdf

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/qpdf` |
| 注册用例数 | 11 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_qpdf_qpdf_01 | Test qpdf | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_qpdf_qpdf_02 | Test qpdf | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_qpdf_qpdf_03 | Test qpdf | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_qpdf_qpdf_04 | Test qpdf | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_qpdf_qpdf_05 | Test qpdf | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_qpdf_qpdf_06 | Test qpdf | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_qpdf_qpdf_07 | Test qpdf | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_qpdf_qpdf_08 | Test qpdf | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_qpdf_qpdf_09 | Test qpdf | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_qpdf_qpdf_10 | Test qpdf | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_qpdf_zlib-flate | Test zlib-flate and fix-qdf | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_qpdf_qpdf_01

- 描述：Test qpdf
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "qpdf --version running failed"
  CHECK_RESULT $? 0 0 "qpdf --copyright running failed"
  CHECK_RESULT $? 0 0 "qpdf --help running failed"
  CHECK_RESULT $? 0 0 "qpdf --completion-bash running failed"
  CHECK_RESULT $? 0 0 "qpdf --completion-zsh running failed"
  CHECK_RESULT $? 0 0 "qpdf --password=password running failed"
  CHECK_RESULT $? 0 0 "qpdf --verbose running failed"
  CHECK_RESULT $? 0 0 "qpdf --progress running failed"
  CHECK_RESULT $? 1 0 "qpdf -no-warn running failed"
  CHECK_RESULT $? 0 0 "qpdf --linearize running failed"
```

- 涉及命令：rpm×1

#### oe_test_qpdf_qpdf_02

- 描述：Test qpdf
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "qpdf --copy-encryption --encryption-file-password running failed"
  CHECK_RESULT $? 0 0 "qpdf --encryption-file-password=password running failed"
  CHECK_RESULT $? 0 0 "qpdf --decrypt running failed"
  CHECK_RESULT $? 0 0 "qpdf --password-is-hex-key running failed"
  CHECK_RESULT $? 0 0 "qpdf --suppress-password-recovery running failed"
  CHECK_RESULT $? 0 0 "qpdf --password-mode=bytes running failed"
  CHECK_RESULT $? 0 0 "qpdf --password-mode=hex-bytes running failed"
  CHECK_RESULT $? 0 0 "qpdf --password-mode=unicode running failed"
  CHECK_RESULT $? 0 0 "qpdf --password-mode=auto running failed"
```

#### oe_test_qpdf_qpdf_03

- 描述：Test qpdf
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=256 running failed"
  CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=128 running failed"
  CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=256 --print=full running failed"
  CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=256 --print=low running failed"
  CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=256 --print=none running failed"
  CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=256 --modify=all running failed"
  CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=256 --modify=annotate running failed"
  CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=256 --modify=form running failed"
  CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=256 --modify=assembly running failed"
  CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=256 --modify=none running failed"
  CHECK_RESULT $? 0 0 "qpdf --encrypt options with key-length=256 running failed"
```

#### oe_test_qpdf_qpdf_04

- 描述：Test qpdf
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "qpdf --pages  running failed"
  CHECK_RESULT $? 0 0 "qpdf --keep-files-open  running failed"
  CHECK_RESULT $? 0 0 "qpdf --keep-files-open-threshold  running failed"
  CHECK_RESULT $? 0 0 "qpdf --collate  running failed"
  CHECK_RESULT $? 0 0 "qpdf --rotate  running failed"
  CHECK_RESULT $? 0 0 "qpdf --split-pages  running failed"
  CHECK_RESULT $? 0 0 "qpdf --overlay  running failed"
  CHECK_RESULT $? 0 0 "qpdf --overlay option  running failed"
  CHECK_RESULT $? 0 0 "qpdf --underlay running failed"
  CHECK_RESULT $? 0 0 "qpdf --underlay options running failed"
```

#### oe_test_qpdf_qpdf_05

- 描述：Test qpdf
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "qpdf --suppress-recovery  running failed"
  CHECK_RESULT $? 0 0 "qpdf --ignore-xref-streams running failed"
  CHECK_RESULT $? 0 0 "qpdf --stream-data=compress running failed"
  CHECK_RESULT $? 0 0 "qpdf --stream-data=uncompress running failed"
  CHECK_RESULT $? 0 0 "qpdf --compress-streams running failed"
  CHECK_RESULT $? 0 0 "qpdf --decode-level=none running failed"
  CHECK_RESULT $? 0 0 "qpdf --decode-level=generalized running failed"
  CHECK_RESULT $? 0 0 "qpdf --decode-level=specialized running failed"
  CHECK_RESULT $? 0 0 "qpdf --decode-level=all running failed"
```

#### oe_test_qpdf_qpdf_06

- 描述：Test qpdf
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "qpdf --normalize-content running failed"
  CHECK_RESULT $? 0 0 "qpdf --object-streams=preserve running failed"
  CHECK_RESULT $? 0 0 "qpdf --object-streams=disable running failed"
  CHECK_RESULT $? 0 0 "qpdf --object-streams=generate running failed"
  CHECK_RESULT $? 0 0 "qpdf --preserve-unreferenced running failed"
  CHECK_RESULT $? 0 0 "qpdf --preserve-unreferenced-resources running failed"
  CHECK_RESULT $? 0 0 "qpdf --newline-before-endstream running failed"
  CHECK_RESULT $? 0 0 "qpdf --coalesce-contents running failed"
  CHECK_RESULT $? 0 0 "qpdf --flatten-annotations=print running failed"
  CHECK_RESULT $? 0 0 "qpdf --flatten-annotations=screen running failed"
  CHECK_RESULT $? 0 0 "qpdf --flatten-annotations=all running failed"
```

#### oe_test_qpdf_qpdf_07

- 描述：Test qpdf
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "qpdf --generate-appearances running failed"
  CHECK_RESULT $? 0 0 "qpdf --optimize-images running failed"
  CHECK_RESULT $? 0 0 "qpdf --oi-min-width running failed"
  CHECK_RESULT $? 0 0 "qpdf --oi-min-height running failed"
  CHECK_RESULT $? 0 0 "qpdf --oi-min-height running failed"
  CHECK_RESULT $? 0 0 "qpdf --externalize-inline-images running failed"
  CHECK_RESULT $? 0 0 "qpdf --ii-min-bytes running failed"
  CHECK_RESULT $? 0 0 "qpdf --keep-inline-images running failed"
  CHECK_RESULT $? 0 0 "qpdf --remove-page-labels running failed"
  CHECK_RESULT $? 0 0 "qpdf --qdf running failed"
```

- 涉及命令：qpdf×1

#### oe_test_qpdf_qpdf_08

- 描述：Test qpdf
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "qpdf --linearize running failed"
  CHECK_RESULT $? 0 0 "qpdf --min-version running failed"
  CHECK_RESULT $? 0 0 "qpdf --force-version running failed"
  CHECK_RESULT $? 0 0 "qpdf --deterministic-id running failed"
  CHECK_RESULT $? 0 0 "qpdf --static-id running failed"
  CHECK_RESULT $? 0 0 "qpdf --static-aes-iv running failed"
  CHECK_RESULT $? 0 0 "qpdf --no-original-object-ids running failed"
  CHECK_RESULT $? 0 0 "qpdf --show-encryption running failed"
  CHECK_RESULT $? 0 0 "qpdf --show-encryption-key running failed"
  CHECK_RESULT $? 0 0 "qpdf --check-linearization running failed"
```

#### oe_test_qpdf_qpdf_09

- 描述：Test qpdf
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "qpdf --show-linearization running failed"
  CHECK_RESULT $? 0 0 "qpdf --show-xref running failed"
  CHECK_RESULT $? 0 0 "qpdf --show-object running failed"
  CHECK_RESULT $? 0 0 "qpdf --raw-stream-data running failed"
  CHECK_RESULT $? 0 0 "qpdf --filtered-stream-data running failed"
  CHECK_RESULT $? 0 0 "qpdf --show-npages running failed"
  CHECK_RESULT $? 0 0 "qpdf --show-pages running failed"
  CHECK_RESULT $? 0 0 "qpdf --show-pages -with-images running failed"
  CHECK_RESULT $? 0 0 "qpdf --check running failed"
  CHECK_RESULT $? 0 0 "qpdf --json running failed"
```

- 涉及命令：qpdf×1

#### oe_test_qpdf_qpdf_10

- 描述：Test qpdf
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "qpdf --json-help running failed"
  CHECK_RESULT $? 0 0 "qpdf --json-key running failed"
  CHECK_RESULT $? 0 0 "qpdf --json-object=trailer running failed"
```

#### oe_test_qpdf_zlib-flate

- 描述：Test zlib-flate and fix-qdf
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "zlib-flate command options -compress running failed"
  CHECK_RESULT $? 0 0 "zlib-flate command options -uncompress running failed"
  CHECK_RESULT $? 0 0 "fix-qdf command running failed"
```

- 涉及命令：zlib-flate×2, qpdf×1
