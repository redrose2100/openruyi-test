# os-storage

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `$OET_PATH/testcases/system-test/system-integration/os-storage` |
| 注册用例数 | 161 |
| 环境约束 | machine num = 2；machine type = kvm；add network interface = 2；add disk = 2,2,2,2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_storage_fileCMD_file | File system common command test-file | run_test | 3 |  |  |  |
| oe_test_storage_Mutipath_mpathconf | Use the mpathconf command to configure multipath, he will change multipath.conf | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_storage_Mutipath_dmsetup | View multipath devices with dmsetup command | run_test | 1 |  |  |  |
| oe_test_storage_lvm_add_VG | Add disks to VG | config_params/pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_lvm_expand_stripeLV | Lv of expansion stripe type | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_storage_mount_block_device | Mount through fast device and installation point | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_storage_lvm_change_number | Change the number of mirrors for the raid volume | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_storage_fileCMD_pwd | File system common command test-pwd | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_storage_mount_shared | Create a copy of the shared mount point | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_storage_lvm_rename | Rname LVM LV | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_DevMgmt_block_drop | Enable online block dropping | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_lvm_raid_synchronization | Trigger synchronization of raid volumes | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_diskpartiton_create_raid0 | Create raid0 | config_params/pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_lvm_rename_VG | Rename VG | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_ext4_resize | Resize ext4 file system | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_storage_Mutipath_configure_parameter | Configure user_friendly_names yes in /etc/multipath.conf | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_diskpartiton_view_fdisk | View partition-fdisk | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_storage_fileCMD_cat | File system common command test-cat | run_test | 4 |  |  |  |
| oe_test_storage_lvm_query_lvmsnap | Track and query the status of lvmsnap volumes | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_storage_fileCMD_mv | File system common command test-mv | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_storage_mount_private | Create private mount point copy | pre_test/run_test/post_test | 13 |  |  |  |
| oe_test_storage_lvm_create_cache | Create LVM cache volume | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_storage_DevMgmt_lsblk | Query disk attributes: lsblk | config_params/run_test/post_test | 7 | ✔ |  |  |
| oe_test_storage_fileCMD_mkfs | File system common command test-mkfs | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_storage_lvm_create_snapshot | Create snapshot volume | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_fileCMD_ln | File system common command test-ln | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_storage_mount_prevent_copy | Prevent copying mount points | run_test/post_test | 3 |  |  |  |
| oe_test_storage_mount_repeat | Mount repeatedly mounts and writes files after unmounting | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_storage_diskpartiton_parted_view | Use partedshell to view the partition table | config_params/run_test/post_test | 1 | ✔ |  |  |
| oe_test_storage_diskpartiton_fdisk_settype | Use fdisk to set the partition type | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_lvm_activation | Logical volume activation | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_mount_umount | Unmount the file system with umount | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_diskpartiton_fdisk | Create partition-fdisk | config_params/run_test/post_test | 3 |  |  |  |
| oe_test_storage_ext4_mount_write | Ext4 compatibility | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_storage_mount_mobile_point | Mobile mount point | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_storage_lvm_print_history | Print history log of LVM command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_storage_lvm_merge_VG | Merge 2 VGS | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_storage_DevMgmt_disk_operation | Disk operation:parted/fdisk | config_params/pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_storage_fileCMD_tar | File system common command test-tar | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_fileCMD_cp | File system common command test-cp | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_storage_lvm_help_info | LVM command help information | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_lvm_create_raid | Create LVM of raidl type | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_Mutipath_configure_device | Configure the device section | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_ext3_mount | Mount ext3 file system | config_params/pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_storage_Mutipath_view_info | View multipath configuration information | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_ext4_mount | Mount ext4 file system | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_storage_mount_findmnt | List currently mounted file systems | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_fileaccess_bashrc | Bashrc configuring umask | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_storage_ext3_create | Create an ext3 file system | config_params/pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_storage_fileCMD_rmdir | File system common command test-rmdir | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_storage_fileCMD_chmod | File system common command test-chmod | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_storage_fileCMD_gzip | File system common command test-gzip | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_storage_fileCMD_ls | File system common command test -ls | pre_test/run_test | 3 |  |  |  |
| oe_test_storage_lvm_cling | Using the way of clip to assign PV | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_diskpartiton_view_lsblk | View partition-lsblk | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_storage_longname_list | List persistent named properties | config_params/run_test/post_test | 5 |  |  |  |
| oe_test_storage_longname_modify | Modify persistent named properties | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_storage_mount_UUID | Mount the file system according to UUID using mount | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_fileCMD_mkdir | File system common command test-mkdir | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_storage_ext4_create | Create an ext4 file system | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_storage_lvm_separate_raid | Separate the image of a raid volume and convert it to an LV | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_storage_lvm_print_info | Print LVM information command | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_storage_diskpartiton_parted_resize | Using parted shell to resize partition | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_Mutipath_various_fields | The various fields of multipath.conf | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_storage_fileCMD_df | File system common command test-df | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_storage_lvm_replace_raid | Manually replace the device in a raid volume | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_storage_diskpartiton_parted_delete | Use parted shell to delete partition | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_lvm_pvs | Print LVM information in different formats | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_storage_diskpartiton_create_raid1 | Create RAID1 | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_Mutipath_initramfs | Use multipath in initramfs | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_storage_DevMgmt_swap | swap management | config_params/pre_test/run_test/post_test | 22 |  |  |  |
| oe_test_storage_Mutipath_configure_section | Configure the multipaths section | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_fileCMD_unzip | File system common command test-unzip | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_storage_lvm_lvdisplay_lvscan | Dispaly LV Information | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_lvm_print | LVM output print display | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_storage_fileCMD_chown | File system common command test-chown | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_storage_fileCMD_touch | File system common command test-touch | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_storage_fileCMD_grep | File system common command test-grep | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_storage_lvm_activation_missing | Activate a logical volume with a missing device | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_storage_diskpartiton_create_raid5 | Create RAID5 | config_params/pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_fileCMD_sort | File system common command test-sort | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_storage_fileCMD_dd | File system common command test-dd | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_storage_fileCMD_zip | File system common command test-zip | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_storage_lvm_resize_PV | Resize PV | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_lvm_replace_badraid | Replace the raid volume with a bad disk | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_storage_ext3_resize | Resize ext3 file system | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_storage_Mutipath_configure_defaults | Configure the defaults section | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_diskpartiton_fdisk_delete | Delete partition-fdisk | config_params/pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_storage_lvm_create_thinSnapshot | Create a snapshot of a thin volume | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_diskpartiton_parted_create | Use partedshell to create a partition | config_params/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_ext3_mount_write | Ext3 compatibility | config_params/pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_storage_fileCMD_cd | File system common command test-cd | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_storage_fileCMD_wc | File system common command test-wc | pre_test/run_test | 5 |  |  |  |
| oe_test_storage_Mutipath_configure_blacklist | Blacklist configuration | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_storage_mount_copy | Create a secondary mount point copy | pre_test/run_test/post_test | 13 |  |  |  |
| oe_test_storage_nfs_repeat_restart | NFS restart service repeatedly | pre_test/run_test/post_test | 6 | ✔ | ✔ |  |
| oe_test_storage_nfs_repeat_restartServer | NFS restart server | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_storage_nfs_configure_nfsv4 | Configure NFSv4 only servers | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_storage_nfs_modify_port | Modify NFS server operation port | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_nfs_showmount | NFS file system - showmount test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_nfs_mount_root | Mount root | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_storage_nfs_RPC | Export RPC quota through firewall | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_nfs_rpcinfo | rpcinfo -p test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_storage_nfs_mount_readonly | Mounting NFS supports read-only | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_storage_nfs_exportfs | NFS file system - exportfs command test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_storage_nfs_repeat_mount | NFS mount repeatedly | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_storage_nfs_mount_RW | Mounting NFS supports reading and writing | pre_test/run_test/post_test | 5 | ✔ | ✔ |  |
| oe_test_storage_nfs_share_mount | Mount mount NFS share | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_storage_nfs_network_latency | NFS network latency | pre_test/run_test/post_test | 7 | ✔ | ✔ |  |
| oe_test_storage_nfs_restrict_hostname | Restrict which hosts are allowed to mount by hostname | config_params/pre_test/run_test/post_test | 2 | ✔ | ✔ |  |
| oe_test_storage_nfs_write_full | Read write when NFS share is full | config_params/pre_test/run_test/post_test | 6 | ✔ | ✔ |  |
| oe_test_storage_nfs_start_server | Start NFS server | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_smb_cmd_smbcontrol | Common Samba command line utilities-smbcontrol | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_storage_repair_e2fsck | Check ext2, ext3, ext4 file system with e2fsck | config_params/pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_storage_smb_cmd_smbpasswd | Common Samba command line utilities-smbpasswd | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_storage_nfs_v3_v4 | Supported NFS versions, NFSv4, nfsv3 | pre_test/run_test/post_test | 6 | ✔ | ✔ |  |
| oe_test_storage_smb_cmd_smbstatus | Common Samba command line utilities-smbstatus | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_storage_repair_xfs | Check XFS file system with XFS? Repair | config_params/pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_storage_smb_3.0 | Using encrypted SMB 3.0 connection to mount share | pre_test/run_test/post_test | 2 | ✔ | ✔ |  |
| oe_test_storage_nfs_restrict_ip | Restrict which hosts are allowed to mount through IP address | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_storage_smb_cmd_rpcclient | Common Samba command line utilities-rpcclient | pre_test/run_test/post_test | 1 | ✔ | ✔ |  |
| oe_test_storage_smb_mount | SMB mount | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_storage_smb_multi-user_mount | Perform multi-user SMB mount | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_storage_smb_cmd_testparm | Common Samba command line utilities-testparm | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_vfat_mount_write | vfat test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_xfs_Increase_size | Increase the size of the XFS file system | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_storage_smb_guest_share | SMB enable guest access sharing | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_smb_POSIX_ACL | SMB add share using POSIX ACL | pre_test/run_test/post_test | 2 | ✔ | ✔ |  |
| oe_test_storage_smb_host_share | SMB configuration host based shared access | pre_test/run_test/post_test | 2 | ✔ | ✔ |  |
| oe_test_storage_smb_repeat_restart | SMB restarts services repeatedly | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_storage_smb_abnormal_poweroff | SMB structure abnormal power down | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_storage_smb_credential_files | Using credential files to authenticate SMB shares | pre_test/run_test/post_test | 2 | ✔ | ✔ |  |
| oe_test_storage_xfs_restore | Restore XFS file system from backup | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_smb_network_latency | SMB network latency | config_params/pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_storage_smb_automatically_mount | Automatically mount the SMB share when the system starts | pre_test/run_test/post_test | 2 | ✔ | ✔ |  |
| oe_test_storage_smb_mount_umount | SMB repeatedly mount and umount | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_storage_xfs_create | Create an XFS file system | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_smb_share_dir | Enables users to share directories on Samba servers | pre_test/run_test/post_test | 2 | ✔ | ✔ |  |
| oe_test_storage_smb_write_full | SMB mount | config_params/pre_test/run_test/post_test | 12 | ✔ | ✔ |  |
| oe_test_storage_smb_cmd_smbclient | Common Samba command line utilities-smbclient | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_storage_xfs_backup | Backup XFS file system | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_storage_lvm_set_regionsize | Set the region size of LV | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_storage_lvm_snapshot_merge | Merge a snapshot volume onto its original volume | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_lvm_VG_transfer | Transfer VG to another system | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_lvm_set_lvconvert_volume | Convert a raid volume to a linear volume | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_lvm_snapshot_tag | Using tag to merge snapshots | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_storage_lvm_specify_size | Specifies the unit in which the disk size is displayed | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_lvm_set_lvconvert_raid1 | Converting a mirrored LVM device to a RAID1 volume | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_storage_lvm_set_limit | Set the upper limit of IO used by raid type volume in the background | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_lvm_set_label | Set the label of primary and secondary equipment | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_lvm_set_lvconvert_raid | Convert a linear volume to a raid volume | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_storage_lvm_split_VG | Split a VG: put one PV in the VG into another PV | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_storage_DevMgmt_fstrim | DevMgmt fstrim | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_storage_btrfs_001 | Test btrfs file system identification | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_btrfs_002 | Test btrfs file system identification | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_fsck-btrfs | Command fsck.btrfs test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_storage_fsck-ext2 | Command fsck.ext2 test | run_test/post_test | 7 |  |  |  |
| oe_test_storage_fsck-ext3_01 | Command fsck.ext3 test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_storage_fsck-ext3_02 | Command fsck.ext3 test | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_storage_fsck-ext4 | Command fsck.ext4 test | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_storage_fsck-fat_01 | Command fsck.fat comprehensive test | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_storage_fileCMD_file

