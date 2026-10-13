# podman

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/podman` |
| 注册用例数 | 61 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_podman | Test podman.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_podman | Test podman.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_podman-clean-transient | Test podman-clean-transient.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_podman-restart | Test podman-restart.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_podman-auto-update | Test podman-auto-update.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_podman_01 | The usage of commands in podman package | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_podman_02 | The usage of commands in podman package | pre_test/run_test/post_test | 17 |  |  |  |
| oe_test_podman_03 | The usage of commands in podman package | pre_test/run_test/post_test | 14 |  |  |  |
| oe_test_podman_04 | The usage of commands in podman package | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_podman_05 | The usage of commands in podman package | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_podman_06 | The usage of commands in podman package | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_podman_07 | The usage of commands in podman package | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_podman_08 | The usage of commands in podman package | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_podman_09 | The usage of commands in podman package | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_podman_10 | The usage of commands in podman package | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_podman_11 | The usage of commands in podman package | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_podman_12 | The usage of commands in podman package | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_podman_13 | The usage of commands in podman package | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_podman_14 | The usage of commands in podman package | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_podman_15 | The usage of commands in podman package | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_podman_16 | The usage of commands in podman package | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_podman_17 | The usage of commands in podman package | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_podman_18 | The usage of commands in podman package | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_podman_19 | podman rm Test | config_params/pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_podman_20 | podman-run | config_params/pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_podman_21 | podman-start-pause-unpause | pre_test/run_test/post_test | 17 |  |  |  |
| oe_test_podman_22 | podman-search | pre_test/run_test/post_test | 16 |  |  |  |
| oe_test_podman_23 | podman-mount-unmount | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_podman_24 | podman container exec top | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_podman_25 | podman save inspect | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_podman_26 | podman build | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_podman_27 | podman build | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_podman_28 | Backup / restore database | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_podman_DK_01 | The usage of commands in podman package | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_podman_DK_02 | The usage of commands in podman package | pre_test/run_test/post_test | 17 |  |  |  |
| oe_test_podman_DK_03 | The usage of commands in podman package | pre_test/run_test/post_test | 14 |  |  |  |
| oe_test_podman_DK_04 | The usage of commands in podman package | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_podman_DK_05 | The usage of commands in podman package | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_podman_DK_06 | The usage of commands in podman package | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_podman_DK_07 | The usage of commands in podman package | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_podman_DK_08 | The usage of commands in podman package | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_podman_DK_09 | The usage of commands in podman package | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_podman_DK_10 | The usage of commands in podman package | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_podman_DK_11 | The usage of commands in podman package | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_podman_DK_12 | The usage of commands in docker package | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_podman_DK_13 | The usage of commands in docker package | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_podman_DK_14 | The usage of commands in docker package | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_podman_DK_15 | The usage of commands in docker package | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_podman_DK_16 | The usage of commands in docker package | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_podman_DK_17 | The usage of commands in docker package | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_podman_DK_18 | The usage of commands in docker package | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_podman_DK_19 | docker rm Test | config_params/pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_podman_DK_20 | docker-run | config_params/pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_podman_DK_21 | docker-start-pause-unpause | pre_test/run_test/post_test | 17 |  |  |  |
| oe_test_podman_DK_22 | docker-search | pre_test/run_test/post_test | 16 |  |  |  |
| oe_test_podman_DK_23 | docker-mount-unmount | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_podman_DK_24 | docker container exec top | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_podman_DK_25 | docker save inspect | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_podman_DK_26 | docker build | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_podman_DK_27 | docker build | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_podman_DK_28 | Backup / restore database | pre_test/run_test/post_test | 11 |  |  |  |

### 断言与命令明细

#### oe_test_service_podman

- 描述：Test podman.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_podman

- 描述：Test podman.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_podman-clean-transient

- 描述：Test podman-clean-transient.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_podman-restart

- 描述：Test podman-restart.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_podman-auto-update

- 描述：Test podman-auto-update.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_podman_01

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 'check podman images 2>&1 | grep "alpine" failed'
  CHECK_RESULT $? 0 0 'check podman pull -q alpine failed'
  CHECK_RESULT $? 0 0 "check podman pull --tls-verify alpine failed"
  CHECK_RESULT $? 0 0 'check podman run --name postgres alpine failed'
  CHECK_RESULT $? 0 0 'check podman images --all failed'
  CHECK_RESULT $? 0 0 'check podman images --digests | grep -i "DIGEST" failed'
  CHECK_RESULT $? 0 0 'check podman images --format=json failed'
  CHECK_RESULT $? 0 0 'check podman images --no-trunc failed'
  CHECK_RESULT $? 0 1 'check podman images --noheading failed'
```

#### oe_test_podman_02

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 'check podman run --name postgres alpine failed'
  CHECK_RESULT $? 0 0 'check pull alpine failed'
  CHECK_RESULT $? 0 0 'check podman images --sort created failed'
  CHECK_RESULT $? 0 0 'check podman images | grep "alpine" failed'
  CHECK_RESULT $? 0 0 'check podman stop postgres failed'
  CHECK_RESULT $? 0 0 'check podman commit postgres images1 failed'
  CHECK_RESULT $? 0 0 'check podman images | grep images1 failed'
  CHECK_RESULT $? 0 0 'check podman commit --change CMD=/bin/bash --change ENTRYPOINT=/bin/sh postgres images2 failed'
  CHECK_RESULT $? 0 0 'check podman images | grep images2 failed'
  CHECK_RESULT $? 0 0 'check podman commit -p postgres images3 failed'
  CHECK_RESULT $? 0 0 'check podman images | grep images3 failed'
  CHECK_RESULT $? 0 0 'check podman commit -q postgres images4 failed'
  ... 共 17 条（其余见源脚本）
