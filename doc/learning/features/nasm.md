# nasm

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nasm` |
| 注册用例数 | 16 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_nasm_01 | verify the uasge of nasm command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_nasm_02 | verify the uasge of nasm command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_nasm_03 | verify the uasge of nasm command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_nasm_04 | verify the uasge of nasm command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_nasm_05 | verify the uasge of nasm command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_nasm_06 | verify the uasge of nasm command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_nasm_07 | verify the uasge of nasm command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_nasm_08 | verify the uasge of nasm command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_nasm_09 | verify the uasge of nasm command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_nasm_10 | verify the uasge of nasm command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_nasm_11 | verify the uasge of nasm command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_nasm_12 | verify the uasge of nasm command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_nasm_13 | verify the uasge of nasm command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_nasm_ndisasm_01 | verify the uasge of nasm command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_nasm_ndisasm_02 | verify the uasge of nasm command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_nasm_14 | Compile assembly code into an executable file | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_nasm_01

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check nasm -h failed"
  CHECK_RESULT $? 0 0 "Check nasm -v failed"
  CHECK_RESULT $? 0 0 "Check nasm -@ failed"
  CHECK_RESULT $? 0 0 "Check nasm -o failed"
  CHECK_RESULT $? 0 0 "Check nasm --keep-all failed"
  CHECK_RESULT $? 0 0 "Check nasm -X gun failed"
  CHECK_RESULT $? 0 0 "Check nasm -X vc failed"
  CHECK_RESULT $? 0 0 "Check nasm -s failed"
  CHECK_RESULT $? 0 0 "Check nasm -Zfile failed"
  CHECK_RESULT $? 0 0 "Check nasm -M failed"
```

- 涉及命令：nasm×6

#### oe_test_nasm_02

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check nasm -MG failed"
  CHECK_RESULT $? 0 0 "Check nasm -MF failed"
  CHECK_RESULT $? 0 0 "Check nasm -MD failed"
  CHECK_RESULT $? 0 0 "Check nasm -MT failed"
  CHECK_RESULT $? 0 0 "Check nasm -MQ failed"
  CHECK_RESULT $? 0 0 "Check nasm -MP failed"
  CHECK_RESULT $? 0 0 "Check nasm -f bin failed"
  CHECK_RESULT $? 0 0 "Check nasm -f ith failed"
  CHECK_RESULT $? 0 0 "Check nasm -f srec failed"
  CHECK_RESULT $? 0 0 "Check nasm -f aout failed"
```

- 涉及命令：nasm×10

#### oe_test_nasm_03

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check nasm -f aoutb failed"
  CHECK_RESULT $? 0 0 "Check nasm -f coff failed"
  CHECK_RESULT $? 0 0 "Check nasm -f elf32 failed"
  CHECK_RESULT $? 0 0 "Check nasm -f elf64 failed"
  CHECK_RESULT $? 0 0 "Check nasm -f elfx32 failed"
  CHECK_RESULT $? 0 0 "Check nasm -f as86 failed"
  CHECK_RESULT $? 0 0 "Check nasm -f obj failed"
  CHECK_RESULT $? 0 0 "Check nasm -f win32 failed"
  CHECK_RESULT $? 0 0 "Check nasm -f win64 failed"
```

- 涉及命令：nasm×9

#### oe_test_nasm_04

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check nasm -f macho32 failed"
  CHECK_RESULT $? 0 0 "Check nasm -f dbg failed"
  CHECK_RESULT $? 0 0 "Check nasm -f elf failed"
  CHECK_RESULT $? 0 0 "Check nasm -f macho failed"
  CHECK_RESULT $? 0 0 "Check nasm -f win failed"
  CHECK_RESULT $? 0 0 "Check nasm -g failed"
  CHECK_RESULT $? 0 0 "Check nasm -F stabs failed"
  CHECK_RESULT $? 0 0 "Check nasm -F dwarf failed"
  CHECK_RESULT $? 0 0 "Check nasm -l failed"
```

- 涉及命令：nasm×8

#### oe_test_nasm_05

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check nasm -Lb failed"
  CHECK_RESULT $? 0 0 "Check nasm -Ld failed"
  CHECK_RESULT $? 0 0 "Check nasm -Le failed"
  CHECK_RESULT $? 0 0 "Check nasm -Lf failed"
  CHECK_RESULT $? 0 0 "Check nasm -Lm failed"
  CHECK_RESULT $? 0 0 "Check nasm -Lp failed"
  CHECK_RESULT $? 0 0 "Check nasm -Ls failed"
  CHECK_RESULT $? 0 0 "Check nasm -Lw failed"
  CHECK_RESULT $? 0 0 "Check nasm -L+ failed"
  CHECK_RESULT $? 0 0 "Check nasm -O0 failed"
```

- 涉及命令：nasm×10