- 描述：File system common command test-file
- 函数：`run_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：file×1

#### oe_test_storage_Mutipath_mpathconf

- 描述：Use the mpathconf command to configure multipath, he will change multipath.conf
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：multipath×1

#### oe_test_storage_Mutipath_dmsetup

- 描述：View multipath devices with dmsetup command
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_storage_lvm_add_VG

- 描述：Add disks to VG
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext4×2, pvcreate×1, lvcreate×1, pvs×1, lvremove×1, vgremove×1

#### oe_test_storage_lvm_expand_stripeLV

- 描述：Lv of expansion stripe type
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, lvcreate×1, lvs×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_storage_mount_block_device

- 描述：Mount through fast device and installation point
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.xfs×1

#### oe_test_storage_lvm_change_number

- 描述：Change the number of mirrors for the raid volume
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：lvs×4, expect×2, pvcreate×1, lvcreate×1, lvextend×1, grep×1, lvremove×1, vgremove×1

#### oe_test_storage_fileCMD_pwd

- 描述：File system common command test-pwd
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_storage_mount_shared

- 描述：Create a copy of the shared mount point
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext2×2

#### oe_test_storage_lvm_rename

- 描述：Rname LVM LV
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lvcreate×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_storage_DevMgmt_block_drop

- 描述：Enable online block dropping
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mount×2, mkfs.xfs×1

#### oe_test_storage_lvm_raid_synchronization

- 描述：Trigger synchronization of raid volumes
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, vgcreate×1, expect×1, grep×1, lvchange×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_storage_diskpartiton_create_raid0

- 描述：Create raid0
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：mkfs.ext4×3, grep×1

#### oe_test_storage_lvm_rename_VG

- 描述：Rename VG
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, vgremove×1

#### oe_test_storage_ext4_resize

- 描述：Resize ext4 file system
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext4×1, e2fsck×1

#### oe_test_storage_Mutipath_configure_parameter

- 描述：Configure user_friendly_names yes in /etc/multipath.conf
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：multipath×1

#### oe_test_storage_diskpartiton_view_fdisk

- 描述：View partition-fdisk
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：fdisk×5

#### oe_test_storage_fileCMD_cat

- 描述：File system common command test-cat
- 函数：`run_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×1, cat×1