```

#### oe_test_podman_03

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 'check podman push alpine dir:/tmp/myimage  failed'
  CHECK_RESULT $? 0 0 'check podman push --authfile temp-auths/myauths.json alpine dir:/tmp/myimage failed'
  CHECK_RESULT $? 0 0 'check test -f /tmp/myimage/manifest.json && rm -rf /tmp/myimage/manifest.json failed'
  CHECK_RESULT $? 0 0 'check podman push --format oci alpine dir:/tmp/myimage failed'
  CHECK_RESULT $? 0 0 'check grep "oci" /tmp/myimage/manifest.json && rm -rf /tmp/myimage/manifest.json failed'
  CHECK_RESULT $? 0 0 'check docker push --compress ubi8-minimal failed'
  CHECK_RESULT $? 0 0 'check grep "image.rootfs.diff.tar.gzip" /tmp/myimage/manifest.json failed'
  CHECK_RESULT $? 0 0 'check podman push -q alpine dir:/tmp/myimage failed'
  CHECK_RESULT $? 0 0 'check test -f /tmp/myimage/manifest.json failed'
  CHECK_RESULT $? 0 0 'check podman push --remove-signatures alpine dir:/tmp/myimage failed'
  CHECK_RESULT $? 0 0 'check podman push --tls-verify alpine dir:/tmp/myimage failed'
  CHECK_RESULT $? 0 0 'check podman push --creds postgres:screte alpine dir:/tmp/myimage failed'
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：test×3

#### oe_test_podman_04

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 'check podman ps --filter name=postgres failed'
  CHECK_RESULT $? 0 0 'check podman ps -q failed'
  CHECK_RESULT $? 0 0 'check podman ps -s | grep SIZE failed'
  CHECK_RESULT $? 0 0 'check podman run --name postgres2 alpine failed'
  CHECK_RESULT $? 0 0 'check podman ps -a --sort names failed'
  CHECK_RESULT $? 0 0 'check podman ps -a | grep "postgres" failed'
  CHECK_RESULT $? 0 0 "check podman ps -a --sort names failed"
  CHECK_RESULT $? 0 0 'check stop postgres2 failed'
  CHECK_RESULT $? 0 0 'check rm postgres2 failed'
  CHECK_RESULT $? 0 0 "check podman ps -aq failed"
  CHECK_RESULT $? 0 0 'check podman ps --no-trunc failed'
  CHECK_RESULT $? 0 0 'check podman ps --pod | grep "POD" failed'
```

#### oe_test_podman_05

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 'check podman save --compress --format docker-dir -o alp-dir alpine failed'
  CHECK_RESULT $? 0 0 'check test -d alp-dir failed'
  CHECK_RESULT $? 0 0 'check podman save -q -o alpine.tar alpine failed'
  CHECK_RESULT $? 0 0 'check test -f alpine.tar failed'
  CHECK_RESULT $? 0 0 'check podman info | grep -E "host|insecure registries|registries|store" failed'
  CHECK_RESULT $? 0 0 'check podman info --debug | grep "host" failed'
  CHECK_RESULT $? 0 0 'check podman info --format json failed'
  CHECK_RESULT $? 0 0 "check podman history --format=json $(podman images -q) failed"
  CHECK_RESULT $? 0 0 'check podman --human test failed'
  CHECK_RESULT $? 0 0 'check podman --no-trunc test failed'
  CHECK_RESULT $? 0 1 'check podman histroy -q test failed'
```

- 涉及命令：test×2

#### oe_test_podman_06

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 'check podman logs -f failed'
  CHECK_RESULT $? 0 0 'check podman logs -l failed'
  CHECK_RESULT $? 0 0 'check podman logs --since 2020-12-31 failed'
  CHECK_RESULT $? 0 0 'check podman logs --tail 10 failed'
  CHECK_RESULT $? 0 0 'check podman logs -t failed'
  CHECK_RESULT $? 0 0 'check podman import --change CMD=/bin/bash --change ENTRYPOINT=/bin/sh --change LABEL=blue=image alpine.tar image-imported failed'
  CHECK_RESULT $? 0 0 'check cat alpine.tar | podman import -q --message failed'
  CHECK_RESULT $? 0 0 'check podman export -o redis-container.tar failed'
  CHECK_RESULT $? 0 0 'check test -f redis-container.tar failed'
  CHECK_RESULT $? 0 0 'check podman tag failed'
```

- 涉及命令：test×1

#### oe_test_podman_07

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 'check podman wait --latest | grep [0-9] failed'
  CHECK_RESULT $? 0 0 'check podman wait --interval 250 postgres | grep [0-9] failed'
  CHECK_RESULT $? 0 0 'check podman kill -l failed'
  CHECK_RESULT $? 0 0 'check podman ps -a | grep "Exited" failed'
  CHECK_RESULT $? 0 0 'check podman kill -a failed'
  CHECK_RESULT $? 0 0 'check podman ps -a | grep "Exited" failed'
  CHECK_RESULT $? 0 0 'check podman kill -s KILL failed'
  CHECK_RESULT $? 0 0 'check podman ps -a | grep "Exited" failed'
  CHECK_RESULT $? 0 0 'check podman diff alpine | grep -E "C|A" failed'
  CHECK_RESULT $? 0 0 'check podman diff --format json alpine failed'
  CHECK_RESULT $? 0 0 'check podman version failed'
```

#### oe_test_podman_08

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 'check podman --help test failed'
  CHECK_RESULT $? 0 0 'check create alpine failed'
  CHECK_RESULT $? 0 0 'check ps -a test failed'
  CHECK_RESULT $? 0 0 'check grep hello world failed'
  CHECK_RESULT $? 0 0 'check podman create --attach STDIN alpine ls failed'
  CHECK_RESULT $? 0 0 'check podman ps -a | grep ls failed'
  CHECK_RESULT $? 0 0 'check "BlkioWeight": 15 test failed'
  CHECK_RESULT $? 0 0 'check "weight": 15 test failed'
  CHECK_RESULT $? 0 0 'check net_admin test failed'
  CHECK_RESULT $? 0 0 'check CapDrop test failed'
```

#### oe_test_podman_09

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 'check "CgroupParent" test failed'
  CHECK_RESULT $? 0 0 "check test $ID failed"
  CHECK_RESULT $? 0 0 'check grep id failed'
  CHECK_RESULT $? 0 0 'check "CpuPeriod": 10000 test failed'
  CHECK_RESULT $? 0 0 'check "CpuQuota": 1001 test failed'
  CHECK_RESULT $? 0 0 'check "CpuRealtimePeriod": 1 test failed'
  CHECK_RESULT $? 0 0 'check "CpuRealtimeRuntime": 2 test failed'
  CHECK_RESULT $? 0 0 'check "CpuShares": 3 test failed'
  CHECK_RESULT $? 0 0 'check "CpuQuota": 400000 test failed'
