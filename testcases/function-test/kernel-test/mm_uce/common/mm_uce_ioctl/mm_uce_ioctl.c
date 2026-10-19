// SPDX-License-Identifier: GPL-2.0

/*
 * Copyright (C) 2024 Cloud Inspur Corporation
 * Authors: Che liequan
 *
 * This software may be redistributed and/or modified under the terms of
 * the GNU General Public License ("GPL") version 2 only as published by the
 * Free Software Foundation.
 */

#include <linux/module.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/cdev.h>
#include <linux/slab.h>
#include <linux/uaccess.h>
#include <linux/mm.h> 
#include <linux/io.h>

#define CREATE_TRACE_POINTS
#include "mm_uce_trace_event.h"

#define DEVICE_NAME "mm_uce"
#define MM_IOCTL_TYPE 0xF5
#define MM_IOCTL_COPY_FROM_USER_CMD _IO(MM_IOCTL_TYPE, 0)
#define MM_IOCTL_COPY_TO_USER_CMD _IO(MM_IOCTL_TYPE, 1)
#define MM_IOCTL_GET_USER_CMD _IO(MM_IOCTL_TYPE, 2)
#define MM_IOCTL_PUT_USER_CMD _IO(MM_IOCTL_TYPE, 3)
#define MM_IOCTL_GET_PHYS_ADDR_CMD _IO(MM_IOCTL_TYPE, 4)

const  char TEST_MSG[] = "Hello from kernel!";

static int major;
static struct class *class;
static struct cdev cdev;
struct mm_private_data {
    void *kernel_buffer;
    size_t buffer_size;
    struct mutex buffer_lock;    
};

struct phys_addr_struct {
    unsigned long long phys_addr;
};

static const char *cmd_to_str(unsigned int cmd) {
    switch (cmd) {
        case MM_IOCTL_COPY_FROM_USER_CMD: return "MM_IOCTL_COPY_FROM_USER_CMD";
        case MM_IOCTL_COPY_TO_USER_CMD: return "MM_IOCTL_COPY_TO_USER_CMD";
        case MM_IOCTL_GET_USER_CMD: return "MM_IOCTL_GET_USER_CMD";
        case MM_IOCTL_PUT_USER_CMD: return "MM_IOCTL_PUT_USER_CMD";
        case MM_IOCTL_GET_PHYS_ADDR_CMD: return "MM_IOCTL_GET_PHYS_ADDR_CMD";
        default: return "UNKNOWN_CMD";
    }
}

static long mm_uce_ioctl(struct file *file, unsigned int cmd, unsigned long arg) {
    struct phys_addr_struct addr;   

    struct mm_private_data *priv = file->private_data;

    pr_info("Enter into mm_uce_ioctl, cmd = %s, arg: %lu\n", cmd_to_str(cmd), arg);
    switch (cmd) {
        case MM_IOCTL_COPY_FROM_USER_CMD:
            mutex_lock(&priv->buffer_lock);
            memset(priv->kernel_buffer, 0, priv->buffer_size);
            if (!priv->kernel_buffer) {
                mutex_unlock(&priv->buffer_lock);                
                return -ENOMEM;
            }
            if (copy_from_user(priv->kernel_buffer, (void __user *)arg, PAGE_SIZE)) {
                mutex_unlock(&priv->buffer_lock);                
                return -EFAULT;
            }
            pr_info("Data read from user space,%s\n", (char *)priv->kernel_buffer);
            mutex_unlock(&priv->buffer_lock);
            break;
        case MM_IOCTL_COPY_TO_USER_CMD:
            mutex_lock(&priv->buffer_lock);
            memset(priv->kernel_buffer, 0, priv->buffer_size);
	        memcpy(priv->kernel_buffer, TEST_MSG, sizeof(TEST_MSG));
	        if (!access_ok((void __user *)arg, sizeof(TEST_MSG))) {
                mutex_unlock(&priv->buffer_lock);
                return -EFAULT;
            }

            if (copy_to_user((void __user *)arg, priv->kernel_buffer, sizeof(TEST_MSG))) {
                pr_err("Message sent to user space error.\n");
                mutex_unlock(&priv->buffer_lock);
                return -EFAULT;
            }
            pr_info("Message sent to user space successful.\n");
            mutex_unlock(&priv->buffer_lock);
            break;
        case MM_IOCTL_GET_USER_CMD:
            mutex_lock(&priv->buffer_lock);
            memset(priv->kernel_buffer, 0, priv->buffer_size);
	        if (!access_ok((void __user *)arg, sizeof(char))) {
                mutex_unlock(&priv->buffer_lock);
                return -EFAULT;
            }
            if (get_user(*(char *)priv->kernel_buffer, (char __user *)arg)) {
                mutex_unlock(&priv->buffer_lock);
                return -EFAULT;
            }
            pr_info("Received char from user: %c\n", *(char *)priv->kernel_buffer);
            mutex_unlock(&priv->buffer_lock);
            break;
        case MM_IOCTL_PUT_USER_CMD:
            mutex_lock(&priv->buffer_lock);
            memset(priv->kernel_buffer, 0, priv->buffer_size);
	        memcpy(priv->kernel_buffer, TEST_MSG, sizeof(TEST_MSG));
	        if (!access_ok((void __user *)arg, sizeof(char))) {
                mutex_unlock(&priv->buffer_lock);
                return -EFAULT;
            }
            if (priv->kernel_buffer) {
                pr_info("priv->kernel_buffer: %c\n", *(char*)priv->kernel_buffer);
                if (put_user(*(char*)priv->kernel_buffer, (char __user *)arg)) {
                    mutex_unlock(&priv->buffer_lock);
                    return -EFAULT;
                }
            } else {
                mutex_unlock(&priv->buffer_lock);
                return -EINVAL;
            }
            mutex_unlock(&priv->buffer_lock);
            break;
        case MM_IOCTL_GET_PHYS_ADDR_CMD:       
            mutex_lock(&priv->buffer_lock);
            if (!priv->kernel_buffer) {
                pr_err("Kernel buffer is not allocated\n");
                return -EINVAL; 
            }
            
            addr.phys_addr = virt_to_phys(priv->kernel_buffer);   
            if (copy_to_user((unsigned long __user *)arg, &addr, sizeof(addr))) {
                pr_err("Failed to copy physical address to user space\n");
                return -EFAULT;
            }

            pr_info("Physical address %llx has been copied to user space\n", addr.phys_addr);
            mutex_unlock(&priv->buffer_lock);
            break;

        default:
            return -ENOTTY;
    }

    return 0;
}