#### oe_test_storage_lvm_query_lvmsnap

- 描述：Track and query the status of lvmsnap volumes
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：lvcreate×3, lvs×3, lvremove×2, pvcreate×1, vgremove×1

#### oe_test_storage_fileCMD_mv

- 描述：File system common command test-mv
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×5

#### oe_test_storage_mount_private

- 描述：Create private mount point copy
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $(find /mnt/cdrom | wc -l) 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $(find /media/flashdisk | wc -l) 1
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：mkfs.ext2×2, test×2

#### oe_test_storage_lvm_create_cache

- 描述：Create LVM cache volume
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lvs×3, pvcreate×1, lvcreate×1, lvconvert×1, vgremove×1, pvremove×1

#### oe_test_storage_DevMgmt_lsblk

- 描述：Query disk attributes: lsblk
- 函数：`config_params, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext4×2, tune2fs×1, mkfs.xfs×1, xfs_admin×1, swaplabel×1, swapon×1

#### oe_test_storage_fileCMD_mkfs

- 描述：File system common command test-mkfs
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs×4, lsblk×1

#### oe_test_storage_lvm_create_snapshot

- 描述：Create snapshot volume
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, lvcreate×1, lvs×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_storage_fileCMD_ln

- 描述：File system common command test-ln
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_storage_mount_prevent_copy

- 描述：Prevent copying mount points
- 函数：`run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 32
```

#### oe_test_storage_mount_repeat

- 描述：Mount repeatedly mounts and writes files after unmounting
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.xfs×1

#### oe_test_storage_diskpartiton_parted_view

- 描述：Use partedshell to view the partition table
- 函数：`config_params, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_storage_diskpartiton_fdisk_settype