```

#### oe_test_podman_10

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep -i CpuSetCpus failed"
  CHECK_RESULT $? 0 0 'check "CpuSetMems": "0" test failed'
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep -i alpine failed"
  CHECK_RESULT $? 0 0 'check "PathOnHost": "/dev/zero" test failed'
  CHECK_RESULT $? 0 0 'check BlkioDeviceReadBps test failed'
  CHECK_RESULT $? 0 0 'check BlkioDeviceReadIOps test failed'
  CHECK_RESULT $? 0 0 'check BlkioDeviceWriteBps test failed'
  CHECK_RESULT $? 0 0 'check BlkioDeviceWriteBps test failed'
```

#### oe_test_podman_11

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep '255.255.255.0' failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep '8.8.8.8' failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep '8.8.8.8' failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep "ENV****" failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep 'ENV' failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep '0' failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep 'gid' failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep -i group failed"
```

#### oe_test_podman_12

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep -i group failed"
  CHECK_RESULT $? 0 0 "check  podman inspect $ID | grep -i group failed"
  CHECK_RESULT $? 0 0 "check  podman inspect $ID | grep -i bind failed"
  CHECK_RESULT $? 0 0 "check  podman inspect $ID | grep -i ip failed"
  CHECK_RESULT $? 0 0 "check  podman inspect $ID | grep IpcMode: host failed"
  CHECK_RESULT $? 0 0 "check  podman inspect $ID | grep KernelMemory failed"
  CHECK_RESULT $? 0 0 "podman create --label com.example.key=value alpine ls failed"
  CHECK_RESULT $? 0 0 "podman create --label-file ./a alpine ls failed"
```

#### oe_test_podman_13

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep -i driver failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep -i log failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep Memory failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep Memory failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep MemorySwap failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep MemorySwappiness failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep /tmp/host failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep Name example failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep Nameexample failed"
```

#### oe_test_podman_14

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "check OomKillDisable failed"
  CHECK_RESULT $? 0 0 "check OomKillDisable failed"
  CHECK_RESULT $? 0 0 "check PidMode host failed"
  CHECK_RESULT $? 0 0 "check PidsLimit failed"
  CHECK_RESULT $? 0 0 "check podman rm $ID failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep Privileged: true failed"
  CHECK_RESULT $? 0 0 "check podman inspect $ID | grep 23 failed"
  CHECK_RESULT $? 0 0 "check PublishAllPorts: false failed"
  CHECK_RESULT $? 0 0 "check podman create -q alpine ls failed"
```

#### oe_test_podman_15

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "check ReadonlyRootfs failed"
  CHECK_RESULT $? 0 0 "check podman create --rm alpine ls failed"
  CHECK_RESULT $? 0 0 "check apparmor=unconfined failed"
  CHECK_RESULT $? 0 0 "check ShmSize: 65536000 failed"
  CHECK_RESULT $? 0 0 "check StopSignal failed"
  CHECK_RESULT $? 0 0 "check podman create --stop-timeout 10 alpine ls failed"
```

#### oe_test_podman_16

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 'check /tmp:rw failed'
  CHECK_RESULT $? 0 0 'check UsernsMode failed'
  CHECK_RESULT $? 0 0 'check UTSMode host failed'
  CHECK_RESULT $? 0 0 'check Name - example failed'
  CHECK_RESULT $? 0 0 'check destination failed'
  CHECK_RESULT $? 0 0 'check WorkingDir failed'
  CHECK_RESULT $? 0 0 "check podman rmi -f $(podman images -q) failed"
  CHECK_RESULT $? 1 0 'check podman images | grep "alpine" failed'
  CHECK_RESULT $? 0 0 'check podman images | grep "alpine" failed'
  CHECK_RESULT $? 0 0 'check podman rmi --all failed'
  CHECK_RESULT $? 1 0 'check podman images | grep "alpine" faileds'
```

#### oe_test_podman_17

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 'check podman image history --format=json alpine | grep "created" failed'
  CHECK_RESULT $? 0 0 'check podman image history --human alpine | grep "B" failed'
  CHECK_RESULT $? 0 0 "check podman image history --no-trunc alpine failed"
  CHECK_RESULT $? 0 0 "check podman image history -q alpine failed"
  CHECK_RESULT $? 0 0 'check podman image ls --filter after=alpine failed'
  CHECK_RESULT $? 0 0 'check podman image ls --all | grep "alpine" failed'
  CHECK_RESULT $? 0 0 'check podman image ls --digests | grep "DIGEST" failed'
  CHECK_RESULT $? 0 0 'check podman image ls --format json | grep "alpine" failed'
  CHECK_RESULT $? 0 0 'check podman image ls --no-trunc | grep "sha256" failed'
  CHECK_RESULT $? 1 0 'check podman image ls --noheading | grep "TAG" failed'
```

#### oe_test_podman_18

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 'check podman ps --all | grep "postgres" failed'
  CHECK_RESULT $? 0 0 'check podman port --latest failed'
  CHECK_RESULT $? 0 0 'check grep -i "Login Succeeded" testlog failed'
  CHECK_RESULT $? 0 0 'check podman logout registry.access.redhat.com failed'
  CHECK_RESULT $? 0 0 'check grep -i "Login Succeeded" testlog failed'
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 0 0 'check grep -i "umohnani" testlog failed'
  CHECK_RESULT $? 0 0 'check podman logout --all | grep "Remove" failed'
```

- 涉及命令：grep×4

#### oe_test_podman_19

- 描述：podman rm Test
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "check podman run --name ${name} alpine failed"
  CHECK_RESULT $? 0 0 "check podman ps -a | grep ${name} failed"
  CHECK_RESULT $? 0 0 "check podman stop ${name} | grep ${name} failed"
  CHECK_RESULT $? 0 0 "check podman rm ${name} failed"
  CHECK_RESULT $? 0 0 "check podman run --name ${name}1 alpine failed"
  CHECK_RESULT $? 0 0 "check podman ps -a | grep ${name}1 failed"
  CHECK_RESULT $? 0 0 "check podman stop ${name}1 | grep ${name}1 failed"
  CHECK_RESULT $? 0 0 "check podman rm --all failed"
  CHECK_RESULT $? 0 0 "check podman run --name ${name}2 alpine failed"
  CHECK_RESULT $? 0 0 "check podman run --name ${name}3 alpine failed"
  CHECK_RESULT $? 0 0 "check podman stop ${name}2 ${name}3 failed"
  CHECK_RESULT $? 0 0 "check podman rm ${name}2 ${name}3 failed"
