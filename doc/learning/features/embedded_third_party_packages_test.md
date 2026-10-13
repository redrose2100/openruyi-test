# embedded_third_party_packages_test

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 嵌入式域（embedded-test） |
| 套件路径 | `$OET_PATH/testcases/embedded-test/third_party_packages_test` |
| 注册用例数 | 40 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_busybox_test_001 | Run busybox testsuite | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_json-c_test_001 | Run json-c testsuite | pre_test/run_test | 1 |  |  |  |
| oe_test_dosfstools_test_001 | Run dosfstools testsuite | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_e2fsprogs_test_001 | Run e2fsprogs testsuite | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_logrotate_test_001 | Run dosfstools testsuite | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_nfs-utils_test_001 | Run nfs-util testsuite | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_libffi_test_001 | Run libffi testsuite | pre_test/run_test | 3 |  |  |  |
| oe_test_libcap_test_001 | Run libcap testsuite | run_test | 11 |  |  |  |
| oe_test_shadow_test_001 | Run shadow testsuite | pre_test/run_test | 1 |  |  |  |
| oe_test_pam_test_001 | Run pam testsuite | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_popt_test_001 | Run popt testsuite | run_test | 1 |  |  |  |
| oe_test_util-linux_test_001 | Run util-linux testsuite | pre_test/run_test | 1 |  |  |  |
| oe_test_elfutils_test_001 | Run elfutils testsuite | pre_test/run_test | 1 |  |  |  |
| oe_test_procps_test_001 | Run procps-ng testsuite | pre_test/run_test | 1 |  |  |  |
| oe_test_ncurses_test_001 | Run ncurses testsuite | run_test | 1 |  |  |  |
| oe_test_libpcap_test_001 | Run libpcap testsuite | run_test | 3 |  |  |  |
| oe_test_less_test_001 | Run less testsuite | run_test | 1 |  |  |  |
| oe_test_zlib_test_001 | Command test zlib | run_test/post_test | 1 |  |  |  |
| oe_test_gzip_test_001 | Run gzip testsuite | run_test | 1 |  |  |  |
| oe_test_bash-completion_test_001 | Run bash-completion testsuite | run_test | 1 |  |  |  |
| oe_test_sed_test_001 | Run sed testsuite | pre_test/run_test | 1 |  |  |  |
| oe_test_ethtool_test_001 | Run ethtool testsuite | run_test | 1 |  |  |  |
| oe_test_expat_test_001 | Run expat testsuite | run_test | 2 |  |  |  |
| oe_test_grep_test_001 | Test grep | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_libcap-ng_test_001 | Test libcap-ng | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_libaio_test_001 | Test libaio | config_params/run_test/post_test | 1 |  |  |  |
| oe_test_tcl_test_001 | Test tcl | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_asio_test_001 | Test asio | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_audit_test_001 | Run audit testsuite | pre_test/run_test | 1 |  |  |  |
| oe_test_findutils_test_001 | Run findutils testsuite | pre_test/run_test | 3 |  |  |  |
| oe_test_sudo_test_001 | Test sudo | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_gawk_test_001 | Test gawk | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_libfastjson_test_001 | Run libfastjson testsuite | run_test | 1 |  |  |  |
| oe_test_libsemanage_test_001 | Test libsemanage | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_libidn2_test_001 | Run libidn2 testsuite | run_test | 1 |  |  |  |
| oe_test_bzip2_test_001 | Run bzip2 testsuite | run_test | 12 |  |  |  |
| oe_test_libunwind_test_001 | Run libunistring testsuite | run_test | 1 |  |  |  |
| oe_test_yajl_test_001 | test yajl | run_test/post_test | 2 |  |  |  |
| oe_test_lzo_test_001 | test lzo | run_test | 7 |  |  |  |
| oe_test_http-parser_test_001 | test http-parser | run_test | 2 |  |  |  |

### 断言与命令明细

#### oe_test_busybox_test_001

- 描述：Run busybox testsuite
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT 1 0 1 "pushd ./tmp_test/testsuite fail"
  CHECK_RESULT 1 0 1 "popd ./tmp_test/testsuite fail"
  CHECK_RESULT 1 0 1 "pushd ./tmp_test/testsuite fail"
  CHECK_RESULT $? 0 1 "run busybox testcase fail info: $line"
  CHECK_RESULT 1 0 1 "popd ./tmp_test/testsuite fail"