- 描述：Use fdisk to set the partition type
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×1

#### oe_test_storage_lvm_activation

- 描述：Logical volume activation
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lvchange×4, pvcreate×1, lvcreate×1, vgremove×1

#### oe_test_storage_mount_umount

- 描述：Unmount the file system with umount
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：mkfs.xfs×1

#### oe_test_storage_diskpartiton_fdisk

- 描述：Create partition-fdisk
- 函数：`config_params, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_storage_ext4_mount_write

- 描述：Ext4 compatibility
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext4×2

#### oe_test_storage_mount_mobile_point

- 描述：Mobile mount point
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "private"
  CHECK_RESULT $? 0 0 "mount move"
  CHECK_RESULT $? 0 0 "local_disk"
  CHECK_RESULT $?
```

- 涉及命令：mkfs.xfs×2, findmnt×1, test×1

#### oe_test_storage_lvm_print_history

- 描述：Print history log of LVM command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvs×2, pvcreate×1, lvcreate×1, lvchange×1, lvremove×1, vgremove×1

#### oe_test_storage_lvm_merge_VG

- 描述：Merge 2 VGS
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：vgremove×2, pvcreate×1, vgmerge×1

#### oe_test_storage_DevMgmt_disk_operation

- 描述：Disk operation:parted/fdisk
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT "$(grep -iEc "${local_disk}|${local_disk1}1|${local_disk1}2" /proc/partitions)" 3
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：grep×4, mkfs.ext4×2

#### oe_test_storage_fileCMD_tar

- 描述：File system common command test-tar
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：tar×2, test×1

#### oe_test_storage_fileCMD_cp

- 描述：File system common command test-cp
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×4

#### oe_test_storage_lvm_help_info

- 描述：LVM command help information
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_storage_lvm_create_raid

- 描述：Create LVM of raidl type
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext4×4, expect×3, grep×3

#### oe_test_storage_Mutipath_configure_device

- 描述：Configure the device section
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：multipath×1

#### oe_test_storage_ext3_mount

- 描述：Mount ext3 file system
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext3×1

#### oe_test_storage_Mutipath_view_info

- 描述：View multipath configuration information
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：multipath×1

#### oe_test_storage_ext4_mount

- 描述：Mount ext4 file system
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1, mkfs×1

#### oe_test_storage_mount_findmnt

- 描述：List currently mounted file systems
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：mkfs.xfs×1, mkfs.ext2×1

#### oe_test_storage_fileaccess_bashrc

- 描述：Bashrc configuring umask
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
```

- 涉及命令：userdel×2, grep×1

#### oe_test_storage_ext3_create

- 描述：Create an ext3 file system
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext3×3

#### oe_test_storage_fileCMD_rmdir

- 描述：File system common command test-rmdir
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1, rmdir×1

#### oe_test_storage_fileCMD_chmod

- 描述：File system common command test-chmod
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1

#### oe_test_storage_fileCMD_gzip

- 描述：File system common command test-gzip
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：gzip×2, test×2

#### oe_test_storage_fileCMD_ls

- 描述：File system common command test -ls
- 函数：`pre_test, run_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_storage_lvm_cling