```

#### oe_test_podman_20

- 描述：podman-run
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 'check podman pull alpine failed'
  CHECK_RESULT $? 0 0 "check podman run --name ${name} alpine failed"
  CHECK_RESULT $? 0 0 "check podman ps -a | grep ${name} failed"
  CHECK_RESULT $? 0 0 "check podman stop ${name} | grep ${name} failed"
  CHECK_RESULT $? 0 0 "check podman rm ${name} failed"
```

#### oe_test_podman_21

- 描述：podman-start-pause-unpause
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 'check podman create --name postgres -t alpine failed'
  CHECK_RESULT $? 0 0 'check podman create --name test1 -t alpine failed'
  CHECK_RESULT $? 0 0 'check podman create --name new_name -t alpine failed'
  CHECK_RESULT $? 0 0 'check podman ps -all | grep -E "postgres|test1|new_name" failed'
  CHECK_RESULT $? 0 0 'check podman start postgres  failed'
  CHECK_RESULT $? 0 0 'check podman start new_name  failed'
  CHECK_RESULT $? 0 0 'check podman start test1 failed'
  CHECK_RESULT $? 0 0 'check podman start -i -l failed'
  CHECK_RESULT $? 0 0 'check podman pause test1 new_name failed'
  CHECK_RESULT $? 0 0 'check podman ps -a | grep test1 failed'
  CHECK_RESULT $? 0 0 'check podman unpause test1 new_name failed'
  CHECK_RESULT $? 0 0 'check podman test1 status failed'
  ... 共 17 条（其余见源脚本）
```

#### oe_test_podman_22

- 描述：podman-search
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 'check podman search --limit 5 alpine | wc -l | grep 6 failed'
  CHECK_RESULT $? 0 0 'check podman search --no-trunc alpine | grep "dockerpull.org" failed'
  CHECK_RESULT $? 0 0 'check podman search --authfile test.json alpine | grep -i "DESCRIPTION" failed'
  CHECK_RESULT $? 0 0 'check podman search --format json failed'
  CHECK_RESULT $? 0 0 'check podman search --tls-verify true failed'
  CHECK_RESULT $? 0 0 'check podman pull alpine failed'
  CHECK_RESULT $? 1 0 'check id failed'
  CHECK_RESULT $? 0 0 'check podman start postgres | grep postgres failed'
  CHECK_RESULT $? 0 0 'check podman ps -a | grep postgres failed'
  CHECK_RESULT $? 0 0 'check podman stats -a --no-stream failed'
  CHECK_RESULT $? 0 0 "check podman stats --no-stream ${id} | grep postgres failed"
  CHECK_RESULT $? 0 0 "check podman stats --no-stream --format=json ${id} | grep postgres failed"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：test×1

#### oe_test_podman_23

- 描述：podman-mount-unmount
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 'check podman pull alpine failed'
  CHECK_RESULT $? 1 0 "check id=$(podman create --name postgres -t alpine) failed"
  CHECK_RESULT $? 0 0 'check podman start postgres failed'
  CHECK_RESULT $? 0 0 'check podman top -l | grep "USER" failed'
  CHECK_RESULT $? 0 0 'check podman top postgres | grep "USER" failed'
  CHECK_RESULT $? 0 0 'check podman mount --format json | grep "id" failed'
  CHECK_RESULT $? 0 0 'check podman mount --notruncate | grep merged failed'
  CHECK_RESULT $? 0 0 'check podman stop postgres failed'
  CHECK_RESULT $? 0 0 'check podman unmount -f postgres | grep postgres failed'
  CHECK_RESULT $? 0 0 'check podman mount postgres failed'
  CHECK_RESULT $? 0 0 'check podman unmount --all failed'
  CHECK_RESULT $? 0 0 "check podman rm postgres | grep ${id} failed"
```

- 涉及命令：test×1

#### oe_test_podman_24

- 描述：podman container exec top
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 1 0 "check ${id} failed"
  CHECK_RESULT $? 0 0 'check podman container stop postgres failed'
  CHECK_RESULT $? 0 0 "check podman container rm postgres | grep ${id} failed"
  CHECK_RESULT $? 1 0 'check podman container ls | grep postgres failed'
  CHECK_RESULT $? 0 0 'check podman container stop postgres1 failed'
  CHECK_RESULT $? 0 0 'check podman container cleanup postgres1 failed'
  CHECK_RESULT $? 0 0 'check podman create --name postgres2 -t alpine failed'
  CHECK_RESULT $? 0 0 'check podman exec -it postgres2 ls | grep "bin" failed'
  CHECK_RESULT $? 0 0 'check podman exec --privileged postgres2 ls failed'
  CHECK_RESULT $? 0 0 'check podman stop postgres2 failed'
  CHECK_RESULT $? 0 0 'check podman rm postgres2 postgres1 failed'
```

- 涉及命令：test×1

#### oe_test_podman_25

- 描述：podman save inspect
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 'check podman create --name postgres -t alpine failed'
  CHECK_RESULT $? 0 0 'check podman save -q -o alpine.tar alpine failed'
  CHECK_RESULT $? 0 0 'check test -f ./alpine.tar failed'
  CHECK_RESULT $? 0 0 'check podman inspect -f json postgres | grep "ID" failed'
  CHECK_RESULT $? 0 0 'check podman inspect postgres --format failed'
  CHECK_RESULT $? 0 0 'check podman inspect postgres --type all --format failed'
  CHECK_RESULT $? 0 0 'check podman inspect postgres --type container --format failed'
  CHECK_RESULT $? 0 0 'check podman stop postgres failed'
  CHECK_RESULT $? 0 0 'check podman stop postgres failed'
```

- 涉及命令：test×1

#### oe_test_podman_26

