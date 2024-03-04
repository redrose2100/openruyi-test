# hmdfs

## hmdfs介绍
- 由于软件包hmdfs未包含对应树莓派版本的hmdfs.ko文件，因此在树莓派上执行测试套时，需先编译对应版本的hmdfs.ko文件
- 最好在服务器或者虚拟机上执行编译，树莓派上执行会出现异常报错
- hmdfs.ko编译完成之后，将文件放在测试节点1的/root目录下

#### hmdfs.ko编译命令
- 命令说明：wget命令下载对应版本的raspberrypi-kernel-devel包，注意版本对应

```
dnf install wget git rpm-build gcc make -y
cd /root
git clone https://gitee.com/src-openeuler/hmdfs -b openEuler-22.03-LTS-SP3
wget https://eulermaker.compass-ci.openeuler.openatom.cn/api/ems4/repositories/openEuler-22.03-LTS-SP3:everything/\
openEuler%3A22.03-LTS-SP3/aarch64/history/3f3fe6b6-b9bc-11ee-a889-be699dd13648/last/Packages/raspberrypi-kernel-devel\
-5.10.0-183.0.0.21.oe2203sp3.aarch64.rpm
rpm -ivh  raspberrypi-kernel-devel-5.10.0-183.0.0.21.oe2203sp3.aarch64.rpm
cd hmdfs
sed -i 's/kernel-devel/raspberrypi-kernel-devel/g' hmdfs.spec 0001-add-makefile-used-on-openeuler.patch
sed -i "s/3,4/4,5 | sed 's\/aarch64\/raspi.aarch64\/'/g" hmdfs.spec 0001-add-makefile-used-on-openeuler.patch
mkdir -p /root/rpmbuild/SOURCES && cp *  /root/rpmbuild/SOURCES
rpmbuild -bb hmdfs.spec
```

- hmdfs.ko文件存放位置：`/root/rpmbuild/BUILDROOT/hmdfs-1.0.0-1.aarch64/usr/lib/modules/5.10.0-183.0.0.21.oe2203sp3.raspi.aarch64/hmdfs/hmdfs.ko`

#### 环境清理
```
dnf remove wget git rpm-build gcc make -y
cd root
rpm -e raspberrypi-kernel-devel-5.10.0-183.0.0.21.oe2203sp3.aarch64
rm -rf  hmdfs raspberrypi-kernel-devel-5.10.0-183.0.0.21.oe2203sp3.aarch64.rpm rpmbuild
```