- 描述：Using the way of clip to assign PV
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lvs×2, pvcreate×1, expect×1, grep×1, vgremove×1

#### oe_test_storage_diskpartiton_view_lsblk

- 描述：View partition-lsblk
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lsblk×4, grep×1

#### oe_test_storage_longname_list

- 描述：List persistent named properties
- 函数：`config_params, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext4×2

#### oe_test_storage_longname_modify

- 描述：Modify persistent named properties
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to view file system type"
  CHECK_RESULT $? 0 0 "Failed to modify the label and uuid of the file system"
  CHECK_RESULT $? 0 0 "Failed to view the uuid of the file system"
  CHECK_RESULT $? 0 0 "Failed to view the label of the file system"
  CHECK_RESULT $? 0 0 "Failed to view file system type"
  CHECK_RESULT $? 0 0 "Failed to modify the label and uuid of the file system"
  CHECK_RESULT $? 0 0 "Failed to view the label of the file system"
  CHECK_RESULT $? 0 0 "Failed to view the uuid of the file system"
  CHECK_RESULT $? 0 0 "Failed to view file system type"
  CHECK_RESULT $? 0 0 "Failed to modify the label and uuid of the file system"
  CHECK_RESULT $? 0 0 "Failed to view the label of the file system"
  CHECK_RESULT $? 0 0 "Failed to view the uuid of the file system"
```

- 涉及命令：mkfs.ext2×1, mkfs.xfs×1, tune2fs×1, xfs_admin×1

#### oe_test_storage_mount_UUID

- 描述：Mount the file system according to UUID using mount
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.xfs×1

#### oe_test_storage_fileCMD_mkdir

- 描述：File system common command test-mkdir
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×2

#### oe_test_storage_ext4_create

- 描述：Create an ext4 file system
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext4×3

#### oe_test_storage_lvm_separate_raid

- 描述：Separate the image of a raid volume and convert it to an LV
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext4×3, expect×2, grep×2, pvcreate×1, lvs×1, lvremove×1, vgremove×1

#### oe_test_storage_lvm_print_info

- 描述：Print LVM information command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_storage_diskpartiton_parted_resize

- 描述：Using parted shell to resize partition
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

#### oe_test_storage_Mutipath_various_fields

- 描述：The various fields of multipath.conf
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×1, multipath×1

#### oe_test_storage_fileCMD_df

- 描述：File system common command test-df
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_storage_lvm_replace_raid

- 描述：Manually replace the device in a raid volume
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：expect×3, grep×3, lvs×3, pvcreate×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_storage_diskpartiton_parted_delete

- 描述：Use parted shell to delete partition
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：grep×1

#### oe_test_storage_lvm_pvs

- 描述：Print LVM information in different formats
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvs×5, pvcreate×1, vgs×1, vgremove×1

#### oe_test_storage_diskpartiton_create_raid1

- 描述：Create RAID1
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：mkfs.ext4×4, grep×1

#### oe_test_storage_Mutipath_initramfs

- 描述：Use multipath in initramfs
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：multipath×1

#### oe_test_storage_DevMgmt_swap

- 描述：swap management
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(grep -c dm /proc/swaps)" 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(grep -c dm /proc/swaps)" 2
  CHECK_RESULT $?
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：swapoff×4, wipefs×3, swapon×3, sed×2, mkfs.ext4×1, lvresize×1, pvcreate×1, lvcreate×1, lvreduce×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_storage_Mutipath_configure_section

- 描述：Configure the multipaths section
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：multipath×1

#### oe_test_storage_fileCMD_unzip

- 描述：File system common command test-unzip
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×2

#### oe_test_storage_lvm_lvdisplay_lvscan

- 描述：Dispaly LV Information
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, lvcreate×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_storage_lvm_print

- 描述：LVM output print display
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, vgcreate×1, lvremove×1, vgremove×1

#### oe_test_storage_fileCMD_chown

- 描述：File system common command test-chown
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×1, test×1, userdel×1

#### oe_test_storage_fileCMD_touch

- 描述：File system common command test-touch
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1, touch×1

#### oe_test_storage_fileCMD_grep

- 描述：File system common command test-grep
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×4

#### oe_test_storage_lvm_activation_missing

- 描述：Activate a logical volume with a missing device
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lvchange×3, lvcreate×2, vgremove×2, pvcreate×1

#### oe_test_storage_diskpartiton_create_raid5

- 描述：Create RAID5
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：mkfs.ext4×4, mdadm×1

#### oe_test_storage_fileCMD_sort

- 描述：File system common command test-sort
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sort×3

#### oe_test_storage_fileCMD_dd