- 描述：podman build
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 1 0 'check id failed'
  CHECK_RESULT $? 0 0 "check cat ./Dockerfile | podman build -f - . | grep ${id} failed"
  CHECK_RESULT $? 0 0 "check podman build --runtime-flag debug . | grep ${id} failed"
  CHECK_RESULT $? 0 0 'check podman build --authfile ./authdir/myauths.json --cert-dir failed'
  CHECK_RESULT $? 0 0 'check podman build --memory 40m --cpu-period 10000 --cpu-quota 50000 --ulimit failed'
  CHECK_RESULT $? 0 0 'check podman build -f Dockerfile.simple -f Containerfile.notsosimple . failed'
  CHECK_RESULT $? 0 0 "check podman build -f Dockerfile.in ${HOME} | grep ${id} failed"
  CHECK_RESULT $? 0 0 'check podman build --no-cache --rm=false -t newimages1 . failed'
  CHECK_RESULT $? 0 0 'check podman build --layers --force-rm -t testname . failed'
  CHECK_RESULT $? 0 0 'check podman build --no-cache -t imageert . failed'
```

- 涉及命令：test×1

#### oe_test_podman_27

- 描述：podman build
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 1 0 'check value failed'
  CHECK_RESULT $? 0 0 'check podman build --authfile temp-auths/myauths.json --cert-dir failed'
  CHECK_RESULT $? 0 0 'check podman build --runtime-flag log-format=json . failed'
  CHECK_RESULT $? 0 0 'check podman build --tls-verify=false -t imagename . failed'
  CHECK_RESULT $? 0 0 'check podman build --tls-verify=true -t imagename1 -f Dockerfile.simple . failed'
  CHECK_RESULT $? 0 0 'check podman build -t imag .'
```

- 涉及命令：test×1

#### oe_test_podman_28

- 描述：Backup / restore database
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 'check podman pod create --infra=false failed'
  CHECK_RESULT $? 1 0 'check name failed'
  CHECK_RESULT $? 0 0 'check podman pod ls failed'
  CHECK_RESULT $? 0 0 'check podman pod ps failed'
  CHECK_RESULT $? 0 0 'check podman pod list failed'
  CHECK_RESULT $? 0 0 'check podman pod pause failed'
  CHECK_RESULT $? 0 0 'check podman pod unpause failed'
  CHECK_RESULT $? 0 0 'check podman pod inspect failed'
  CHECK_RESULT $? 0 0 'check local_pid failed'
  CHECK_RESULT $? 0 0 'check podman pod stop failed'
  CHECK_RESULT $? 0 0 'check podman pod rm failed'
```

- 涉及命令：test×1, kill×1

#### oe_test_podman_DK_01

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 'check docker images 2>&1 failed'
  CHECK_RESULT $? 0 0 'check docker pull -q alpine failed'
  CHECK_RESULT $? 0 0 'check ocker pull --tls-verify alpine failed'
  CHECK_RESULT $? 0 0 'check docker run --name postgres failed'
  CHECK_RESULT $? 0 0 'check docker images --all failed'
  CHECK_RESULT $? 0 0 'check docker images --digests | grep -i "DIGEST" failed'
  CHECK_RESULT $? 0 0 'check docker images --format=json failed'
  CHECK_RESULT $? 0 0 'check docker images --no-trunc failed'
  CHECK_RESULT $? 1 0 'check docker images --noheading failed'
```

#### oe_test_podman_DK_02

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 'check docker run --name postgres alpine failed'
  CHECK_RESULT $? 0 0 'check docker pull alpine failed'
  CHECK_RESULT $? 0 0 'check docker images --sort created failed'
  CHECK_RESULT $? 0 0 'check docker images failed'
  CHECK_RESULT $? 0 0 'check docker stop postgres failed'
  CHECK_RESULT $? 0 0 'check docker commit postgres images1 failed'
  CHECK_RESULT $? 0 0 'check docker images | grep images1 failed'
  CHECK_RESULT $? 0 0 'check docker commit --change CMD=/bin/bash --change failed'
  CHECK_RESULT $? 0 0 'check docker images | grep images2 failed'
  CHECK_RESULT $? 0 0 'check docker commit -p postgres images3 failed'
  CHECK_RESULT $? 0 0 'check docker images | grep images3 failed'
  CHECK_RESULT $? 0 0 'check docker commit -q postgres images4 failed'
  ... 共 17 条（其余见源脚本）
```

#### oe_test_podman_DK_03

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 'check docker push alpine dir:/tmp/myimage failed'
  CHECK_RESULT $? 0 0 'check docker push --authfile myauths.json alpine faield'
  CHECK_RESULT $? 0 0 'check test -f /tmp/myimage/manifest.json && rm -rf /tmp/myimage/manifest.json failed'
  CHECK_RESULT $? 0 0 'check docker push --format oci alpine failed'
  CHECK_RESULT $? 0 0 'check grep "oci" /tmp/myimage/manifest.json && rm -rf /tmp/myimage/manifest.json failed'
  CHECK_RESULT $? 0 0 'check docker push --compress alpine failed'
  CHECK_RESULT $? 0 0 'check grep "image.rootfs.diff.tar.gzip" /tmp/myimage/manifest.json failed'
  CHECK_RESULT $? 0 0 'check docker push -q alpine dir:/tmp/myimage failed'
  CHECK_RESULT $? 0 0 'check test -f /tmp/myimage/manifest.json failed'
  CHECK_RESULT $? 0 0 'check docker push --remove-signatures alpine failed'
  CHECK_RESULT $? 0 0 'check docker push --tls-verify alpine failed'
  CHECK_RESULT $? 0 0 'check docker push --creds postgres:screte failed'
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：test×3

#### oe_test_podman_DK_04

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 'check docker ps --filter name=postgres failed'
  CHECK_RESULT $? 0 0 'check docker ps -q failed'
  CHECK_RESULT $? 0 0 'check docker ps -s | grep SIZE failed'
  CHECK_RESULT $? 0 0 'check docker run --name postgres2 alpine failed'
  CHECK_RESULT $? 0 0 'check docker ps -a --sort names | grep "postgres2" failed'
  CHECK_RESULT $? 0 0 'check docker ps -a | grep "postgres" failed'
  CHECK_RESULT $? 0 0 'check docker ps -a --sort names failed'
  CHECK_RESULT $? 0 0 'check docker stop postgres2 failed'
  CHECK_RESULT $? 1 0 'check docker rm postgres2 failed'
  CHECK_RESULT $? 0 0 'check docker ps -aq  failed'
  CHECK_RESULT $? 0 0 'check docker ps --no-trunc failed'
  CHECK_RESULT $? 0 0 'check docker ps --pod | grep "POD" failed'
```

