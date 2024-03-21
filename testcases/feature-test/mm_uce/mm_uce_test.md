cd common
make
make install

命令使用说明
使用前加载mm_user_ioctl和einj内核模块。
1、检测服务器操作系统是否支持内存UCE特性
./mm_uce_test –C

如果bios/uefi固件不支持注入，即不存在/sys/firmware/acpi/tables/EINJ目录，则错误为：
user_mm_uce_test: Error injection not supported, check your BIOS settings

如果没有加载einj模块，即不存在/sys/kernel/debug/apei/einj目录。则错误为：
user_mm_uce_test: Is the einj.ko module loaded? Please insert einj module to continue test

如果bios部分支持，即不存在/sys/kernel/debug/apei/einj/vendor，则错误为：
user_mm_uce_test: Error injection not supported, check your BIOS settings！

如果bios不支持注入，即/sys/kernel/debug/apei/einj/notrigger不可读不可写，则提示
user_mm_uce_test: Error injection not supported in this machine

2、uce_test检测通过后，执行下面命令测试各个场景
2.1 测试copy_from_user场景
./mm_uce_test  copyfromuser [-c|--count] <value> 
例如
   执行copy_from_user场景测试10次
    ./mm_uce_test   copyfromuser  -c 10     

执行命令结果：
[root@localhost common]# ./mm_uce_test copyfromuser
test: 0, uflag:1
uflag: COPY_FROM_USER_FLAG
copyfromuser vaddr = 0xffff9c44e400 paddr = 20200df50400
signal 7 code 3 addr (nil)
recover from SIGBUS

aarch64系统日志：
[16941.433108] mm_uce_open mm_uce
[16942.433790] Enter into mm_uce_ioctl, cmd = MM_IOCTL_COPY_FROM_USER_CMD, arg: 281473303503872
[16942.436427] {48}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 9
[16942.437206] {48}[Hardware Error]: event severity: recoverable
[16942.437600] {48}[Hardware Error]:  Error 0, type: recoverable
[16942.437986] {48}[Hardware Error]:   section_type: ARM processor error
[16942.438373] {48}[Hardware Error]:   MIDR: 0x00000000481fd010
[16942.438751] {48}[Hardware Error]:   Multiprocessor Affinity Register (MPIDR): 0x00000000812c0200
[16942.439494] {48}[Hardware Error]:   error affinity level: 0
[16942.439882] {48}[Hardware Error]:   running state: 0x1
[16942.440268] {48}[Hardware Error]:   Power State Coordination Interface state: 0
[16942.441042] {48}[Hardware Error]:   Error info structure 0:
[16942.441438] {48}[Hardware Error]:   num errors: 1
[16942.441823] {48}[Hardware Error]:    error_type: 0, cache error
[16942.442201] {48}[Hardware Error]:    error_info: 0x0000000000400014
[16942.442570] {48}[Hardware Error]:     cache level: 1
[16942.442926] {48}[Hardware Error]:     the error has not been corrected
[16942.443612] {48}[Hardware Error]:    virtual fault address: 0x0000000000000000
[16942.444299] {48}[Hardware Error]:    physical fault address: 0x000020200df50400
[16942.444997] {48}[Hardware Error]:   Vendor specific error info has 16 bytes:
[16942.445703] {48}[Hardware Error]:    00000000: 00000000 00000000 00000000 00000000  ................
[16942.452776] Memory failure: 0x20200df50: recovery action for dirty LRU page: Recovered
[16942.453607] mm_uce_release mm_uce


2.2 测试copy_to_user场景
./mm_uce_test copytouser  [-c|--count] <value> 
例如
执行copy_to_user场景测试10次
   ./mm_ uce_test  copytouser   -c 10  


