#include <linux/module.h>
#include <linux/slab.h>
#include <linux/gfp.h>
#include <linux/types.h>

static char *addr[262144];

static unsigned long size = 4096;
static unsigned long i = 0;

module_param(size, ulong, S_IRUGO);

static int __init dfx_k_overloading_init(void)
{
    for (i = 0; i < 262144; i++)
    {
        addr[i] = (char *)kmalloc(size, GFP_KERNEL);
        if (addr[i] == NULL)
        {
            printk("kmalloc %ld error\n", i);
            return 1;
        }
        printk("kmalloc %ld pass\n", i);
        memset(addr[i], 0, size);
        printk("memset %ld pass\n", i);
    }

    return 0;
}

static void __exit dfx_k_overloading_exit(void)
{
    while ((i - 1 >= 0) && (addr[i - 1] != NULL))
    {
        kfree(addr[i - 1]);
        addr[i - 1] = NULL;
        i--;
    }

    return;
}

module_init(dfx_k_overloading_init);
module_exit(dfx_k_overloading_exit);
MODULE_LICENSE("GPL");