#### oe_test_podman_DK_05

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 'check docker save --compress --format docker-dir -o alp-dir alpine failed'
  CHECK_RESULT $? 0 0 'check test -d alp-dir failed'
  CHECK_RESULT $? 0 0 'check docker save -q -o alpine.tar alpine failed'
  CHECK_RESULT $? 0 0 'check test -f alpine.tar failed'
  CHECK_RESULT $? 0 0 'check docker info | grep -E "host|insecure registries|registries|store" failed'
  CHECK_RESULT $? 0 0 'check docker info --debug | grep "host" failed'
  CHECK_RESULT $? 0 0 'check docker info --format json failed'
  CHECK_RESULT $? 0 0 "check docker history --format=json $(docker images -q) failed"
  CHECK_RESULT $? 0 0 'check docker history --human failed'
  CHECK_RESULT $? 0 0 'check docker history --no-trunc failed'
  CHECK_RESULT $? 1 0 "check docker history -q $(docker images -q) failed"
```

- 涉及命令：test×2

#### oe_test_podman_DK_06

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 'check docker logs -f failed'
  CHECK_RESULT $? 0 0 'check docker logs -l failed'
  CHECK_RESULT $? 0 0 'check docker logs --since 2020-12-31 failed'
  CHECK_RESULT $? 0 0 'check docker logs --tail 10  failed'
  CHECK_RESULT $? 0 0 'check docker logs -t failed'
  CHECK_RESULT $? 0 0 'check docker import --change CMD=/bin/bash --change ENTRYPOINT=/bin/sh failed'
  CHECK_RESULT $? 0 0 'check cat alpine.tar | docker import -q --message failed'
  CHECK_RESULT $? 0 0 'check docker export -o redis-container.tar failed'
  CHECK_RESULT $? 0 0 'check test -f redis-container.tar failed'
  CHECK_RESULT $? 0 0 'check docker tag failed'
```

- 涉及命令：test×1

#### oe_test_podman_DK_07

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 'check docker wait --latest | grep [0-9] failed'
  CHECK_RESULT $? 0 0 'check docker wait --interval 250 postgres | grep [0-9] failed'
  CHECK_RESULT $? 0 0 'check docker kill -l failed'
  CHECK_RESULT $? 0 0 'check docker ps -a | grep "Exited" failed'
  CHECK_RESULT $? 0 0 'check docker kill -a failed'
  CHECK_RESULT $? 0 0 'check docker ps -a | grep "Exited" failed'
  CHECK_RESULT $? 0 0 "check docker kill failed"
  CHECK_RESULT $? 0 0 'check docker ps -a | grep "Exited" failed'
  CHECK_RESULT $? 0 0 'check docker diff alpine | grep -E "C|A" failed'
  CHECK_RESULT $? 0 0 'check docker diff --format json alpine | grep -E "changed|added" failed'
  CHECK_RESULT $? 0 0 'check docker version | grep rpm -qa docker failed'
```

#### oe_test_podman_DK_08

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 'check docker help | grep -E "docker|help" failed'
  CHECK_RESULT $? 0 0 'check docker create alpine failed'
  CHECK_RESULT $? 0 0 'check docker ps -a | grep -i "Created" failed'
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep failed"
  CHECK_RESULT $? 0 0 'check docker create --attach STDIN alpine ls failed'
  CHECK_RESULT $? 0 0 'check docker ps -a | grep ls faield'
  CHECK_RESULT $? 0 0 'check "BlkioWeight": 15 test failed'
  CHECK_RESULT $? 0 0 'check "weight": 15 test failed'
  CHECK_RESULT $? 0 0 'check net_admin test failed'
  CHECK_RESULT $? 0 0 'check CapDrop test failed'
```

#### oe_test_podman_DK_09

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "check docker inspect $ID failed"
  CHECK_RESULT $? 0 0 "check grep $ID cidfile failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep $ID failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID CpuPeriod failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID CpuQuota failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID CpuRealtimePeriod failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID CpuRealtimeRuntime failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID CpuShares failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID failed"
```

#### oe_test_podman_DK_10

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep -i CpuSetCpus failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep -i CpuSetMems failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep -i alpine failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep -i PathOnHost failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID grep -A 5 -i BlkioDeviceReadBps failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID grep -A 5 -i BlkioDeviceReadIOps failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID grep -A 5 -i BlkioDeviceWriteBps failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID grep -A 5 -i BlkioDeviceWriteIOps failed"
```

#### oe_test_podman_DK_11

- 描述：The usage of commands in podman package
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep '255.255.255.0' failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep '8.8.8.8' failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep 'domain' failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep "ENV****" failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep 'ENV' failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep '0' failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep 'gid' failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep -i group failed"
```

#### oe_test_podman_DK_12

- 描述：The usage of commands in docker package
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep Name myctr failed"
  CHECK_RESULT $? 0 0 'check Hostname": "localhost failed'
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep -i bind failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep -i ip failed"
  CHECK_RESULT $? 0 0 'check IpcMode": "host failed'
  CHECK_RESULT $? 0 0 'check KernelMemory": 1073741824 failed'
  CHECK_RESULT $? 0 0 'check com.example.key": "value failed'
  CHECK_RESULT $? 0 0 'check com.example.key": "value failed'
```

#### oe_test_podman_DK_13

- 描述：The usage of commands in docker package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep -i driver failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep -i log failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep Memory failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep Memory failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep MemorySwap failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep MemorySwappiness failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep /tmp/host failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep Name example failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep Nameexample failed"
```

#### oe_test_podman_DK_14

- 描述：The usage of commands in docker package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "check OomKillDisable failed"
  CHECK_RESULT $? 0 0 "check OomKillDisable failed"
  CHECK_RESULT $? 0 0 "check PidMode host failed"
  CHECK_RESULT $? 0 0 "check PidsLimit failed"
  CHECK_RESULT $? 0 0 "check docker rm $ID failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep Privileged: true failed"
  CHECK_RESULT $? 0 0 "check docker inspect $ID | grep 23 failed"
  CHECK_RESULT $? 0 0 "check PublishAllPorts: false failed"
  CHECK_RESULT $? 0 0 "check docker create -q alpine ls failed"
```