执行命令结果
[root@localhost common]# ./mm_uce_test copytouser  -c 5
test: 0, uflag:2
uflag: COPY_TO_USER_FLAG
page not present
copytouser vaddr = 0xffffaddff000 paddr = ffffffffffffffff
Physical Address: 0x209081d000
Successfully read physical address: 209081d000
copytouser kaddr = 0xffffaddff000 pkaddr = 209081d000, pid=32044
copytouser vaddr = 0x3a2902a0 paddr = 20de93d2a0
Received message from kernel: Hello from kernel!
test passed
test: 1, uflag:2
uflag: COPY_TO_USER_FLAG
page not present
copytouser vaddr = 0xffffaddff000 paddr = ffffffffffffffff
Physical Address: 0x20ad5ed000
Successfully read physical address: 20ad5ed000
copytouser kaddr = 0xffffaddff000 pkaddr = 20ad5ed000, pid=32044
copytouser vaddr = 0x3a2902a0 paddr = 20de93d2a0
Received message from kernel: Hello from kernel!
test passed
test: 2, uflag:2
uflag: COPY_TO_USER_FLAG
page not present
copytouser vaddr = 0xffffaddff000 paddr = ffffffffffffffff
Physical Address: 0x2090736000
Successfully read physical address: 2090736000
copytouser kaddr = 0xffffaddff000 pkaddr = 2090736000, pid=32044
copytouser vaddr = 0x3a2902a0 paddr = 20de93d2a0
signal 7 code 4 addr 0x3a2902a0
recover from SIGBUS
test: 3, uflag:2
uflag: COPY_TO_USER_FLAG
page not present
copytouser vaddr = 0xffffaddfe000 paddr = ffffffffffffffff
signal 7 code 4 addr 0x3a290048
recover from SIGBUS
test: 4, uflag:2
uflag: COPY_TO_USER_FLAG
page not present
copytouser vaddr = 0xffffaddfd000 paddr = ffffffffffffffff
signal 7 code 4 addr 0x3a290048
recover from SIGBUS


aarch64系统日志
[17026.712751] mm_uce_open mm_uce
[17026.713281] Entering mm_uce_mmap with size: 4096
[17034.715157] Enter into mm_uce_ioctl, cmd = MM_IOCTL_COPY_TO_USER_CMD, arg: 176448160
[17034.715917] Message sent to user space successful.
[17034.716320] mm_uce_release mm_uce
[17043.052902] mm_uce_open mm_uce
[17043.053290] Entering mm_uce_mmap with size: 4096
[17051.055487] Enter into mm_uce_ioctl, cmd = MM_IOCTL_COPY_TO_USER_CMD, arg: 975766176
[17051.056242] Message sent to user space successful.
[17051.056632] mm_uce_release mm_uce
[17051.057197] mm_uce_open mm_uce
[17051.057577] Entering mm_uce_mmap with size: 4096
[17059.059597] Enter into mm_uce_ioctl, cmd = MM_IOCTL_COPY_TO_USER_CMD, arg: 975766176
[17059.060370] Message sent to user space successful.
[17059.060782] mm_uce_release mm_uce
[17059.061365] mm_uce_open mm_uce
[17059.061770] Entering mm_uce_mmap with size: 4096
[17067.063508] Enter into mm_uce_ioctl, cmd = MM_IOCTL_COPY_TO_USER_CMD, arg: 975766176
[17067.064253] Message sent to user space successful.
[17067.066470] {49}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 9
[17067.067192] {49}[Hardware Error]: event severity: recoverable
[17067.067553] {49}[Hardware Error]:  Error 0, type: recoverable
[17067.067902] {49}[Hardware Error]:   section_type: ARM processor error
[17067.068243] {49}[Hardware Error]:   MIDR: 0x00000000481fd010
[17067.068578] {49}[Hardware Error]:   Multiprocessor Affinity Register (MPIDR): 0x0000000081080100
[17067.069249] {49}[Hardware Error]:   error affinity level: 0
[17067.069592] {49}[Hardware Error]:   running state: 0x1
[17067.069925] {49}[Hardware Error]:   Power State Coordination Interface state: 0
[17067.070574] {49}[Hardware Error]:   Error info structure 0:
[17067.070918] {49}[Hardware Error]:   num errors: 1
[17067.071256] {49}[Hardware Error]:    error_type: 0, cache error
[17067.071590] {49}[Hardware Error]:    error_info: 0x0000000000400014
[17067.071913] {49}[Hardware Error]:     cache level: 1
[17067.072227] {49}[Hardware Error]:     the error has not been corrected
[17067.072854] {49}[Hardware Error]:    virtual fault address: 0x0000000000000000
[17067.073507] {49}[Hardware Error]:    physical fault address: 0x00000020de93d2a0
[17067.074164] {49}[Hardware Error]:   Vendor specific error info has 16 bytes:
[17067.074851] {49}[Hardware Error]:    00000000: 00000000 00000000 00000000 00000000  ................
[17067.080042] Memory failure: 0x20de93d: recovery action for dirty LRU page: Recovered
[17067.080834] mm_uce_open mm_uce
[17067.081207] Entering mm_uce_mmap with size: 4096
[17067.081822] mm_uce_open mm_uce
[17067.082182] Entering mm_uce_mmap with size: 4096
[17067.082841] mm_uce_release mm_uce
[17067.083198] mm_uce_release mm_uce
[17067.083539] mm_uce_release mm_uce