static int mm_uce_open(struct inode *inode, struct file *file) {
    struct mm_private_data *priv = NULL; 

    pr_info("mm_uce_open %s\n", DEVICE_NAME);
    
    priv = kmalloc(sizeof(struct mm_private_data), GFP_KERNEL);
    if (!priv)
        return -ENOMEM;

    priv->buffer_size = PAGE_SIZE; 
    priv->kernel_buffer = kmalloc(priv->buffer_size, GFP_KERNEL);
    if (!priv->kernel_buffer) {
        kfree(priv);
        printk(KERN_ERR "Failed to allocate memory\n");
        return -ENOMEM;
    }

    mutex_init(&priv->buffer_lock); 

    memset(priv->kernel_buffer, 0, priv->buffer_size);
    strncpy(priv->kernel_buffer,TEST_MSG, strlen(TEST_MSG) + 1);
    file->private_data = priv;
    return 0;
}

static ssize_t mm_uce_read(struct file *filep, char *buffer, size_t len, loff_t *offset)
{
    int ret;
    struct mm_private_data *priv = filep->private_data;

    pr_info("mm_uce_read %s\n", DEVICE_NAME);
    if (len > PAGE_SIZE) {
        pr_info("read overflow!\n");
        ret = -EFAULT;
        goto out;
    }

    if (copy_to_user(buffer, priv->kernel_buffer, len) == 0) {
        pr_info("mm_uce_read: copy %lu char to the user\n", len);
        ret = len;
    } else {
        ret =  -EFAULT;   
    } 

out:
    return ret;
}

static ssize_t mm_uce_write(struct file *filep, const char *buffer, size_t len, loff_t *offset)
{
    int ret;
    struct mm_private_data *priv = filep->private_data;
    pr_info("mm_uce_write %s\n", DEVICE_NAME);

    if (len > PAGE_SIZE) {
        pr_info("write overflow!\n");
        ret = -EFAULT;
        goto out;
    }

    if (copy_from_user(priv->kernel_buffer, buffer, len)) {
        pr_err("mm_uce: write fault!\n");
        ret = -EFAULT;
        goto out;
    }
    pr_info("mm_uce: copy %lu char from the user\n", len);
    ret = len;

out:
    return ret;
}

static int mm_uce_release(struct inode *inode, struct file *file) {
    struct mm_private_data *priv = NULL;

    priv = file->private_data;
    pr_info("mm_uce_release %s\n", DEVICE_NAME);    

    if (priv->kernel_buffer)
        kfree(priv->kernel_buffer);
    kfree(priv);
    return 0;
}

static int mm_uce_mmap(struct file *file, struct vm_area_struct *vma) {
    int ret = 0;
    struct mm_private_data *priv = file->private_data;
    size_t size = vma->vm_end - vma->vm_start;
    
    pr_info("Entering mm_uce_mmap with size: %lu\n", size);   

    if (size > priv->buffer_size) {
        printk(KERN_INFO "Requested mmap size is too large.\n");
        return -EINVAL;
    }
   
    ret = remap_pfn_range(vma,
                    vma->vm_start,
                    virt_to_phys(priv->kernel_buffer) >> PAGE_SHIFT,
                    size,
                    vma->vm_page_prot);
    if (ret != 0) {
        printk(KERN_INFO "remap_pfn_range failed.\n");        
        return -EAGAIN;
    }   

    trace_mm_uce_open(priv->kernel_buffer, virt_to_phys(priv->kernel_buffer));

    return 0;
}

static struct file_operations fops = {
    .owner = THIS_MODULE,
    .open = mm_uce_open,
    .release = mm_uce_release, 
    .read = mm_uce_read,
    .write = mm_uce_write,    
    .mmap = mm_uce_mmap,      
    .unlocked_ioctl = mm_uce_ioctl,
};

static int __init uce_test_init(void) {
    major = register_chrdev(0, DEVICE_NAME, &fops);
    class = class_create(THIS_MODULE, DEVICE_NAME);
    device_create(class, NULL, MKDEV(major, 0), NULL, DEVICE_NAME);
    cdev_init(&cdev, &fops);
    cdev_add(&cdev, MKDEV(major, 0), 1);
    pr_info( "UCE Test module loaded\n");
    return 0;
}

static void __exit uce_test_exit(void) {
    device_destroy(class, MKDEV(major, 0));
    class_unregister(class);
    class_destroy(class);
    unregister_chrdev(major, DEVICE_NAME);
    cdev_del(&cdev);
    pr_info( "UCE Test module unloaded\n");
}

module_init(uce_test_init);
module_exit(uce_test_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("cheliequan@inspur.com");
MODULE_DESCRIPTION("UCE Test Module for IOCTL with uaccess");

