# valgrind_3.13.0

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/valgrind` |
| 注册用例数 | 28 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_valgrind | Command test valgrind | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_valgrind_01 | Command test valgrind | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_valgrind_02 | Command test valgrind | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_valgrind_03 | Command test valgrind | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_valgrind_04 | Command test valgrind | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_valgrind_05 | Command test valgrind | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_valgrind_06 | Command test valgrind | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_valgrind_07 | Command test valgrind | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_valgrind_08 | Command test valgrind | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_valgrind_09 | Command test valgrind | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_valgrind_10 | Command test valgrind | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_valgrind_11 | Command test valgrind | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_valgrind_12 | Command test valgrind | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_valgrind_13 | Command test valgrind | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_valgrind_14 | Command test valgrind | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_valgrind_15 | Command test valgrind | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_valgrind_16 | Command test valgrind | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_valgrind_17 | Test valgrind | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_valgrind_18 | Test valgrind | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_valgrind_19 | Test valgrind | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_valgrind_20 | Test valgrind | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_valgrind_21 | Test valgrind | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_cg_annotate_01 | Command test cg_annotate | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_cg_merge_01 | Command test cg_merge | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_cg_diff_01 | Command test cg_diff | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_callgrind_annotate_01 | Command test callgrind_annotate | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_callgrind_control_01 | Command test callgrind_control | pre_test/run_test/post_test | 17 | ✔ |  |  |
| oe_test_ms_print_01 | Command test ms_print | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_valgrind

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check valgrind version error"
  CHECK_RESULT $? 0 0 "compile valgrind_test error"
  CHECK_RESULT $? 0 0 "execute valgrind command error"
  CHECK_RESULT $? 0 0 "check valgrind_test.log error"
```

- 涉及命令：gcc×1

#### oe_test_valgrind_01

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind -h error"
  CHECK_RESULT $? 0 0 "execute valgrind -help error"
  CHECK_RESULT $? 0 0 "execute valgrind --help-debug error"
  CHECK_RESULT $? 0 0 "execute valgrind --version error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool error"
  CHECK_RESULT $? 0 0 "execute valgrind --leak-check error"
  CHECK_RESULT $? 0 0 "execute valgrind --leak-resolution error"
  CHECK_RESULT $? 0 0 "execute valgrind --show-leak-kinds error"
  CHECK_RESULT $? 0 0 "execute valgrind --errors-for-leak-kinds error"
  CHECK_RESULT $? 0 0 "execute valgrind --leak-check-heuristics error"
```

- 涉及命令：valgrind×1

#### oe_test_valgrind_02

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --show-reachable error"
  CHECK_RESULT $? 0 0 "execute valgrind --show-possibly-lost error"
  CHECK_RESULT $? 0 0 "execute valgrind --xtree-leak error"
  CHECK_RESULT $? 0 0 "execute valgrind --xtree-leak-file error"
  CHECK_RESULT $? 0 0 "execute valgrind --expensive-definedness-checks error"
  CHECK_RESULT $? 0 0 "execute valgrind --keep-stacktraces error"
  CHECK_RESULT $? 0 0 "execute valgrind --freelist-vol error"
  CHECK_RESULT $? 0 0 "execute valgrind --freelist-vol error"
  CHECK_RESULT $? 0 0 "execute valgrind --workaround-gcc296-bugs error"
  CHECK_RESULT $? 0 0 "execute valgrind --show-mismatched-frees error"
```

#### oe_test_valgrind_03

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind -q error"
  CHECK_RESULT $? 0 0 "execute valgrind --quiet error"
  CHECK_RESULT $? 0 0 "execute valgrind -v error"
  CHECK_RESULT $? 0 0 "execute valgrind --verbose error"
  CHECK_RESULT $? 0 0 "execute valgrind --trace-children error"
  CHECK_RESULT $? 0 0 "execute valgrind --trace-children-skip error"
  CHECK_RESULT $? 0 0 "execute valgrind --trace-children-skip-by-arg error"
  CHECK_RESULT $? 0 0 "execute valgrind --child-silent-after-fork error"
  CHECK_RESULT $? 0 0 "execute valgrind --vgdb error"
  CHECK_RESULT $? 0 0 "execute valgrind --vgdb error"
  CHECK_RESULT $? 0 0 "execute valgrind --track-fds error"
  CHECK_RESULT $? 0 0 "execute valgrind --time-stamp error"
```

- 涉及命令：valgrind×2, grep×1

#### oe_test_valgrind_04

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --malloc-fill error"
  CHECK_RESULT $? 0 0 "execute valgrind --free-fill error"
  CHECK_RESULT $? 0 0 "execute valgrind --log-fd error"
  CHECK_RESULT $? 0 0 "execute valgrind --log-file error"
  CHECK_RESULT $? 0 0 "execute valgrind --log-socket error"
```