```

- 涉及命令：sed×12, chmod×1

#### oe_test_json-c_test_001

- 描述：Run json-c testsuite
- 函数：`pre_test, run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "run json-c test ${case} fail"
```

- 涉及命令：declare×1, chmod×1

#### oe_test_dosfstools_test_001

- 描述：Run dosfstools testsuite
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "run dosfstools testcase $onetest fail"
  CHECK_RESULT $? 0 1 "run dosfstools testcase $onetest fail"
  CHECK_RESULT $? 0 0 "run dosfstools testcase $onetest fail"
  CHECK_RESULT $? 0 0 "run dosfstools testcase $onetest fail"
```

#### oe_test_e2fsprogs_test_001

- 描述：Run e2fsprogs testsuite
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "run e2fsprogs testcase fail info: $line"
```

- 涉及命令：date×2, mkdir×1, declare×1

#### oe_test_logrotate_test_001

- 描述：Run dosfstools testsuite
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "run logrotate testcase $testName fail"
```

- 涉及命令：date×2, declare×1, pkill×1

#### oe_test_nfs-utils_test_001

- 描述：Run nfs-util testsuite
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "run nfs-util testcase t0001-statd-basic-mon-unmon fail"
```

- 涉及命令：kill×6

#### oe_test_libffi_test_001

- 描述：Run libffi testsuite
- 函数：`pre_test, run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "run libffi test check-call fail"
  CHECK_RESULT $? 0 0 "run libffi test check-callback fail"
  CHECK_RESULT $? 0 0 "run libffi test $oneTest fail"
```

#### oe_test_libcap_test_001

- 描述：Run libcap testsuite
- 函数：`run_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "run cap_test failed!"
  CHECK_RESULT $? 0 0 "run ${CAPLIBNAME[0]} failed!"
  CHECK_RESULT $? 0 0 "run ${CAPLIBNAME[0]} --usage failed!"
  CHECK_RESULT $? 0 0 "run ${CAPLIBNAME[0]} --help failed!"
  CHECK_RESULT $? 0 0 "run ${CAPLIBNAME[0]} --summary failed!"
  CHECK_RESULT $? 0 0 "run ${PSXLIBNAME[0]} failed!"
  CHECK_RESULT $? 0 0 "run test_pam_cap failed!"
  CHECK_RESULT $? 0 0 "run ${PAMCAPNAME[0]} failed!"
  CHECK_RESULT $? 0 0 "run ${PAMCAPNAME[0]} --help failed!"
  CHECK_RESULT $? 0 0 "run psx_test failed!"
  CHECK_RESULT $? 0 0 "run libcap_psx_test failed!"
```

#### oe_test_shadow_test_001

- 描述：Run shadow testsuite
- 函数：`pre_test, run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "shadow run_embedded failed! info : $line"
```

- 涉及命令：sed×3

#### oe_test_pam_test_001

- 描述：Run pam testsuite
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "run pam testcase $testName fail"
```

#### oe_test_popt_test_001

- 描述：Run popt testsuite
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "run popt testcase fail"
```

#### oe_test_util-linux_test_001

- 描述：Run util-linux testsuite
- 函数：`pre_test, run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "run util-linux ${runtestName} testcase fail."
```

#### oe_test_elfutils_test_001

- 描述：Run elfutils testsuite
- 函数：`pre_test, run_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "run elfutils $testcase fail"
```

- 涉及命令：declare×1, chmod×1

#### oe_test_procps_test_001

- 描述：Run procps-ng testsuite
- 函数：`pre_test, run_test`
- 断言（1 条）：

```
  CHECK_RESULT $ret 0 0 "run procps-ng test ${tool} fail"
```

- 涉及命令：sed×38, mkdir×1

#### oe_test_ncurses_test_001

- 描述：Run ncurses testsuite
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "run ncurses testcase $onetest fail"
```

#### oe_test_libpcap_test_001

- 描述：Run libpcap testsuite
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "run ${prog} --help failed!"
  CHECK_RESULT $? 1 0 "run ${prog} --help failed!"
  CHECK_RESULT $? 0 0 "run opentest failed!"
```

#### oe_test_less_test_001

- 描述：Run less testsuite
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "run lesstest for ${oneFile} fail"
```

- 涉及命令：chmod×1

#### oe_test_zlib_test_001

- 描述：Command test zlib
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "grep msg error"
```

- 涉及命令：tar×1

#### oe_test_gzip_test_001

- 描述：Run gzip testsuite
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "run gzip testcase $onetest fail"
```

- 涉及命令：declare×1

#### oe_test_bash-completion_test_001

- 描述：Run bash-completion testsuite
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "run bash-completion test ${file} fail"
```

- 涉及命令：declare×1, bash×1

#### oe_test_sed_test_001

- 描述：Run sed testsuite
- 函数：`pre_test, run_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "run sed testcase $onetest fail"
```

- 涉及命令：sed×1, declare×1

#### oe_test_ethtool_test_001

- 描述：Run ethtool testsuite
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "run ethtool testcase fail"
```