2.3 测试copy-on-write场景
./mm_uce_test  cow  [-c|--count] <value> 
例如
    ./mm_uce_test  cow -c 10  
执行copy-on-write场景测试10次

执行命令结果：
[root@localhost common]# ./mm_uce_test cow
test: 0, uflag:32
uflag: COPY_ON_WRITE_FLAG
copytonwrite vaddr = 0xffff8b0ce400 paddr = 20b945f400
user_mm_uce_test: COW parent waiting for pid=32056
signal 7 code 3 addr (nil)
recover from SIGBUS
test passed

aarch64系统日志：
[17067.080834] mm_uce_open mm_uce
[17067.081207] Entering mm_uce_mmap with size: 4096
[17067.081822] mm_uce_open mm_uce
[17067.082182] Entering mm_uce_mmap with size: 4096
[17067.082841] mm_uce_release mm_uce
[17067.083198] mm_uce_release mm_uce
[17067.083539] mm_uce_release mm_uce
[17134.835909] {50}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 9
[17134.836622] {50}[Hardware Error]: event severity: recoverable
[17134.836972] {50}[Hardware Error]:  Error 0, type: recoverable
[17134.837318] {50}[Hardware Error]:   section_type: ARM processor error
[17134.837659] {50}[Hardware Error]:   MIDR: 0x00000000481fd010
[17134.837990] {50}[Hardware Error]:   Multiprocessor Affinity Register (MPIDR): 0x0000000081090000
[17134.838656] {50}[Hardware Error]:   error affinity level: 0
[17134.839005] {50}[Hardware Error]:   running state: 0x1
[17134.839354] {50}[Hardware Error]:   Power State Coordination Interface state: 0
[17134.840039] {50}[Hardware Error]:   Error info structure 0:
[17134.840387] {50}[Hardware Error]:   num errors: 1
[17134.840723] {50}[Hardware Error]:    error_type: 0, cache error
[17134.841054] {50}[Hardware Error]:    error_info: 0x0000000000400014
[17134.841376] {50}[Hardware Error]:     cache level: 1
[17134.841686] {50}[Hardware Error]:     the error has not been corrected
[17134.842279] {50}[Hardware Error]:    virtual fault address: 0x0000000000000000
[17134.842874] {50}[Hardware Error]:    physical fault address: 0x00000020b945f400
[17134.843471] {50}[Hardware Error]:   Vendor specific error info has 16 bytes:
[17134.844096] {50}[Hardware Error]:    00000000: 00000000 00000000 00000000 00000000  ................
[17134.849244] Memory failure: 0x20b945f: recovery action for dirty LRU page: Recovered


2.4  测试getuser场景
./mm_uce_test  getuser [-c|--count] <value> 
例如
执行getuser场景测试10次
   ./mm_ uce_test  getuser  -c 10  