#### oe_test_valgrind_05

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --xml error"
  CHECK_RESULT $? 0 0 "execute valgrind --xml-fd error"
  CHECK_RESULT $? 0 0 "execute valgrind --xml-file error"
  CHECK_RESULT $? 0 0 "execute valgrind --log-socket error"
  CHECK_RESULT $? 0 0 "execute valgrind --xml-user-comment error"
  CHECK_RESULT $? 0 0 "execute valgrind --demangle error"
  CHECK_RESULT $? 0 0 "execute valgrind --num-callers error"
  CHECK_RESULT $? 0 0 "execute valgrind --error-limit error"
  CHECK_RESULT $? 1 0 "execute valgrind --error-exitcode error"
```

#### oe_test_valgrind_06

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --sigill-diagnostics error"
  CHECK_RESULT $? 0 0 "execute valgrind --show-below-main error"
  CHECK_RESULT $? 0 0 "execute valgrind --fullpath-after error"
  CHECK_RESULT $? 0 0 "execute valgrind --extra-debuginfo-path error"
  CHECK_RESULT $? 0 0 "execute valgrind --allow-mismatched-debuginfo error"
  CHECK_RESULT $? 0 0 "execute valgrind --suppressions error"
  CHECK_RESULT $? 0 0 "execute valgrind --gen-suppressions error"
  CHECK_RESULT $? 0 0 "execute valgrind --input-fd error"
```

#### oe_test_valgrind_07

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --max-stackframe error"
  CHECK_RESULT $? 0 0 "execute valgrind --main-stacksize error"
  CHECK_RESULT $? 0 0 "execute valgrind --max-threads error"
  CHECK_RESULT $? 0 0 "execute valgrind --alignment error"
  CHECK_RESULT $? 0 0 "execute valgrind --redzone-size error"
  CHECK_RESULT $? 0 0 "execute valgrind --xtree-memory  error"
  CHECK_RESULT $? 0 0 "execute valgrind --xtree-memory-file  error"
```

#### oe_test_valgrind_08

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --smc-check error"
  CHECK_RESULT $? 0 0 "execute valgrind --read-inline-info error"
  CHECK_RESULT $? 0 0 "execute valgrind --read-var-info error"
  CHECK_RESULT $? 0 0 "execute valgrind --vgdb-poll error"
  CHECK_RESULT $? 0 0 "execute valgrind --vgdb-shadow-registers error"
  CHECK_RESULT $? 0 0 "execute valgrind --vgdb-prefix error"
  CHECK_RESULT $? 0 0 "execute valgrind --run-libc-freeres error"
  CHECK_RESULT $? 0 0 "execute valgrind --run-cxx-freeres error"
  CHECK_RESULT $? 0 0 "execute valgrind --sim-hints error"
  CHECK_RESULT $? 0 0 "execute valgrind --fair-sched error"
```

#### oe_test_valgrind_09

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --kernel-variant error"
  CHECK_RESULT $? 0 0 "execute valgrind --merge-recursive-frames error"
  CHECK_RESULT $? 0 0 "execute valgrind --num-transtab-sectors error"
  CHECK_RESULT $? 0 0 "execute valgrind --avg-transtab-entry-size error"
  CHECK_RESULT $? 0 0 "execute valgrind --aspace-minaddr error"
  CHECK_RESULT $? 0 0 "execute valgrind --valgrind-stacksize error"
  CHECK_RESULT $? 0 0 "execute valgrind --show-emwarns error"
  CHECK_RESULT $? 0 0 "execute valgrind --show-emwarns error"
  CHECK_RESULT $? 0 0 "execute valgrind --require-text-symbol error"
  CHECK_RESULT $? 0 0 "execute valgrind --soname-synonyms error"
```

#### oe_test_valgrind_10

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --undef-value-errors error"
  CHECK_RESULT $? 0 0 "execute valgrind --track-origins error"
  CHECK_RESULT $? 0 0 "execute valgrind --partial-loads-ok error"
  CHECK_RESULT $? 0 0 "execute valgrind --vgdb-stop-at error"
  CHECK_RESULT $? 0 0 "execute valgrind --unw-stack-scan-thresh error"
  CHECK_RESULT $? 0 0 "execute valgrind --unw-stack-scan-frames error"
  CHECK_RESULT $? 0 0 "execute valgrind --dsymutil error"
```

#### oe_test_valgrind_11

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --cachegrind-out-file error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --cache-sim error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --branch-sim error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --I1 error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --D1 error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --I1 error"
```

#### oe_test_valgrind_12

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --callgrind-out-file error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --dump-line error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --dump-instr error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --compress-strings error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --compress-pos error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --combine-dumps error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --dump-every-bb error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --dump-before error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --zero-before error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --dump-after error"
```