#### oe_test_nasm_06

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check nasm -O1 failed"
  CHECK_RESULT $? 0 0 "Check nasm -Ox failed"
  CHECK_RESULT $? 0 0 "Check nasm -Ov failed"
  CHECK_RESULT $? 0 0 "Check nasm -t failed"
  CHECK_RESULT $? 0 0 "Check nasm -E failed"
  CHECK_RESULT $? 0 0 "Check nasm -e failed"
  CHECK_RESULT $? 0 0 "Check nasm -a failed"
  CHECK_RESULT $? 0 0 "Check nasm -Ipath failed"
  CHECK_RESULT $? 0 0 "Check nasm -Pfile failed"
  CHECK_RESULT $? 0 0 "Check nasm -Damcro failed"
```

- 涉及命令：nasm×10

#### oe_test_nasm_07

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check nasm -Umacro failed"
  CHECK_RESULT $? 0 0 "Check nasm -pragma failed"
  CHECK_RESULT $? 0 0 "Check nasm --no-line failed"
  CHECK_RESULT $? 0 0 "Check nasm --prefix failed"
  CHECK_RESULT $? 0 0 "Check nasm --lprefix failed"
  CHECK_RESULT $? 0 0 "Check nasm --lpostfix failed"
  CHECK_RESULT $? 0 0 "Check nasm -w+x failed"
  CHECK_RESULT $? 0 0 "Check nasm -w-x failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error failed"
```

- 涉及命令：nasm×4

#### oe_test_nasm_08

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=all failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=bnd failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=db-empty failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=environment failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=float failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=float-denorm failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=float-overflow failed"
```

- 涉及命令：nasm×7

#### oe_test_nasm_09

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=float-toolong failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=float-underflow failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=hle failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=label failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=label-orphan failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=label-redef failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=label-redef-late failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=lock failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-def failed"
```

- 涉及命令：nasm×10

#### oe_test_nasm_10

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-def-case-single failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-def-greedy-single failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-def-param-single failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=negative-rep failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=number-overflow failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=obsolete failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=obsolete-nop failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=obsolete-removed failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=obsolete-valid failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=phase failed"
```

- 涉及命令：nasm×10

#### oe_test_nasm_11

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=pragma failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=pragma-bad failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=pragma-empty failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=pragma-na failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=pragma-unknown failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=ptr failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=regsize failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=unknown-warning failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=user failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=warn-stack-empty failed"
```

- 涉及命令：nasm×10

#### oe_test_nasm_12

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=zeroing failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=zext-reloc failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=other failed"
  CHECK_RESULT $? 0 0 "Check nasm -limit-passes failed"
  CHECK_RESULT $? 0 0 "Check nasm -limit-stalled-passes failed"
  CHECK_RESULT $? 0 0 "Check nasm -limit-macro-levels failed"
  CHECK_RESULT $? 0 0 "Check nasm limit-macro-tokens failed"
  CHECK_RESULT $? 0 0 "Check nasm -limit-rep failed"
  CHECK_RESULT $? 0 0 "Check nasm -limit-eval failed"
  CHECK_RESULT $? 0 0 "Check nasm -limit-lines failed"
```

- 涉及命令：nasm×10

#### oe_test_nasm_13

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check nasm -f macho32 failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=other failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-params failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-params-legacy failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-params-multi failed"
  CHECK_RESULT $? 0 0 "Check nasm -w[+-]error=macro-params-single failed"
  CHECK_RESULT $? 0 0 "Check nasm nasm --before failed"
  CHECK_RESULT $? 0 0 "Check nasm nasm -f -gdwarf failed"
  CHECK_RESULT $? 0 0 "Check nasm nasm --postfix failed"
  CHECK_RESULT $? 0 0 "Check nasm nasm --gpostfix failed"
  CHECK_RESULT $? 0 0 "Check nasm nasm --prefix failed"
```

- 涉及命令：nasm×7

#### oe_test_nasm_ndisasm_01

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check ndisasm -a failed"
  CHECK_RESULT $? 0 0 "Check ndisasm -i failed"
  CHECK_RESULT $? 0 0 "Check ndisasm -u failed"
  CHECK_RESULT $? 0 0 "Check ndisasm -b failed"
  CHECK_RESULT $? 0 0 "Check ndisasm -h failed"
  CHECK_RESULT $? 0 0 "Check ndisasm -r failed"
  CHECK_RESULT $? 0 0 "Check ndisasm -v failed"
  CHECK_RESULT $? 0 0 "Check ndisasm -e failed"
  CHECK_RESULT $? 0 0 "Check ndisasm -k failed"
```

- 涉及命令：ndisasm×9

#### oe_test_nasm_ndisasm_02

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check ndisasm -p failed"
  CHECK_RESULT $? 0 0 "Check ndisasm -o failed"
  CHECK_RESULT $? 0 0 "Check ndisasm -o failed"
```

- 涉及命令：ndisasm×3

#### oe_test_nasm_14

- 描述：Compile assembly code into an executable file
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check nasm -f elf64 failed"
  CHECK_RESULT $? 0 0 "your_file.o does not match the expected output"
  CHECK_RESULT $? 0 0 "Failed to compile assembly code into an executable file"
  CHECK_RESULT $? 0 0 "your_program cannot be executed"
```

- 涉及命令：test×2, nasm×1