执行命令结果：
[root@localhost common]# ./mm_uce_test getuser
test: 0, uflag:4
uflag: GET_USER_FLAG
getuser vaddr = 0xffff98392400 paddr = 301da18400
signal 7 code 3 addr (nil)
recover from SIGBUS

aarch64系统日志：
[17199.033907] mm_uce_open mm_uce
[17200.034417] Enter into mm_uce_ioctl, cmd = MM_IOCTL_GET_USER_CMD, arg: 281473235624960
[17200.036989] {51}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 9
[17200.037748] {51}[Hardware Error]: event severity: recoverable
[17200.037756] {51}[Hardware Error]:  Error 0, type: recoverable
[17200.038595] {51}[Hardware Error]:   section_type: ARM processor error
[17200.038974] {51}[Hardware Error]:   MIDR: 0x00000000481fd010
[17200.039347] {51}[Hardware Error]:   Multiprocessor Affinity Register (MPIDR): 0x0000000081180200
[17200.040094] {51}[Hardware Error]:   error affinity level: 0
[17200.040478] {51}[Hardware Error]:   running state: 0x1
[17200.040854] {51}[Hardware Error]:   Power State Coordination Interface state: 0
[17200.041604] {51}[Hardware Error]:   Error info structure 0:
[17200.041999] {51}[Hardware Error]:   num errors: 1
[17200.042391] {51}[Hardware Error]:    error_type: 0, cache error
[17200.042784] {51}[Hardware Error]:    error_info: 0x0000000000400014
[17200.043168] {51}[Hardware Error]:     cache level: 1
[17200.043543] {51}[Hardware Error]:     the error has not been corrected
[17200.044262] {51}[Hardware Error]:    virtual fault address: 0x0000000000000000
[17200.044984] {51}[Hardware Error]:    physical fault address: 0x000000301da18400
[17200.045706] {51}[Hardware Error]:   Vendor specific error info has 16 bytes:
[17200.046427] {51}[Hardware Error]:    00000000: 00000000 00000000 00000000 00000000  ................
[17200.051678] Memory failure: 0x301da18: recovery action for dirty LRU page: Recovered
[17200.052513] mm_uce_release mm_uce


2.5 测试putuser场景
./mm_uce_test  putuser [-c|--count] <value> 
例如
执行putuser场景测试10次
    ./mm_uce_test  putuser  -c 10  


执行命令结果：
[root@localhost common]# ./mm_uce_test putuser
test: 0, uflag:8
uflag: PUT_USER_FLAG
Physical Address: 0x2090733000
Successfully read physical address: 2090733000
putuser kaddr = 0xffff87651000 pkaddr = 2090733000, pid=32072

copytouser vaddr = 0x31b112a0 paddr = 301c9142a0
signal 7 code 4 addr 0x31b112a0
recover from SIGBUS


aarch64系统日志：

[17250.533187] mm_uce_open mm_uce
[17250.533595] Entering mm_uce_mmap with size: 4096
[17258.535510] Enter into mm_uce_ioctl, cmd = MM_IOCTL_PUT_USER_CMD, arg: 833688224
[17258.536258] priv->kernel_buffer: H
[17258.538195] {52}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 9
[17258.538956] {52}[Hardware Error]: event severity: recoverable
[17258.539335] {52}[Hardware Error]:  Error 0, type: recoverable
[17258.539713] {52}[Hardware Error]:   section_type: ARM processor error
[17258.540091] {52}[Hardware Error]:   MIDR: 0x00000000481fd010
[17258.540461] {52}[Hardware Error]:   Multiprocessor Affinity Register (MPIDR): 0x0000000081190200
[17258.541189] {52}[Hardware Error]:   error affinity level: 0
[17258.541573] {52}[Hardware Error]:   running state: 0x1
[17258.541956] {52}[Hardware Error]:   Power State Coordination Interface state: 0
[17258.542718] {52}[Hardware Error]:   Error info structure 0:
[17258.543108] {52}[Hardware Error]:   num errors: 1
[17258.543487] {52}[Hardware Error]:    error_type: 0, cache error
[17258.543860] {52}[Hardware Error]:    error_info: 0x0000000000400014
[17258.544224] {52}[Hardware Error]:     cache level: 1
[17258.544577] {52}[Hardware Error]:     the error has not been corrected
[17258.545254] {52}[Hardware Error]:    virtual fault address: 0x0000000000000000
[17258.545934] {52}[Hardware Error]:    physical fault address: 0x000000301c9142a0
[17258.546608] {52}[Hardware Error]:   Vendor specific error info has 16 bytes:
[17258.547302] {52}[Hardware Error]:    00000000: 00000000 00000000 00000000 00000000  ................
[17258.552486] Memory failure: 0x301c914: recovery action for dirty LRU page: Recovered
[17258.553328] mm_uce_release mm_uce