- 描述：File system common command test-dd
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext4×1

#### oe_test_storage_fileCMD_zip

- 描述：File system common command test-zip
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×2

#### oe_test_storage_lvm_resize_PV

- 描述：Resize PV
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext4×1, pvcreate×1

#### oe_test_storage_lvm_replace_badraid

- 描述：Replace the raid volume with a bad disk
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：expect×2, grep×2, mkfs.ext4×1, lvs×1, vgreduce×1, lvchange×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_storage_ext3_resize

- 描述：Resize ext3 file system
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext3×1, e2fsck×1

#### oe_test_storage_Mutipath_configure_defaults

- 描述：Configure the defaults section
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：multipath×1

#### oe_test_storage_diskpartiton_fdisk_delete

- 描述：Delete partition-fdisk
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

#### oe_test_storage_lvm_create_thinSnapshot

- 描述：Create a snapshot of a thin volume
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lvcreate×5, pvcreate×1, lvs×1, vgremove×1, pvremove×1

#### oe_test_storage_diskpartiton_parted_create

- 描述：Use partedshell to create a partition
- 函数：`config_params, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：expect×1

#### oe_test_storage_ext3_mount_write

- 描述：Ext3 compatibility
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext4×1, mkfs.ext3×1

#### oe_test_storage_fileCMD_cd

- 描述：File system common command test-cd
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_storage_fileCMD_wc

- 描述：File system common command test-wc
- 函数：`pre_test, run_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_storage_Mutipath_configure_blacklist

- 描述：Blacklist configuration
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：sed×5, multipath×1

#### oe_test_storage_mount_copy

- 描述：Create a secondary mount point copy
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $(find /media/flashdisk | wc -l) 1
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：mkfs.ext2×2, test×2

#### oe_test_storage_nfs_repeat_restart

- 描述：NFS restart service repeatedly
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×2, iptables×1, mount×1

#### oe_test_storage_nfs_repeat_restartServer

- 描述：NFS restart server
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×2, iptables×1, mount×1

#### oe_test_storage_nfs_configure_nfsv4

- 描述：Configure NFSv4 only servers
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 32
  CHECK_RESULT $? 32
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mount×3, iptables×1

#### oe_test_storage_nfs_modify_port

- 描述：Modify NFS server operation port
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×1, rpcinfo×1

#### oe_test_storage_nfs_showmount

- 描述：NFS file system - showmount test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：exportfs×1

#### oe_test_storage_nfs_mount_root

- 描述：Mount root
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：iptables×1, mount×1, test×1

#### oe_test_storage_nfs_RPC

- 描述：Export RPC quota through firewall
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_storage_nfs_rpcinfo

- 描述：rpcinfo -p test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：rpcinfo×1

#### oe_test_storage_nfs_mount_readonly

- 描述：Mounting NFS supports read-only
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：iptables×1, mount×1, test×1

#### oe_test_storage_nfs_exportfs

- 描述：NFS file system - exportfs command test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：exportfs×1

#### oe_test_storage_nfs_repeat_mount

- 描述：NFS mount repeatedly
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：iptables×1, mount×1, test×1

#### oe_test_storage_nfs_mount_RW

- 描述：Mounting NFS supports reading and writing
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：iptables×1, mount×1, test×1

#### oe_test_storage_nfs_share_mount

- 描述：Mount mount NFS share
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：iptables×1, mount×1

#### oe_test_storage_nfs_network_latency

- 描述：NFS network latency
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：iptables×1, mount×1, test×1

#### oe_test_storage_nfs_restrict_hostname

- 描述：Restrict which hosts are allowed to mount by hostname
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：iptables×1, mkdir×1, mount×1, sed×1

#### oe_test_storage_nfs_write_full

- 描述：Read write when NFS share is full
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：iptables×1, mount×1

#### oe_test_storage_nfs_start_server

- 描述：Start NFS server
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT ${status} 2
```

- 涉及命令：exportfs×1

#### oe_test_storage_smb_cmd_smbcontrol

- 描述：Common Samba command line utilities-smbcontrol
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：sed×1

#### oe_test_storage_repair_e2fsck

- 描述：Check ext2, ext3, ext4 file system with e2fsck
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：e2fsck×3, mkfs.ext2×1, mkfs.ext3×1, mkfs.ext4×1

#### oe_test_storage_smb_cmd_smbpasswd

- 描述：Common Samba command line utilities-smbpasswd
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：smbpasswd×3, expect×1, grep×1, userdel×1

#### oe_test_storage_nfs_v3_v4

- 描述：Supported NFS versions, NFSv4, nfsv3
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mount×2, test×2, iptables×1, mkdir×1

#### oe_test_storage_smb_cmd_smbstatus

- 描述：Common Samba command line utilities-smbstatus
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_storage_repair_xfs

- 描述：Check XFS file system with XFS? Repair
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：mkfs.xfs×2, xfs_repair×1

#### oe_test_storage_smb_3.0

- 描述：Using encrypted SMB 3.0 connection to mount share
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：setsebool×1, mkdir×1, mount×1

#### oe_test_storage_nfs_restrict_ip

- 描述：Restrict which hosts are allowed to mount through IP address
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：iptables×1, mkdir×1, mount×1

#### oe_test_storage_smb_cmd_rpcclient

- 描述：Common Samba command line utilities-rpcclient
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 1
```