#### oe_test_valgrind_13

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --instr-atstart error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --collect-atstart error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --toggle-collect error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --collect-jumps error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --collect-bus error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --separate-threads error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --separate-callers error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --separate-callers2 error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --separate-recs error"
```

#### oe_test_valgrind_14

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --separate-recs3 error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --skip-plt error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --skip-direct-rec error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --fn-skip error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --cache-sim error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --branch-sim error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --simulate-wb error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --simulate-hwpref error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --cacheuse error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --I1 error"
```

#### oe_test_valgrind_15

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --D1 error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --LL error"
```

#### oe_test_valgrind_16

- 描述：Command test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --tool=helgrind --free-is-write error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=helgrind --track-lockorders error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=helgrind --history-level error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=helgrind --conflict-cache-size error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=helgrind --check-stack-refs error"
  CHECK_RESULT $? 0 0 "execute valgrind --tool=helgrind --ignore-thread-creation error"
```

#### oe_test_valgrind_17

- 描述：Test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --check-stack-var error"
  CHECK_RESULT $? 0 0 "execute valgrind --exclusive-threshold error"
  CHECK_RESULT $? 0 0 "execute valgrind --first-race-only error"
  CHECK_RESULT $? 0 0 "execute valgrind --free-is-write error"
  CHECK_RESULT $? 0 0 "execute valgrind --join-list-vol error"
  CHECK_RESULT $? 0 0 "execute valgrind --report-signal-unlocked error"
  CHECK_RESULT $? 0 0 "execute valgrind --segment-merging error"
  CHECK_RESULT $? 0 0 "execute valgrind --segment-merging-interval error"
  CHECK_RESULT $? 0 0 "execute valgrind --shared-threshold error"
  CHECK_RESULT $? 0 0 "execute valgrind --show-confl-seg error"
```

- 涉及命令：gcc×1

#### oe_test_valgrind_18

- 描述：Test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --show-stack-usage error"
  CHECK_RESULT $? 0 0 "execute valgrind --ignore-thread-creation error"
  CHECK_RESULT $? 0 0 "execute valgrind --ptrace-addr error"
  CHECK_RESULT $? 0 0 "execute valgrind --trace-addr error"
  CHECK_RESULT $? 0 0 "execute valgrind --trace-alloc error"
  CHECK_RESULT $? 0 0 "execute valgrind --trace-barrier error"
  CHECK_RESULT $? 0 0 "execute valgrind --trace-cond error"
  CHECK_RESULT $? 0 0 "execute valgrind --trace-fork-join error"
  CHECK_RESULT $? 0 0 "execute valgrind --trace-hb error"
  CHECK_RESULT $? 0 0 "execute valgrind --trace-mutex error"
```

- 涉及命令：gcc×1

#### oe_test_valgrind_19

- 描述：Test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --heap=no|yes error"
  CHECK_RESULT $? 0 0 "execute valgrind --heap-admin=<size> error"
  CHECK_RESULT $? 0 0 "execute valgrind --stacks=no|yes error"
  CHECK_RESULT $? 0 0 "execute valgrind --pages-as-heap=no|yes error"
  CHECK_RESULT $? 0 0 "execute valgrind --depth=<number> error"
  CHECK_RESULT $? 0 0 "execute valgrind --alloc-fn=<name> error"
  CHECK_RESULT $? 0 0 "execute valgrind --ignore-fn=<name> error"
  CHECK_RESULT $? 0 0 "execute valgrind ---threshold=<m.n> error"
```

- 涉及命令：gcc×1

#### oe_test_valgrind_20

- 描述：Test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --peak-inaccuracy=<m.n> error"
  CHECK_RESULT $? 0 0 "execute valgrind --time-unit=i|ms|B error"
  CHECK_RESULT $? 0 0 "execute valgrind --detailed-freq=<N> error"
  CHECK_RESULT $? 0 0 "execute valgrind --max-snapshots=<N> error"
  CHECK_RESULT $? 0 0 "execute valgrind --massif-out-file=<file> error"
```

#### oe_test_valgrind_21

- 描述：Test valgrind
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "execute valgrind --basic-counts=<no|yes> [default: yes] error"
  CHECK_RESULT $? 0 0 "execute valgrind --detailed-counts=<no|yes> [default: no] error"
  CHECK_RESULT $? 0 0 "execute valgrind --trace-mem=<no|yes> [default: no] error"
  CHECK_RESULT $? 0 0 "execute valgrind --trace-superblocks=<no|yes> [default: no] error"
  CHECK_RESULT $? 0 0 "execute valgrind --fnname=<name> [default: main] error"
  CHECK_RESULT $? 0 0 "execute valgrind --bb-out-file=<name> [default: bb.out.%p] error"
  CHECK_RESULT $? 0 0 "execute valgrind --pc-out-file=<name> [default: pc.out.%p] error"
  CHECK_RESULT $? 0 0 "execute valgrind --interval-size=<number> [default: 100000000] error"