2.6 测试coredump场景
./mm_uce_test  coredump -f  <ext4|pipefs|tmpfs|all>  [-c|--count] <value> 
例如
执行coredump ext4场景测试10次
   ./mm_ uce_test  coredump -f ext4  -c 10  

执行命令结果：
[root@localhost common]# ./mm_uce_test coredump -f ext4
uflag:16
uflag: COREDUMP_FLAG
coredump vaddr = 0xffffa20c7400 paddr = 20dd389400
../common.sh：行 100: 31921 Aborted                 （核心已转储）user_mm_uce_test --coredump

aarch64系统正常日志：

[ 1446.475603] EINJ: Error INJection is initialized.
[ 1450.647810] ghes_print_estatus: 2 callbacks suppressed
[ 1450.647812] {3}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 9
[ 1450.647952] {3}[Hardware Error]: event severity: recoverable
[ 1450.648007] {3}[Hardware Error]:  Error 0, type: recoverable
[ 1450.648062] {3}[Hardware Error]:   section_type: ARM processor error
[ 1450.648127] {3}[Hardware Error]:   MIDR: 0x00000000481fd010
[ 1450.648182] {3}[Hardware Error]:   Multiprocessor Affinity Register (MPIDR): 0x00000000813b0200
[ 1450.648264] {3}[Hardware Error]:   error affinity level: 0
[ 1450.648317] {3}[Hardware Error]:   running state: 0x1
[ 1450.648365] {3}[Hardware Error]:   Power State Coordination Interface state: 0
[ 1450.648438] {3}[Hardware Error]:   Error info structure 0:
[ 1450.648492] {3}[Hardware Error]:   num errors: 1
[ 1450.648536] {3}[Hardware Error]:    error_type: 0, cache error
[ 1450.648591] {3}[Hardware Error]:    error_info: 0x0000000000400014
[ 1450.648651] {3}[Hardware Error]:     cache level: 1
[ 1450.648699] {3}[Hardware Error]:     the error has not been corrected
[ 1450.648769] {3}[Hardware Error]:    virtual fault address: 0x0000000000000000
[ 1450.649272] {3}[Hardware Error]:    physical fault address: 0x0000203008688400
[ 1450.649979] {3}[Hardware Error]:   Vendor specific error info has 16 bytes:
[ 1450.650650] {3}[Hardware Error]:    00000000: 00000000 00000000 00000000 00000000  ................
[ 1450.655974] Memory failure: 0x203008688: recovery action for already truncated LRU page: Ignored