- 涉及命令：expect×1, grep×1

#### oe_test_storage_smb_mount

- 描述：SMB mount
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1, test×1, mount×1, userdel×1

#### oe_test_storage_smb_multi-user_mount

- 描述：Perform multi-user SMB mount
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：mkdir×1, expect×1, grep×1

#### oe_test_storage_smb_cmd_testparm

- 描述：Common Samba command line utilities-testparm
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
```

- 涉及命令：expect×2, grep×1

#### oe_test_storage_vfat_mount_write

- 描述：vfat test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs×1

#### oe_test_storage_xfs_Increase_size

- 描述：Increase the size of the XFS file system
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lvextend×2, lvcreate×1, mkfs.xfs×1

#### oe_test_storage_smb_guest_share

- 描述：SMB enable guest access sharing
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：sed×4, expect×1, grep×1

#### oe_test_storage_smb_POSIX_ACL

- 描述：SMB add share using POSIX ACL
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：setsebool×1, mkdir×1, mount×1

#### oe_test_storage_smb_host_share

- 描述：SMB configuration host based shared access
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：setsebool×1, mkdir×1, mount×1

#### oe_test_storage_smb_repeat_restart

- 描述：SMB restarts services repeatedly
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1, mount×1

#### oe_test_storage_smb_abnormal_poweroff

- 描述：SMB structure abnormal power down
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：setsebool×1, mkdir×1, mount×1

#### oe_test_storage_smb_credential_files

- 描述：Using credential files to authenticate SMB shares
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1, mount×1

#### oe_test_storage_xfs_restore

- 描述：Restore XFS file system from backup
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.xfs×1, xfsrestore×1, test×1

#### oe_test_storage_smb_network_latency

- 描述：SMB network latency
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1, mount×1, userdel×1

#### oe_test_storage_smb_automatically_mount

- 描述：Automatically mount the SMB share when the system starts
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：setsebool×1, mkdir×1, mount×1

#### oe_test_storage_smb_mount_umount

- 描述：SMB repeatedly mount and umount
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1, mount×1

#### oe_test_storage_xfs_create

- 描述：Create an XFS file system
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lsblk×1, mkfs.xfs×1

#### oe_test_storage_smb_share_dir

- 描述：Enables users to share directories on Samba servers
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×4, test×1, setsebool×1, mkdir×1, mount×1

#### oe_test_storage_smb_write_full

- 描述：SMB mount
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1, test×1, mount×1

#### oe_test_storage_smb_cmd_smbclient

- 描述：Common Samba command line utilities-smbclient
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：smbclient×2, expect×1, grep×1

#### oe_test_storage_xfs_backup

- 描述：Backup XFS file system
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：mkfs.xfs×1

#### oe_test_storage_lvm_set_regionsize

- 描述：Set the region size of LV
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
```

- 涉及命令：expect×2, grep×2, pvcreate×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_storage_lvm_snapshot_merge

- 描述：Merge a snapshot volume onto its original volume
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, lvcreate×1, lvs×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_storage_lvm_VG_transfer

- 描述：Transfer VG to another system
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1, vgremove×1

#### oe_test_storage_lvm_set_lvconvert_volume

- 描述：Convert a raid volume to a linear volume
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lvs×2, lvcreate×1, lvconvert×1, lvremove×1, vgremove×1

#### oe_test_storage_lvm_snapshot_tag

- 描述：Using tag to merge snapshots
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：expect×3, grep×3, mkfs.ext4×2, pvcreate×1, lvcreate×1, lvs×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_storage_lvm_specify_size

- 描述：Specifies the unit in which the disk size is displayed
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pvcreate×1

#### oe_test_storage_lvm_set_lvconvert_raid1

- 描述：Converting a mirrored LVM device to a RAID1 volume
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lvs×2, pvcreate×1, lvcreate×1, lvconvert×1, lvremove×1, vgremove×1

#### oe_test_storage_lvm_set_limit

- 描述：Set the upper limit of IO used by raid type volume in the background
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：expect×1, grep×1, lvremove×1, vgremove×1

#### oe_test_storage_lvm_set_label

- 描述：Set the label of primary and secondary equipment
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkfs.ext4×2, pvcreate×1, lvcreate×1

#### oe_test_storage_lvm_set_lvconvert_raid

- 描述：Convert a linear volume to a raid volume
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：lvcreate×1, expect×1, grep×1, lvs×1, lvremove×1, vgremove×1

#### oe_test_storage_lvm_split_VG