#### oe_test_podman_DK_15

- 描述：The usage of commands in docker package
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 'check ReadonlyRootfs failed'
  CHECK_RESULT $? 0 0 'check docker create --rm alpine ls failed'
  CHECK_RESULT $? 0 0 'check apparmor=unconfined failed'
  CHECK_RESULT $? 0 0 'check ShmSize: 65536000 failed'
  CHECK_RESULT $? 0 0 'check StopSignal failed'
  CHECK_RESULT $? 0 0 'check docker create --stop-timeout 10 alpine ls failed'
```

#### oe_test_podman_DK_16

- 描述：The usage of commands in docker package
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 'check /tmp:rw failed'
  CHECK_RESULT $? 0 0 'check UsernsMode failed'
  CHECK_RESULT $? 0 0 'check UTSMode host failed'
  CHECK_RESULT $? 0 0 'check Name - example failed'
  CHECK_RESULT $? 0 0 'check destination failed'
  CHECK_RESULT $? 0 0 'check WorkingDir failed'
  CHECK_RESULT $? 0 0 "check docker rmi -f $(docker images -q) failed"
  CHECK_RESULT $? 1 0 'check docker images | grep "alpine"" failed'
  CHECK_RESULT $? 0 0 'check docker images | grep "alpine"" failed'
  CHECK_RESULT $? 0 0 'check docker rmi --all failed'
  CHECK_RESULT $? 1 0 'check docker images | grep "alpine"" faileds'
```

#### oe_test_podman_DK_17

- 描述：The usage of commands in docker package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 'check docker image history --format=json alpine | grep "created" failed'
  CHECK_RESULT $? 0 0 'check docker image history --human alpine | grep "B" failed'
  CHECK_RESULT $? 0 0 'check docker image history --no-trunc alpine failed'
  CHECK_RESULT $? 0 0 'check docker image history -q alpine  failed'
  CHECK_RESULT $? 0 0 'check docker image ls --filter after=alpine failed'
  CHECK_RESULT $? 0 0 'check docker image ls --all | grep "alpine" failed'
  CHECK_RESULT $? 0 0 'check docker image ls --digests | grep "DIGEST" failed'
  CHECK_RESULT $? 0 0 'check docker image ls --format json | grep "alpine" failed'
  CHECK_RESULT $? 0 0 'check docker image ls --no-trunc | grep "sha256" failed'
  CHECK_RESULT $? 1 0 'check docker image ls --noheading | grep "TAG" failed'
```

#### oe_test_podman_DK_18

- 描述：The usage of commands in docker package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 'check docker ps --all | grep "postgres" failed'
  CHECK_RESULT $? 0 0 'check docker port --latest failed'
  CHECK_RESULT $? 0 0 'check grep -i "Login Succeeded" testlog failed'
  CHECK_RESULT $? 0 0 'check docker logout registry.access.redhat.com failed'
  CHECK_RESULT $? 0 0 'check grep -i "Login Succeeded" testlog failed'
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 0 0 'check grep -i "umohnani" testlog failed'
  CHECK_RESULT $? 0 0 'check docker logout --all | grep "Remove" failed'
```

- 涉及命令：grep×4

#### oe_test_podman_DK_19

- 描述：docker rm Test
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 'check docker run --name alpine failed'
  CHECK_RESULT $? 0 0 'check docker ps -a failed'
  CHECK_RESULT $? 0 0 'check docker stop name failed'
  CHECK_RESULT $? 0 0 'check docker rm failed'
  CHECK_RESULT $? 0 0 'check docker run --name name1 alpine failed'
  CHECK_RESULT $? 0 0 'check docker ps -a failed'
  CHECK_RESULT $? 0 0 'check docker stop name1 failed'
  CHECK_RESULT $? 0 0 'check docker rm --all failed'
  CHECK_RESULT $? 0 0 'check docker run --name name2 alpine failed'
  CHECK_RESULT $? 0 0 'check docker run --name name3 alpine failed'
  CHECK_RESULT $? 0 0 'check docker stop name2 name3 failed'
  CHECK_RESULT $? 0 0 'check docker rm name2 name3 failed'
```

#### oe_test_podman_DK_20

- 描述：docker-run
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 'check docker pull alpine failed'
  CHECK_RESULT $? 0 0 'check docker run --name name alpine failed'
  CHECK_RESULT $? 0 0 'check docker ps -a failed'
  CHECK_RESULT $? 0 0 'check docker stop name failed'
  CHECK_RESULT $? 0 0 'check docker rm name failed'
```

#### oe_test_podman_DK_21

- 描述：docker-start-pause-unpause
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 'check docker create --name postgres -t alpine failed'
  CHECK_RESULT $? 0 0 'check docker create --name test1 -t alpine failed'
  CHECK_RESULT $? 0 0 'check docker create --name new_name -t alpine failed'
  CHECK_RESULT $? 0 0 'check docker ps -all | grep -E "postgres|test1|new_name" failed'
  CHECK_RESULT $? 0 0 'check docker start postgres  failed'
  CHECK_RESULT $? 0 0 'check docker start new_name  failed'
  CHECK_RESULT $? 0 0 'check docker start test1 failed'
  CHECK_RESULT $? 0 0 'check docker start -i -l failed'
  CHECK_RESULT $? 0 0 'check docker pause test1 new_name failed'
  CHECK_RESULT $? 0 0 'check docker ps -a | grep test1 failed'
  CHECK_RESULT $? 0 0 'check docker unpause test1 new_name failed'
  CHECK_RESULT $? 0 0 'check docker test1 status failed'
  ... 共 17 条（其余见源脚本）
