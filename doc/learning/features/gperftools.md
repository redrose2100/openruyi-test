# gperftools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/gperftools` |
| 注册用例数 | 6 |
| 环境约束 | machine num = 1；machine type = kvm；add network interface = 1；add disk =  |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_count_gperftools_function | gperftools-功能验证 | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_gperftools_tcmalloc | gperftools-TCMalloc basic functionality | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_gperftools_heap_profiler | gperftools-Heap profiler functionality | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_gperftools_heap_checker | gperftools-Heap checker memory leak detection | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_gperftools_pprof_formats | gperftools-pprof analysis tool with various output formats | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_gperftools_env_runtime | gperftools-Environment variables and runtime features | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_count_gperftools_function

- 描述：gperftools-功能验证
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "File creation failed"
  CHECK_RESULT $? 0 0 "Output failed"
```

- 涉及命令：test×4

#### oe_test_gperftools_tcmalloc

- 描述：gperftools-TCMalloc basic functionality
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile with tcmalloc_minimal"
  CHECK_RESULT $? 0 0 "tcmalloc_minimal basic test failed"
  CHECK_RESULT $? 0 0 "Failed to compile with tcmalloc"
  CHECK_RESULT $? 0 0 "tcmalloc basic test failed"
  CHECK_RESULT $? 0 0 "libtcmalloc.so not found"
  CHECK_RESULT $? 0 0 "libtcmalloc_minimal.so not found"
  CHECK_RESULT $? 0 0 "tcmalloc.h header not found"
  CHECK_RESULT $? 0 0 "libtcmalloc_debug.so not found"
  CHECK_RESULT $? 0 0 "libtcmalloc_and_profiler.so not found"
```

- 涉及命令：test×5, gcc×2

#### oe_test_gperftools_heap_profiler

- 描述：gperftools-Heap profiler functionality
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile with tcmalloc for heap profiling"
  CHECK_RESULT $? 0 0 "Heap profiler execution failed"
  CHECK_RESULT $? 0 0 "Heap profile files not generated"
  CHECK_RESULT $? 0 0 "Heap profile file is empty"
  CHECK_RESULT $? 0 0 "pprof heap text analysis failed"
  CHECK_RESULT $? 0 0 "pprof heap text output invalid"
  CHECK_RESULT $? 0 0 "heap-profiler.h header not found"
```

- 涉及命令：test×2, gcc×1, grep×1

#### oe_test_gperftools_heap_checker

- 描述：gperftools-Heap checker memory leak detection
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile memory leak test"
  CHECK_RESULT $? 0 0 "Heap checker did not detect memory leak"
  CHECK_RESULT $? 0 0 "Failed to compile no leak test"
  CHECK_RESULT $? 0 0 "No leak test failed with heap checker"
  CHECK_RESULT $? 0 0 "Heap checker incorrectly reported leak for clean program"
  CHECK_RESULT $? 0 0 "heap-checker.h header not found"
```

- 涉及命令：gcc×2, grep×2, test×1

#### oe_test_gperftools_pprof_formats

- 描述：gperftools-pprof analysis tool with various output formats
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile pprof test program"
  CHECK_RESULT $? 0 0 "CPU profile generation failed"
  CHECK_RESULT $? 0 0 "pprof --text analysis failed"
  CHECK_RESULT $? 0 0 "pprof --text output invalid"
  CHECK_RESULT $? 0 0 "pprof --list analysis failed"
  CHECK_RESULT $? 0 0 "pprof --disasm analysis failed"
  CHECK_RESULT $? 0 0 "pprof --callgrind output failed"
  CHECK_RESULT $? 0 0 "pprof --raw output failed"
  CHECK_RESULT $? 0 0 "pprof --help failed"
  CHECK_RESULT $? 0 0 "pprof help output invalid"
```

- 涉及命令：grep×2, gcc×1

#### oe_test_gperftools_env_runtime

- 描述：gperftools-Environment variables and runtime features
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile environment test"
  CHECK_RESULT $? 0 0 "MALLOCSTATS test failed"
  CHECK_RESULT $? 0 0 "MALLOCSTATS output invalid"
  CHECK_RESULT $? 0 0 "HEAPPROFILE with interval test failed"
  CHECK_RESULT $? 0 0 "Heap profile with interval not generated"
  CHECK_RESULT $? 0 0 "CPUPROFILE_FREQUENCY test failed"
  CHECK_RESULT $? 0 0 "CPU profile with frequency not generated"
  CHECK_RESULT $? 0 0 "Failed to compile plain test program"
  CHECK_RESULT $? 0 0 "LD_PRELOAD tcmalloc_minimal test failed"
  CHECK_RESULT $? 0 0 "libtcmalloc_minimal_debug.so not found"
```

- 涉及命令：gcc×2, test×2, grep×1