- 描述：Split a VG: put one PV in the VG into another PV
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：lvcreate×2, pvcreate×1, lvchange×1, lvremove×1, vgremove×1

#### oe_test_storage_DevMgmt_fstrim

- 描述：DevMgmt fstrim
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1, mkfs.ext4×1, mount×1

#### oe_test_storage_btrfs_001

- 描述：Test btrfs file system identification
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Formatting failure"
  CHECK_RESULT $? 0 0 "Mount failure"
  CHECK_RESULT $? 0 0 "Create failure"
  CHECK_RESULT $? 0 1 "Umount failure"
```

- 涉及命令：test×2, mkfs×1

#### oe_test_storage_btrfs_002

- 描述：Test btrfs file system identification
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Formatting failure"
  CHECK_RESULT $? 0 0 "Mount failure"
  CHECK_RESULT $? 0 0 "Create snap failure"
  CHECK_RESULT $? 0 0 "Umount failure"
```

- 涉及命令：mkfs×1

#### oe_test_storage_fsck-btrfs

- 描述：Command fsck.btrfs test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Create btrfs image file failed"
  CHECK_RESULT $? 0 0 "Format to btrfs failed"
  CHECK_RESULT $? 0 0 "fsck.btrfs check failed"
  CHECK_RESULT $? 0 0 "fsck.btrfs --help failed"
```

- 涉及命令：mkfs.btrfs×1

#### oe_test_storage_fsck-ext2

- 描述：Command fsck.ext2 test
- 函数：`run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Create ext2 image file failed"
  CHECK_RESULT $? 0 0 "Format to ext2 failed"
  CHECK_RESULT $? 0 0 "fsck.ext2 -n failed"
  CHECK_RESULT $? 0 0 "fsck.ext2 -p failed"
  CHECK_RESULT $? 0 0 "fsck.ext2 -y failed"
  CHECK_RESULT $? 0 0 "fsck.ext2 -V failed"
  CHECK_RESULT $? 0 0 "fsck.ext2 -V check failed"
```

- 涉及命令：fsck.ext2×4, mkfs.ext2×1, grep×1

#### oe_test_storage_fsck-ext3_01

- 描述：Command fsck.ext3 test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Create ext3 image file failed"
  CHECK_RESULT $? 0 0 "Format to ext3 failed"
  CHECK_RESULT $? 0 0 "fsck.ext3 -n failed"
  CHECK_RESULT $? 0 0 "fsck.ext3 -p failed"
  CHECK_RESULT $? 0 0 "fsck.ext3 -y -v failed"
  CHECK_RESULT $? 0 0 "fsck.ext3 -B failed"
```

- 涉及命令：fsck.ext3×4, mkfs.ext3×1

#### oe_test_storage_fsck-ext3_02

- 描述：Command fsck.ext3 test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Create ext3 image file failed"
  CHECK_RESULT $? 0 0 "Format to ext3 failed"
  CHECK_RESULT $? 0 0 "fsck.ext3 -l failed"
  CHECK_RESULT $? 0 0 "fsck.ext3 -L failed"
  CHECK_RESULT $? 0 0 "fsck.ext3 -z failed"
  CHECK_RESULT $? 0 0 "fsck.ext3 -V failed"
  CHECK_RESULT $? 0 0 "fsck.ext3 -V check failed"
```

- 涉及命令：fsck.ext3×4, mkfs.ext3×1, grep×1

#### oe_test_storage_fsck-ext4

- 描述：Command fsck.ext4 test
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Create ext4 image file failed"
  CHECK_RESULT $? 0 0 "Format to ext4 failed"
  CHECK_RESULT $? 0 0 "fsck.ext4 basic check failed"
  CHECK_RESULT $? 0 0 "fsck.ext4 -f (force check) failed"
  CHECK_RESULT $? 0 0 "fsck.ext4 -v (verbose) failed"
  CHECK_RESULT $? 0 0 "fsck.ext4 -p (auto repair) failed"
  CHECK_RESULT $? 0 0 "fsck.ext4 -y (yes to all) failed"
  CHECK_RESULT $? 0 0 "fsck.ext4 -f -v (combined options) failed"
```

- 涉及命令：fsck.ext4×6, mkfs.ext4×1

#### oe_test_storage_fsck-fat_01

- 描述：Command fsck.fat comprehensive test
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Create FAT32 image file failed"
  CHECK_RESULT $? 0 0 "Format to FAT32 failed"
  CHECK_RESULT $? 0 0 "fsck.fat -n basic check failed"
  CHECK_RESULT $? 0 0 "fsck.fat -v verbose mode failed"
  CHECK_RESULT $? 0 0 "fsck.fat -V verify mode failed"
  CHECK_RESULT $? 0 0 "fsck.fat -l list files failed"
  CHECK_RESULT $? 0 0 "fsck.fat -a auto repair failed"
  CHECK_RESULT $? 0 0 "fsck.fat -t bad clusters test failed"
```

- 涉及命令：fsck.fat×6, mkfs.vfat×1