```

#### oe_test_podman_DK_22

- 描述：docker-search
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 'check docker search --limit 5 alpine | wc -l | grep 6 failed'
  CHECK_RESULT $? 0 0 'check docker search --no-trunc alpine | grep "alpine" failed'
  CHECK_RESULT $? 0 0 'check docker search --authfile test.json alpine | grep -i "DESCRIPTION" failed'
  CHECK_RESULT $? 0 0 'check docker search --format json failed'
  CHECK_RESULT $? 0 0 'check docker search --tls-verify true failed'
  CHECK_RESULT $? 0 0 'check docker pull alpine failed'
  CHECK_RESULT $? 1 0 'check id failed'
  CHECK_RESULT $? 0 0 'check docker start postgres | grep postgres failed'
  CHECK_RESULT $? 0 0 'check docker ps -a | grep postgres failed'
  CHECK_RESULT $? 0 0 'check docker stats -a --no-stream failed'
  CHECK_RESULT $? 0 0 "check docker stats --no-stream ${id} | grep postgres failed"
  CHECK_RESULT $? 0 0 "check docker stats --no-stream --format=json ${id} | grep postgres failed"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：test×1

#### oe_test_podman_DK_23

- 描述：docker-mount-unmount
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 'check docker pull alpine failed'
  CHECK_RESULT $? 1 0 "check id=$(docker create --name postgres -t alpine) failed"
  CHECK_RESULT $? 0 0 'check docker start postgres failed'
  CHECK_RESULT $? 0 0 'check docker top -l | grep "USER" failed'
  CHECK_RESULT $? 0 0 'check docker top postgres | grep "USER" failed'
  CHECK_RESULT $? 0 0 'check docker mount --format json | grep "id" failed'
  CHECK_RESULT $? 0 0 'check docker mount --notruncate | grep merged failed'
  CHECK_RESULT $? 0 0 'check docker stop postgres failed'
  CHECK_RESULT $? 0 0 'check docker unmount -f postgres | grep postgres failed'
  CHECK_RESULT $? 0 0 'check docker mount postgres failed'
  CHECK_RESULT $? 0 0 'check docker unmount --all failed'
  CHECK_RESULT $? 0 0 "check docker rm postgres | grep ${id} failed"
```

- 涉及命令：test×1

#### oe_test_podman_DK_24

- 描述：docker container exec top
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 1 0 "check ${id} failed"
  CHECK_RESULT $? 0 0 'check docker container stop postgres failed'
  CHECK_RESULT $? 0 0 "check docker container rm postgres | grep ${id} failed"
  CHECK_RESULT $? 1 0 'check docker container ls | grep postgres failed'
  CHECK_RESULT $? 0 0 'check docker container stop postgres1 failed'
  CHECK_RESULT $? 0 0 'check docker container cleanup postgres1 failed'
  CHECK_RESULT $? 0 0 'check docker create --name postgres2 -t alpine failed'
  CHECK_RESULT $? 0 0 'check docker exec -it postgres2 ls | grep "bin" failed'
  CHECK_RESULT $? 0 0 'check docker exec --privileged postgres2 ls failed'
  CHECK_RESULT $? 0 0 'check docker stop postgres2 failed'
  CHECK_RESULT $? 0 0 'check docker rm postgres2 postgres1 failed'
```

- 涉及命令：test×1

#### oe_test_podman_DK_25

- 描述：docker save inspect
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 'check docker create --name postgres -t alpine failed'
  CHECK_RESULT $? 0 0 'check docker save -q -o alpine.tar alpine failed'
  CHECK_RESULT $? 0 0 'check test -f ./alpine.tar failed'
  CHECK_RESULT $? 0 0 'check docker inspect -f json postgres | grep "ID" failed'
  CHECK_RESULT $? 0 0 'check docker inspect postgres --format failed'
  CHECK_RESULT $? 0 0 'check docker inspect postgres --type all --format failed'
  CHECK_RESULT $? 0 0 'check docker inspect postgres --type container --format failed'
  CHECK_RESULT $? 0 0 'check docker stop postgres failed'
  CHECK_RESULT $? 0 0 'check docker stop postgres failed'
```

- 涉及命令：test×1

#### oe_test_podman_DK_26

- 描述：docker build
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 1 0 'check id failed'
  CHECK_RESULT $? 0 0 "check cat ./Dockerfile | docker build -f - . | grep ${id} failed"
  CHECK_RESULT $? 0 0 "check docker build --runtime-flag debug . | grep ${id} failed"
  CHECK_RESULT $? 0 0 'check docker build --authfile ./authdir/myauths.json --cert-dir failed'
  CHECK_RESULT $? 0 0 'check docker build --memory 40m --cpu-period 10000 --cpu-quota 50000 --ulimit failed'
  CHECK_RESULT $? 0 0 'check docker build -f Dockerfile.simple -f Containerfile.notsosimple . failed'
  CHECK_RESULT $? 0 0 "check docker build -f Dockerfile.in ${HOME} | grep ${id} failed"
  CHECK_RESULT $? 0 0 'check docker build --no-cache --rm=false -t newimages1 . failed'
  CHECK_RESULT $? 0 0 'check docker build --layers --force-rm -t testname . failed'
  CHECK_RESULT $? 0 0 'check docker build --no-cache -t imageert . failed'
```

- 涉及命令：test×1

#### oe_test_podman_DK_27

- 描述：docker build
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 1 0 'check value failed'
  CHECK_RESULT $? 0 0 'check docker build --authfile temp-auths/myauths.json --cert-dir failed'
  CHECK_RESULT $? 0 0 'check docker build --runtime-flag log-format=json . failed'
  CHECK_RESULT $? 0 0 'check docker build --tls-verify=false -t imagename . failed'
  CHECK_RESULT $? 0 0 'check docker build --tls-verify=true -t imagename1 -f Dockerfile.simple . failed'
  CHECK_RESULT $? 0 0 'check docker build -t imag .'
```

- 涉及命令：test×1

#### oe_test_podman_DK_28

- 描述：Backup / restore database
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 'check docker pod create --infra=false failed'
  CHECK_RESULT $? 1 0 'check name failed'
  CHECK_RESULT $? 0 0 'check docker pod ls failed'
  CHECK_RESULT $? 0 0 'check docker pod ps failed'
  CHECK_RESULT $? 0 0 'check docker pod list failed'
  CHECK_RESULT $? 0 0 'check docker pod pause failed'
  CHECK_RESULT $? 0 0 'check docker pod unpause failed'
  CHECK_RESULT $? 0 0 'check docker pod inspect failed'
  CHECK_RESULT $? 0 0 'check local_pid failed'
  CHECK_RESULT $? 0 0 'check docker pod stop failed'
  CHECK_RESULT $? 0 0 'check docker pod rm failed'
```

- 涉及命令：test×1, kill×1