```

#### oe_test_cg_annotate_01

- 描述：Command test cg_annotate
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "prepare cachegrind.out file fail"
  CHECK_RESULT $? 0 0 "execute cg_annotate -h error"
  CHECK_RESULT $? 0 0 "execute cg_annotate --help error"
  CHECK_RESULT $? 0 0 "execute cg_annotate --version error"
  CHECK_RESULT $? 0 0 "execute cg_annotate --show error"
  CHECK_RESULT $? 0 0 "execute cg_annotate --sort error"
  CHECK_RESULT $? 0 0 "execute vcg_annotate --threshold  error"
  CHECK_RESULT $? 0 0 "execute vcg_annotate --auto error"
  CHECK_RESULT $? 0 0 "execute vcg_annotate --context error"
  CHECK_RESULT $? 0 0 "execute callgrind_annotate -I error"
  CHECK_RESULT $? 0 0 "execute callgrind_annotate --include error"
```

- 涉及命令：cg_annotate×1, grep×1, callgrind_annotate×1

#### oe_test_cg_merge_01

- 描述：Command test cg_merge
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "prepare cachegrind.out file fail"
  CHECK_RESULT $? 0 0 "execute cg_merge -o error"
```

- 涉及命令：cg_merge×1

#### oe_test_cg_diff_01

- 描述：Command test cg_diff
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "prepare cachegrind.out file fail"
  CHECK_RESULT $? 0 0 "execute cg_diff -h error"
  CHECK_RESULT $? 0 0 "execute cg_diff --help error"
  CHECK_RESULT $? 0 0 "execute cg_diff -v error"
  CHECK_RESULT $? 0 0 "execute cg_diff --version error"
  CHECK_RESULT $? 0 0 "execute cg_diff --mod-filename error"
  CHECK_RESULT $? 0 0 "execute cg_diff --mod-funcname error"
```

- 涉及命令：cg_diff×2, grep×1

#### oe_test_callgrind_annotate_01

- 描述：Command test callgrind_annotate
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "prepare callgrind.out file fail"
  CHECK_RESULT $? 0 0 "execute callgrind_annotate -h error"
  CHECK_RESULT $? 0 0 "execute callgrind_annotate --help error"
  CHECK_RESULT $? 0 0 "execute callgrind_annotate --version error"
  CHECK_RESULT $? 0 0 "execute allgrind_annotate --show error"
  CHECK_RESULT $? 0 0 "execute callgrind_annotate --sort error"
  CHECK_RESULT $? 0 0 "execute callgrind_annotate --threshold  error"
  CHECK_RESULT $? 0 0 "execute callgrind_annotate --auto error"
  CHECK_RESULT $? 0 0 "execute callgrind_annotate --context error"
  CHECK_RESULT $? 0 0 "execute callgrind_annotate --inclusive error"
  CHECK_RESULT $? 0 0 "execute callgrind_annotate --tree error"
  CHECK_RESULT $? 0 0 "execute callgrind_annotate -I error"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：callgrind_annotate×2, grep×1

#### oe_test_callgrind_control_01

- 描述：Command test callgrind_control
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "prepare callgrind.out.* file fail"
  CHECK_RESULT $? 0 0 "execute callgrind_control -h error"
  CHECK_RESULT $? 0 0 "execute callgrind_control --help error"
  CHECK_RESULT $? 0 0 "execute callgrind_control --version error"
  CHECK_RESULT $? 0 0 "execute callgrind_control -s error"
  CHECK_RESULT $? 0 0 "execute callgrind_control --stat error"
  CHECK_RESULT $? 0 0 "execute callgrind_control -b error"
  CHECK_RESULT $? 0 0 "execute callgrind_control --back error"
  CHECK_RESULT $? 0 0 "execute callgrind_control -e error"
  CHECK_RESULT $? 0 0 "execute callgrind_control --dump error"
  CHECK_RESULT $? 0 0 "execute callgrind_control -z error"
  CHECK_RESULT $? 0 0 "execute callgrind_control --zero error"
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：callgrind_control×7, grep×1

#### oe_test_ms_print_01

- 描述：Command test ms_print
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "prepare massif.out file fail"
  CHECK_RESULT $? 0 0 "execute usage: ms_print -h error"
  CHECK_RESULT $? 0 0 "execute usage: ms_print --help error"
  CHECK_RESULT $? 0 0 "execute ms_print --version error"
  CHECK_RESULT $? 0 0 "execute ms_print --threshold error"
  CHECK_RESULT $? 0 0 "execute ms_print --x error"
  CHECK_RESULT $? 0 0 "execute ms_print --y error"
```

- 涉及命令：ms_print×1, grep×1