aarch64系统错误日志
[15853.297266] EINJ: Error INJection is initialized.
[15859.926095] UCE Test module loaded
[16693.417370] {45}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 9
[16693.418196] {45}[Hardware Error]: event severity: recoverable
[16693.418587] {45}[Hardware Error]:  Error 0, type: recoverable
[16693.418962] {45}[Hardware Error]:   section_type: ARM processor error
[16693.419329] {45}[Hardware Error]:   MIDR: 0x00000000481fd010
[16693.419697] {45}[Hardware Error]:   Multiprocessor Affinity Register (MPIDR): 0x00000000810b0300
[16693.420421] {45}[Hardware Error]:   error affinity level: 0
[16693.420787] {45}[Hardware Error]:   running state: 0x1
[16693.421152] {45}[Hardware Error]:   Power State Coordination Interface state: 0
[16693.421887] {45}[Hardware Error]:   Error info structure 0:
[16693.422273] {45}[Hardware Error]:   num errors: 1
[16693.422655] {45}[Hardware Error]:    error_type: 0, cache error
[16693.423029] {45}[Hardware Error]:    error_info: 0x0000000000400014
[16693.423396] {45}[Hardware Error]:     cache level: 1
[16693.423753] {45}[Hardware Error]:     the error has not been corrected
[16693.424436] {45}[Hardware Error]:    virtual fault address: 0x0000000000000000
[16693.425120] {45}[Hardware Error]:    physical fault address: 0x00000020dd389400
[16693.425803] {45}[Hardware Error]:   Vendor specific error info has 16 bytes:
[16693.426483] {45}[Hardware Error]:    00000000: 00000000 00000000 00000000 00000000  ................
[16693.427766] Memory failure: 0x20dd389: Failed to invalidate
[16693.428153] Memory failure: 0x20dd389: clean LRU page still referenced by 2 users
[16693.428882] Memory failure: 0x20dd389: recovery action for clean LRU page: Failed



执行coredump pipefs场景测试10次
    ./mm_uce_test  coredump -f pipefs  -c 10

执行命令结果：
[root@localhost common]# ./mm_uce_test coredump -f pipefs
uflag:16
uflag: COREDUMP_FLAG
coredump vaddr = 0xffff97282400 paddr = 20200d8c3400
../common.sh：行 100: 32104 Aborted                 （核心已转储）user_mm_uce_test --coredump

aarch64系统正常日志：
[17368.655773] {54}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 9
[17368.656817] {54}[Hardware Error]: event severity: recoverable
[17368.657196] {54}[Hardware Error]:  Error 0, type: recoverable
[17368.657572] {54}[Hardware Error]:   section_type: ARM processor error
[17368.657949] {54}[Hardware Error]:   MIDR: 0x00000000481fd010
[17368.658320] {54}[Hardware Error]:   Multiprocessor Affinity Register (MPIDR): 0x0000000081280000
[17368.659047] {54}[Hardware Error]:   error affinity level: 0
[17368.659415] {54}[Hardware Error]:   running state: 0x1
[17368.659782] {54}[Hardware Error]:   Power State Coordination Interface state: 0
[17368.660505] {54}[Hardware Error]:   Error info structure 0:
[17368.660874] {54}[Hardware Error]:   num errors: 1
[17368.661241] {54}[Hardware Error]:    error_type: 0, cache error
[17368.661610] {54}[Hardware Error]:    error_info: 0x0000000000400014
[17368.661979] {54}[Hardware Error]:     cache level: 1
[17368.662346] {54}[Hardware Error]:     the error has not been corrected
[17368.663067] {54}[Hardware Error]:    virtual fault address: 0x0000000000000000
[17368.663797] {54}[Hardware Error]:    physical fault address: 0x000020200d8c3400
[17368.664520] {54}[Hardware Error]:   Vendor specific error info has 16 bytes:
[17368.665245] {54}[Hardware Error]:    00000000: 00000000 00000000 00000000 00000000  ................
[17368.670463] Memory failure: 0x20200d8c3: recovery action for already truncated LRU page: Ignored


