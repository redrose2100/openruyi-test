# pigz

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/pigz` |
| 注册用例数 | 11 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pigz | pigz 包功能验证 | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pigz_01 | File system common command test-pigz | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_pigz_02 | File system common command test-pigz | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pigz_03 | File system common command test-pigz | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pigz_04 | File system common command test-pigz | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pigz_05 | File system common command test-pigz | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pigz_06 | File system common command test-pigz | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pigz_07 | File system common command test-pigz | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pigz_08 | File system common command test-pigz | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_pigz_09 | File system common command test-pigz | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_pigz_10 | File system common command test-pigz | pre_test/run_test/post_test | 4 |  |  |  |

### 断言与命令明细

#### oe_test_pigz

- 描述：pigz 包功能验证
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0  "pgiz compression failure"
  CHECK_RESULT $? 0 0  "The number of threads displayed is greater than the set number of threads 8"
  CHECK_RESULT $? 0 0  "pgiz cannot be used with tar"
```

- 涉及命令：pigz×1, tar×1

#### oe_test_pigz_01

- 描述：File system common command test-pigz
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "pigz -z command execution failure"
  CHECK_RESULT $? 0 0 "pigz -d command execution failure"
  CHECK_RESULT $? 0 0 "pigz -k command execution failure"
  CHECK_RESULT $? 0 0 "pigz -f command execution failure"
  CHECK_RESULT $? 0 0 "pigz -r command execution failure"
```

- 涉及命令：pigz×5, test×4

#### oe_test_pigz_02

- 描述：File system common command test-pigz
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "pigz -9 command execution failure"
  CHECK_RESULT $? 0 0 "pigz -l command execution failure"
  CHECK_RESULT $? 0 0 "pigz -L command execution failure"
  CHECK_RESULT $? 0 0 "pigz -f command execution failure"
```

- 涉及命令：pigz×4, test×2

#### oe_test_pigz_03

- 描述：File system common command test-pigz
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "pigz -A command execution failure"
  CHECK_RESULT $? 0 0 "pigz -b command execution failure"
  CHECK_RESULT $? 0 0 "pigz -l command execution failure"
  CHECK_RESULT $? 0 0 "pigz -p command execution failure"
```

- 涉及命令：pigz×4, test×2

#### oe_test_pigz_04

- 描述：File system common command test-pigz
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "pigz -F command execution failure"
  CHECK_RESULT $? 0 0 "pigz -H command execution failure"
  CHECK_RESULT $? 0 0 "pigz --list command execution failure"
  CHECK_RESULT $? 0 0 "pigz -m command execution failure"
```

- 涉及命令：pigz×3, test×3

#### oe_test_pigz_05

- 描述：File system common command test-pigz
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "pigz -N command execution failure"
  CHECK_RESULT $? 0 0 "pigz -d command execution failure"
  CHECK_RESULT $? 0 0 "pigz -O command execution failure"
  CHECK_RESULT $? 0 1 "pigz -O command execution failure"
```

- 涉及命令：pigz×5, test×4

#### oe_test_pigz_06

- 描述：File system common command test-pigz
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "pigz -R command execution failure"
  CHECK_RESULT $? 0 0 "pigz -q command execution failure"
  CHECK_RESULT $? 0 0 "pigz -S command execution failure"
  CHECK_RESULT $? 0 0 "pigz -U command execution failure"
```

- 涉及命令：pigz×6, test×4

#### oe_test_pigz_07

- 描述：File system common command test-pigz
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "pigz -J command execution failure"
  CHECK_RESULT $? 0 0 "pigz -t command execution failure"
  CHECK_RESULT $? 0 0 "pigz -d command execution failure"
  CHECK_RESULT $? 0 0 "pigz -K command execution failure"
  CHECK_RESULT $? 0 0 "pigz -d command execution failure"
  CHECK_RESULT $? 0 0 "pigz -Y command execution failure"
```

- 涉及命令：pigz×6, test×3

#### oe_test_pigz_08

- 描述：File system common command test-pigz
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "pigz -M command execution failure"
  CHECK_RESULT $? 0 0 "pigz -d command execution failure"
  CHECK_RESULT $? 0 0 "pigz -H command execution failure"
  CHECK_RESULT $? 0 0 "pigz -d command execution failure"
  CHECK_RESULT $? 0 0 "pigz -c command execution failure"
```

- 涉及命令：pigz×5, test×3

#### oe_test_pigz_09

- 描述：File system common command test-pigz
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "pigz -K command execution failure"
  CHECK_RESULT $? 0 0 "pigz -d command execution failure"
  CHECK_RESULT $? 0 0 "pigz -n command execution failure"
  CHECK_RESULT $? 0 0 "pigz -d command execution failure"
  CHECK_RESULT $? 0 0 "pigz --huffman command execution failure"
```

- 涉及命令：pigz×4, test×3

#### oe_test_pigz_10

- 描述：File system common command test-pigz
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "pigz --force command execution failure"
  CHECK_RESULT $? 0 0 "pigz -d command execution failure"
  CHECK_RESULT $? 0 0 "pigz --independent command execution failure"
  CHECK_RESULT $? 0 0 "pigz --stdout command execution failure"
```

- 涉及命令：test×3, pigz×1