#### oe_test_expat_test_001

- 描述：Run expat testsuite
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "run runtests failed!"
  CHECK_RESULT $? 0 0 "run runtests_cxx failed!"
```

#### oe_test_grep_test_001

- 描述：Test grep
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "${failed}" 0 0 "grep test failed ${failed}!!!"
```

- 涉及命令：sed×1

#### oe_test_libcap-ng_test_001

- 描述：Test libcap-ng
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "lib_test failed!!!"
  CHECK_RESULT $? 0 0 "thread_test failed!!!"
```

#### oe_test_libaio_test_001

- 描述：Test libaio
- 函数：`config_params, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "${failed_num}" 0 0 "libaio cases/${log_file%%.log}.p test failed!!!"
```

- 涉及命令：mount×2, mke2fs×1, shopt×1, grep×1

#### oe_test_tcl_test_001

- 描述：Test tcl
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "${failed_num}" 0 0 "exec ./tcltest tests/all.tcl failed ${failed_num}"
```

- 涉及命令：grep×1

#### oe_test_asio_test_001

- 描述：Test asio
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "${failed}" 0 0 "asio test failed!!!"
```

#### oe_test_audit_test_001

- 描述：Run audit testsuite
- 函数：`pre_test, run_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "run audit testcase $onetest fail"
```

- 涉及命令：sed×1

#### oe_test_findutils_test_001

- 描述：Run findutils testsuite
- 函数：`pre_test, run_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "run findutils testcase check-regexprops fail"
  CHECK_RESULT $? 0 0 "run findutils testcase test_splitstring fail"
  CHECK_RESULT 1 0 0 "run findutils testcase $line fail"
```

- 涉及命令：sed×1, declare×1

#### oe_test_sudo_test_001

- 描述：Test sudo
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "${failed}" 0 0 "sudo test failed ${failed}!!!"
```

#### oe_test_gawk_test_001

- 描述：Test gawk
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "${failed}" 0 0 "gawk test failed!!!"
```

- 涉及命令：sed×2, declare×1

#### oe_test_libfastjson_test_001

- 描述：Run libfastjson testsuite
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "run libfastjson testcase $onetest fail"
```

#### oe_test_libsemanage_test_001

- 描述：Test libsemanage
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$?" 0 0 "libsemanage test failed!!!"
```

#### oe_test_libidn2_test_001

- 描述：Run libidn2 testsuite
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "run libidn2 testcase $onetest fail"
```

#### oe_test_bzip2_test_001

- 描述：Run bzip2 testsuite
- 函数：`run_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "run sample1.ref failed!"
  CHECK_RESULT $? 0 0 "run sample2.ref failed!"
  CHECK_RESULT $? 0 0 "run sample3.ref failed!"
  CHECK_RESULT $? 0 0 "run sample1.bz2 failed!"
  CHECK_RESULT $? 0 0 "run sample2.bz2 failed!"
  CHECK_RESULT $? 0 0 "run sample3.bz2 failed!"
  CHECK_RESULT $? 0 0 "run cmp sample1.bz2 sample1.rb2 failed!"
  CHECK_RESULT $? 0 0 "run cmp sample2.bz2 sample2.rb2 failed!"
  CHECK_RESULT $? 0 0 "run cmp sample3.bz2 sample3.rb2 failed!"
  CHECK_RESULT $? 0 0 "run cmp sample1.tst sample1.ref failed!"
  CHECK_RESULT $? 0 0 "run cmp sample2.tst sample2.ref failed!"
  CHECK_RESULT $? 0 0 "run cmp sample3.tst sample3.ref failed!"
```

- 涉及命令：bzip2×6

#### oe_test_libunwind_test_001

- 描述：Run libunistring testsuite
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "run findutils testcase $line fail"
```

- 涉及命令：declare×1

#### oe_test_yajl_test_001

- 描述：test yajl
- 函数：`run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $test_stat 0 0 "run yajl parsing test fail"
  CHECK_RESULT $test_stat 0 0 "run yajl api test fail"
```

#### oe_test_lzo_test_001

- 描述：test lzo
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "run lzo test fail"
  CHECK_RESULT $? 0 0 "run lzo test fail"
  CHECK_RESULT $? 0 0 "run lzo test fail"
  CHECK_RESULT $? 0 0 "run lzo test fail"
  CHECK_RESULT $? 0 0 "run lzo test fail"
  CHECK_RESULT $? 0 0 "run lzo test fail"
  CHECK_RESULT $? 0 0 "run lzo test fail"
```

#### oe_test_http-parser_test_001

- 描述：test http-parser
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "run http-parser test_g fail"
  CHECK_RESULT $? 0 0 "run http-parser test_fast fail"
```