aarch64系统错误日志：
[17368.709194] {55}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 9
[17368.710157] {55}[Hardware Error]: event severity: recoverable
[17368.710544] {55}[Hardware Error]:  Error 0, type: recoverable
[17368.710926] {55}[Hardware Error]:   section_type: ARM processor error
[17368.711306] {55}[Hardware Error]:   MIDR: 0x00000000481fd010
[17368.711681] {55}[Hardware Error]:   Multiprocessor Affinity Register (MPIDR): 0x00000000810a0100
[17368.712425] {55}[Hardware Error]:   error affinity level: 0
[17368.712800] {55}[Hardware Error]:   running state: 0x1
[17368.713174] {55}[Hardware Error]:   Power State Coordination Interface state: 0
[17368.713910] {55}[Hardware Error]:   Error info structure 0:
[17368.714285] {55}[Hardware Error]:   num errors: 1
[17368.714659] {55}[Hardware Error]:    error_type: 0, cache error
[17368.715033] {55}[Hardware Error]:    error_info: 0x0000000000400014
[17368.715409] {55}[Hardware Error]:     cache level: 1
[17368.715780] {55}[Hardware Error]:     the error has not been corrected
[17368.716514] {55}[Hardware Error]:    virtual fault address: 0x0000000000000000
[17368.717247] {55}[Hardware Error]:    physical fault address: 0x0000002090733000
[17368.717981] {55}[Hardware Error]:   Vendor specific error info has 16 bytes:
[17368.718715] {55}[Hardware Error]:    00000000: 00000000 00000000 00000000 00000000  ................
[17368.719477] Internal error: synchronous external abort: 96000610 [#1] SMP


执行coredump tmpfs场景测试10次
   ./mm_ uce_test  coredump -f  tmpfs -c 10


执行命令结果
[root@localhost common]# ./user_mm_uce_test coredump -f tmpfs
test: 0, uflag:1
uflag: COPY_FROM_USER_FLAG
copyfromuser vaddr = 0xffff9209f400 paddr = 20cb909400
signal 7 code 3 addr (nil)
recover from SIGBUS


aarch64系统正常日志
[ 1553.696090] EINJ: Error INJection is initialized.
[ 1557.797405] {8}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 9
[ 1557.798175] {8}[Hardware Error]: event severity: recoverable
[ 1557.798498] {8}[Hardware Error]:  Error 0, type: recoverable
[ 1557.798818] {8}[Hardware Error]:   section_type: ARM processor error
[ 1557.799138] {8}[Hardware Error]:   MIDR: 0x00000000481fd010
[ 1557.799453] {8}[Hardware Error]:   Multiprocessor Affinity Register (MPIDR): 0x00000000813d0100
[ 1557.800073] {8}[Hardware Error]:   error affinity level: 0
[ 1557.800386] {8}[Hardware Error]:   running state: 0x1
[ 1557.800688] {8}[Hardware Error]:   Power State Coordination Interface state: 0
[ 1557.801269] {8}[Hardware Error]:   Error info structure 0:
[ 1557.801563] {8}[Hardware Error]:   num errors: 1
[ 1557.801846] {8}[Hardware Error]:    error_type: 0, cache error
[ 1557.802120] {8}[Hardware Error]:    error_info: 0x0000000000400014
[ 1557.802386] {8}[Hardware Error]:     cache level: 1
[ 1557.802646] {8}[Hardware Error]:     the error has not been corrected
[ 1557.802908] {8}[Hardware Error]:    virtual fault address: 0x0000000000000000
[ 1557.803423] {8}[Hardware Error]:    physical fault address: 0x0000203013f45400
[ 1557.803965] {8}[Hardware Error]:   Vendor specific error info has 16 bytes:
[ 1557.804545] {8}[Hardware Error]:    00000000: 00000000 00000000 00000000 00000000  ................
[ 1557.809989] Memory failure: 0x203013f45: recovery action for free buddy page: Recovered


执行coredump 所有场景测试遍历10次
    ./mm_uce_test  coredump -f all -c 10

相当于同时执行
   ./mm_ uce_test  coredump -f  tmpfs -c 10
   ./mm_ uce_test  coredump -f  pipefs -c 10
   ./mm_ uce_test  coredump -f  ext4 -c 10

执行所有场景测试遍历10次
    ./mm_uce_test  all  -c 10
相当于执行所有命令10遍


