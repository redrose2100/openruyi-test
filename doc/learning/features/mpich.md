# mpich

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/mpich` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_mpich_mpiexec_01 | verify the uasge of mpich command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_mpich_mpiexec_02 | verify the uasge of mpich command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_mpich_mpirun_01 | verify the uasge of mpich command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_mpich_mpirun_02 | verify the uasge of mpich command | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_mpich_mpiexec_01

- 描述：verify the uasge of mpich command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check mpiexec -genv -genvlist -envnone -verbose failed"
  CHECK_RESULT $? 0 0 "Check mpiexec -genvnone failed"
  CHECK_RESULT $? 0 0 "Check mpiexec -genvall failed"
  CHECK_RESULT $? 0 0 "Check mpiexec -f -hosts failed"
  CHECK_RESULT $? 0 0 "Check mpiexec -wdir failed"
  CHECK_RESULT $? 0 0 "Check mpiexec -configfile failed"
  CHECK_RESULT $? 0 0 "Check mpiexec -envlist failed"
  CHECK_RESULT $? 0 0 "Check mpiexec -genv -genvlist -envnone -info  failed"
  CHECK_RESULT $? 0 0 "Check mpiexec -print-all-exitcodes -iface -ppn -profile -prepend-rank -prepend-pattern failed"
  CHECK_RESULT $? 0 0 "Check mpiexec -outfile-pattern -errfile-pattern -nameserver -disable-auto-cleanup -disable-hostname-propagation failed"
```

- 涉及命令：mpiexec×10

#### oe_test_mpich_mpiexec_02

- 描述：verify the uasge of mpich command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check mpiexec -order-nodes failed"
  CHECK_RESULT $? 0 0 "Check mpiexec -membind -map-by -bind-to -topolib -localhost -rmk -usize failed"
  CHECK_RESULT $? 0 0 "Check mpiexec -ckpointlib -demux -ckpoint-nu -ckpoint-prefix -ckpoint-interval -ckpointlib failed"
  CHECK_RESULT $? 0 0 "Check mpiexec -launcher failed"
  CHECK_RESULT $? 0 0 "Check mpiexec --help failed"
```

- 涉及命令：mpiexec×4

#### oe_test_mpich_mpirun_01

- 描述：verify the uasge of mpich command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check mpirun -genv -genvlist -envnone -verbose failed"
  CHECK_RESULT $? 0 0 "Check mpirun -genvnone failed"
  CHECK_RESULT $? 0 0 "Check mpirun -genvall failed"
  CHECK_RESULT $? 0 0 "Check mpirun -f -hosts failed"
  CHECK_RESULT $? 0 0 "Check mpirun -wdir failed"
  CHECK_RESULT $? 0 0 "Check mpirun -configfil failed"
  CHECK_RESULT $? 0 0 "Check mpirun -env -envlist -envnone -n -verbose failed"
  CHECK_RESULT $? 0 0 "Check mpirun -genv -genvlist -envnone -info  failed"
  CHECK_RESULT $? 0 0 "Check mpirun -print-all-exitcodes -iface -ppn -profile -prepend-rank -prepend-pattern failed"
  CHECK_RESULT $? 0 0 "Check mpirun -errfile-pattern -nameserver -disable-auto-cleanup -disable-hostname-propagation failed"
```

- 涉及命令：mpirun×10

#### oe_test_mpich_mpirun_02

- 描述：verify the uasge of mpich command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check mpirun -order-nodes failed"
  CHECK_RESULT $? 0 0 "Check mpirun -membind -map-by -bind-to -topolib -rmk -disable-x -usize failed"
  CHECK_RESULT $? 0 0 "Check mpirun -ckpointlib -demux -ckpoint-nu -ckpoint-prefix -ckpoint-interval -ckpointlib failed"
  CHECK_RESULT $? 0 0 "Check mpirun -launcher failed"
  CHECK_RESULT $? 0 0 "Check mpirun --help failed"
  CHECK_RESULT $? 0 0 "Check parkill -debug program failed"
  CHECK_RESULT $? 0 0 "Check parkill -verbose program failed"
  CHECK_RESULT $? 0 0 "Check parkill -user=root -verbose program failed"
```

- 涉及命令：mpirun×4, parkill×3
