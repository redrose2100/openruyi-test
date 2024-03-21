// SPDX-License-Identifier: GPL-2.0

/*
 * Copyright (C) 2024 Cloud Inspur Corporation
 * Authors: Che liequan
 *
 * This software may be redistributed and/or modified under the terms of
 * the GNU General Public License ("GPL") version 2 only as published by the
 * Free Software Foundation.
 */
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <getopt.h>
#include <setjmp.h>
#include <errno.h>
#include <signal.h>
#include <linux/version.h>
#include <string.h>
#include <time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdint.h>
#include <stddef.h>

#define EINJ_ETYPE "/sys/kernel/debug/apei/einj/error_type"
#define EINJ_ETYPE_AVAILABLE "/sys/kernel/debug/apei/einj/available_error_type"
#define EINJ_ADDR "/sys/kernel/debug/apei/einj/param1"
#define EINJ_MASK "/sys/kernel/debug/apei/einj/param2"
#define EINJ_APIC "/sys/kernel/debug/apei/einj/param3"
#define EINJ_SBDF "/sys/kernel/debug/apei/einj/param4"
#define EINJ_FLAGS "/sys/kernel/debug/apei/einj/flags"
#define EINJ_NOTRIGGER "/sys/kernel/debug/apei/einj/notrigger"
#define EINJ_DOIT "/sys/kernel/debug/apei/einj/error_inject"
#define EINJ_VENDOR "/sys/kernel/debug/apei/einj/vendor"

#define EINJ_MODULE "/sys/kernel/debug/apei/einj"

#define MM_IOCTL_TYPE 0xF5
#define MM_IOCTL_COPY_FROM_USER_CMD _IO(MM_IOCTL_TYPE, 0)
#define MM_IOCTL_COPY_TO_USER_CMD _IO(MM_IOCTL_TYPE, 1)
#define MM_IOCTL_GET_USER_CMD _IO(MM_IOCTL_TYPE, 2)
#define MM_IOCTL_PUT_USER_CMD _IO(MM_IOCTL_TYPE, 3)
#define MM_IOCTL_GET_PHYS_ADDR_CMD _IO(MM_IOCTL_TYPE, 4)

#define DEVICE_NAME "/dev/mm_uce"
#define TEST_CHAR "EINJ_UCE"

static const char *shortopts = "ftpghc:Ckoe";
static int pagesize;
static int child_process;
#define COPY_FROM_USER_FLAG 0x001
#define COPY_TO_USER_FLAG 0x002
#define GET_USER_FLAG 0x04
#define PUT_USER_FLAG 0x08
#define COREDUMP_FLAG 0x10
#define COPY_ON_WRITE_FLAG 0x20

struct phys_addr_struct {
    unsigned long long phys_addr;
};


struct option longopts[] = {
  {"copyfrom",    no_argument,       NULL, 'f'},
  {"copyto", no_argument,       NULL, 't'},
  {"putuser",    no_argument, NULL, 'p'},
  {"getuser",    no_argument, NULL, 'g'},
  {"count",    required_argument, NULL, 'c'},
  {"coredump",    no_argument, NULL, 'C'},
  {"check",    no_argument, NULL, 'k'},
  {"copyonwrite",  no_argument, NULL, 'o'},
  {"enable-trace",  no_argument, NULL, 'e'},
  {"help",    no_argument, NULL, 'h'},
  {0,         0,                 0,      0},
};

extern unsigned long long vtop(unsigned long long addr, pid_t pid);
extern int mm_uce_trace_phys_addr_event(unsigned long long * ptr_phys_addr);
extern int enable_mm_uce_tracepoint();
extern int is_tracepoint_enabled();

char * progname;
int check_errortype_available(char *file, unsigned long long val)
{
	FILE *fp;
	int ret = -1;
	unsigned long long available_error_type;

	if (strcmp(file, EINJ_ETYPE) != 0)
		return 0;

	fp = fopen(EINJ_ETYPE_AVAILABLE, "r");
	if (!fp) {
		fprintf(stderr, "%s: cannot open '%s'\n", progname, file);
		exit(1);
	}

	while (fscanf(fp, "%llx%*[^\n]", &available_error_type) == 1) {
		if (val == available_error_type) {
			ret = 0;
			break;
		}
	}

	fclose(fp);
	return ret;
}

int wfile(char *file, unsigned long long val)
{
	FILE *fp;

	if (check_errortype_available(file, val) != 0) {
		fprintf(stderr, "%s: no support for error type: 0x%llx\n", progname, val);
		return -1;
	}

#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 14, 0)
	if (!strcmp(file, EINJ_FLAGS))
		return -1;
#endif

	fp = fopen(file, "w");
	if (fp == NULL) {
		fprintf(stderr, "%s: cannot open '%s'\n", progname, file);
		return -1;
	}
	fprintf(fp, "0x%llx\n", val);
	if (fclose(fp) == EOF) {
		fprintf(stderr, "%s: write error on '%s'\n", progname, file);
		return -1;
	}

    return 0;
}

int inject_mem_uc_simple(unsigned long long addr, int notrigger)
{
    int ret = 0;

    ret = wfile(EINJ_ETYPE, 0x10);
    if(ret != 0 ) {
      return ret;
    }

	ret = wfile(EINJ_ADDR, addr);
    if(ret != 0 ) {
      return ret;
    }

	ret = wfile(EINJ_MASK, ~0x0ul);
    if(ret != 0 ) {
      return ret;
    }

	ret = wfile(EINJ_FLAGS, 2);
    if(ret != 0 ) {
      return ret;
    }


	ret = wfile(EINJ_NOTRIGGER, notrigger);
    if(ret != 0 ) {
      return ret;
    }

	ret = wfile(EINJ_DOIT, 1);
    if(ret != 0 ) {
      return ret;
    }

    sleep(3);

    return 0;
}

#define CACHE_LINE_SIZE 64
size_t get_cache_line_size() {
    static size_t cacheLineSize = 0;
    if (cacheLineSize) return cacheLineSize;

    FILE* file = fopen("/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size", "r");
    if (file && fscanf(file, "%zu", &cacheLineSize) == 1) {
        fclose(file);
    } else {
        cacheLineSize = CACHE_LINE_SIZE;
    }

    return cacheLineSize;
}

void clear_cache(void* ptr, size_t size) {
    if (!ptr || size == 0) {
        fprintf(stderr, "ptr is null or size is zero\n");
        return;
    }

    #if defined(__aarch64__)
    uintptr_t start = (uintptr_t)ptr;
    uintptr_t end = start + size;
    start &= ~(get_cache_line_size() - 1);

    while (start < end) {
        asm volatile("dc civac, %0" : : "r"(start) : "memory");
        start += CACHE_LINE_SIZE;
    }
    asm volatile("dsb sy" : : : "memory");
    #endif
    sleep(1);
    __builtin___clear_cache(ptr, (char*)ptr + size);
}

static void *data_alloc_common(int flag)
{
	char	*p = mmap(NULL, pagesize, PROT_READ|PROT_WRITE, flag, -1, 0);
	int	i;

	if (p == NULL) {
		fprintf(stderr, "%s: cannot allocate memory\n", progname);
		exit(1);
	}
	srandom(getpid() * time(NULL));
	for (i = 0; i < pagesize; i++)
		p[i] = random();
	return p + pagesize / 4;
}

static void *data_alloc(void)
{
    return data_alloc_common(MAP_SHARED|MAP_ANON);
}

static void *data_alloc_private(void)
{
	return data_alloc_common(MAP_PRIVATE|MAP_ANON);
}

int do_copyfromuser_test()
{
    int fd;
    char *vaddr;
    unsigned long long paddr;
    pid_t pid;
    int ret = 0;

    vaddr = data_alloc();
    if (!vaddr) {
        fprintf(stderr, "Failed to allocate memory\n");
        return -1;
    }

    pid = getpid();
    char * user_string="hello from userspace!";

    paddr =vtop((unsigned long long)vaddr,pid);
    printf("copyfromuser vaddr = %p paddr = %llx\n", (void *)vaddr, paddr);

    strncpy(vaddr, user_string, strlen(user_string)+1);
    ret = inject_mem_uc_simple(paddr, 1);
    if(ret != 0)
    {
        fprintf(stderr, "inject address: %p fail\n", (void *)paddr);
        if (munmap(vaddr, pagesize) == -1) {
            perror("Failed to munmap");
        }    
        return ret;        
    }

    fd = open(DEVICE_NAME, O_RDWR);
    if (fd < 0) {
        perror("Failed to open the device");
        munmap(vaddr, pagesize);
        return errno;
    }
    
    clear_cache(vaddr, pagesize);
    if (ioctl(fd, MM_IOCTL_COPY_FROM_USER_CMD, vaddr) == -1) {
        perror("ioctl failed");
        munmap(vaddr, pagesize);
        return errno;
    }

    munmap(vaddr, pagesize);
    close(fd);

    usleep(100);
    return 0;
}

int do_copytouser_test()
{
    int fd;
    char *kaddr;
    unsigned long long paddr;
    pid_t pid;
    int ret = 0;
    char *buf = NULL;
    struct phys_addr_struct addr;

    buf = malloc(pagesize);
    if (buf == NULL) {
	fprintf(stderr, "%s: couldn't allocate memory\n", progname);
	return -1;
    }

    pid = getpid();

    fd = open(DEVICE_NAME, O_RDWR);
    if (fd < 0) {
        perror("Failed to open the device");
        free(buf);
        return errno;
    }

    kaddr = mmap(NULL, pagesize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (kaddr == MAP_FAILED) {
        perror("Failed to mmap");
        close(fd);
        free(buf);
        return -1;
    }
    //kaddr = kaddr + pagesize/4;

    usleep(100);
    paddr =vtop((unsigned long long)kaddr,pid);
    printf("copytouser vaddr = %p paddr = %llx\n", kaddr, paddr);
    
    ret = is_tracepoint_enabled();
    if(ret != 0){
        fprintf(stderr, "please excute '%s -e' enable the mm_uce_trace_event tracepoint\n",
                progname);
        if (munmap(kaddr, pagesize) == -1) {
            perror("Failed to munmap");
        }    
        close(fd);
        free(buf);
        exit(ret);           
    }

    ret = mm_uce_trace_phys_addr_event(&addr.phys_addr);
    if(ret != 0){
        perror("mm_uce_trace_phys_addr_event Failed to trace kmalloc");
	goto clean;
    }
    fprintf(stderr, "copytouser kaddr = %p pkaddr = %llx, pid=%lu\n", kaddr, addr.phys_addr, pid);
    
    ret = inject_mem_uc_simple(addr.phys_addr, 1);
    if(ret != 0)
    {
        fprintf(stderr, "inject address: %p fail\n", kaddr);
	goto clean;
    }

    paddr =vtop((unsigned long long)buf,pid);
    printf("copytouser vaddr = %p paddr = %llx\n", buf, paddr);

    ret = inject_mem_uc_simple(paddr, 1);
    if(ret != 0)
    {
        fprintf(stderr, "inject address: %llx fail\n", paddr);
	goto clean;
    }

    clear_cache(kaddr, pagesize);
    clear_cache(buf, pagesize);
    if (ioctl(fd, MM_IOCTL_COPY_TO_USER_CMD, buf) == -1) {
        perror("ioctl MM_IOCTL_COPY_TO_USER_CMD failed");
        ret = errno;
	goto clean;
    }
    fprintf(stderr, "Received message from kernel: %s\n", buf);

clean:    
    if (munmap(kaddr, pagesize) == -1) {
        perror("Failed to munmap");
    }  
    close(fd);
    free(buf);
    
    /* Give system a chance to process on possibly deep C-state idle cpus */
    usleep(100);
    return 0;
}

int do_getuser_test()
{
    int fd;
    char *vaddr;
    unsigned long long paddr;
    pid_t pid;
    char user_char = 'U'; 
    int ret = 0;

    vaddr = data_alloc();
    if (!vaddr) {
        fprintf(stderr, "Failed to allocate memory\n");
        return -1;
    }

    pid = getpid();

    *vaddr = user_char;
    paddr =vtop((unsigned long long)vaddr,pid);
    printf("getuser vaddr = %p paddr = %llx\n", vaddr, paddr);

    ret = inject_mem_uc_simple(paddr, 1);
    if(ret != 0)
    {
        fprintf(stderr, "inject address: %p fail\n", (void *)paddr);
        if (munmap(vaddr, pagesize) == -1) {
            perror("Failed to munmap");
        }    
        return ret;        
    }

    fd = open(DEVICE_NAME, O_RDWR);
    if (fd < 0) {
        perror("Failed to open the device");
        if (munmap(vaddr, pagesize) == -1) {
            perror("Failed to munmap");
        }    
        return errno;
    }

    clear_cache(vaddr, pagesize);
    if (ioctl(fd, MM_IOCTL_GET_USER_CMD, vaddr) == -1) {
  	perror("ioctl MM_IOCTL_GET_USER_CMD failed");
        if (munmap(vaddr, pagesize) == -1) {
            perror("Failed to munmap");
        }    
	close(fd);
	return errno;
    }

    if (munmap(vaddr, pagesize) == -1) {
        perror("Failed to munmap");
    }    
    close(fd);

    /* Give system a chance to process on possibly deep C-state idle cpus */
    usleep(100);
    return 0;
}

int do_putuser_test()
{
    int fd;
    char *kaddr;
    unsigned long long paddr;
    pid_t pid;
    int ret = 0;
    char *buf = NULL;
    struct phys_addr_struct addr;

    buf = malloc(pagesize);
    if (buf == NULL) {
	fprintf(stderr, "%s: couldn't allocate memory\n", progname);
	return -1;
    }

    pid = getpid();

    fd = open(DEVICE_NAME, O_RDWR);
    if (fd < 0) {
        perror("Failed to open the device");
        free(buf);
        return errno;
    }

    kaddr = mmap(NULL, pagesize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (kaddr == MAP_FAILED) {
        perror("Failed to mmap");
        ret = -1;
	goto clean;
    }

    usleep(100);

    ret = is_tracepoint_enabled();
    if(ret != 0){
        fprintf(stderr, "please excute '%s -e' enable the mm_uce_trace_event tracepoint\n",
                progname);
        if (munmap(kaddr, pagesize) == -1) {
             perror("Failed to munmap");
        } 
        close(fd);
        free(buf);
        exit(ret);           
    }

    ret = mm_uce_trace_phys_addr_event(&addr.phys_addr);
    if(ret != 0){
        perror("mm_uce_trace_phys_addr_event Failed to trace kmalloc");
	goto clean;
    }
    fprintf(stderr, "putuser kaddr = %p pkaddr = %llx, pid=%lu\n", kaddr, addr.phys_addr, pid);
    
    ret = inject_mem_uc_simple(addr.phys_addr, 1);
    if(ret != 0)
    {
        fprintf(stderr, "inject address: %p fail\n", kaddr);
	goto clean;
    }

    paddr =vtop((unsigned long long)buf,pid);
    printf("copytouser vaddr = %p paddr = %llx\n", buf, paddr);

    ret = inject_mem_uc_simple(paddr, 1);
    if(ret != 0)
    {
        fprintf(stderr, "inject address: %llx fail\n", paddr);
	goto clean;
    }

    clear_cache(buf, pagesize);
    clear_cache(kaddr, pagesize);
    
    if (ioctl(fd, MM_IOCTL_PUT_USER_CMD, buf) == -1) {
 	    perror("ioctl MM_IOCTL_PUT_USER_CMD failed");
	    ret = errno;
	    goto clean;
    }

    printf("received from kernel: %c\n", *buf);

clean:

    if (munmap(kaddr, pagesize) == -1) {
        perror("Failed to munmap");
    } 
    close(fd);
    free(buf);

    /* Give system a chance to process on possibly deep C-state idle cpus */
    usleep(100);
    return 0;
}

int do_coredump_test()
{
    char *vaddr;
    unsigned long long paddr;
    pid_t pid;
    int ret = 0;

    vaddr = data_alloc();
    if (!vaddr) {
        fprintf(stderr, "Failed to allocate memory\n");
        return -1;
    }

    pid = getpid();

    paddr =vtop((unsigned long long)vaddr,pid);
    printf("coredump vaddr = %p paddr = %llx\n", vaddr, paddr);

    ret = inject_mem_uc_simple(paddr, 1);
    if(ret != 0)
    {
        fprintf(stderr, "inject address: %p fail\n", vaddr);
        if (munmap(vaddr, pagesize) == -1) {
            perror("Failed to munmap");
        }    
        return ret;        
    }

    clear_cache(vaddr, pagesize);
    abort();

    return 0;
}

int do_copyonwrite_test()
{
    char *vaddr;
    unsigned long long paddr;
    pid_t pid;
    pid_t cow_pid;
    int  status;
    int ret = 0;

    vaddr = data_alloc_private();
    pid = getpid();

    paddr =vtop((unsigned long long)vaddr,pid);
    printf("copytonwrite vaddr = %p paddr = %llx\n", (void *)vaddr, paddr);

    ret = inject_mem_uc_simple(paddr, 1);
    if(ret != 0)
    {
        fprintf(stderr, "inject address: %p fail\n", vaddr);
        if (munmap(vaddr, pagesize) == -1) {
            perror("Failed to munmap");
        }    
        return ret;        
    }

    clear_cache(vaddr, pagesize);

    switch (cow_pid = fork()) {
    case -1:
    	fprintf(stderr, "%s: fork failed\n", progname);
    	return -1;
    case 0:
    	child_process = 1;
    	/* force kernel to copy this page */
    	*vaddr = '*';
        if (munmap(vaddr, pagesize) == -1) {
            perror("child failed to munmap");
        }         
    	exit(0);
    }
    
    fprintf(stderr, "%s: COW parent waiting for pid=%d\n", progname, cow_pid);
    while (wait(&status) != cow_pid);

    munmap(vaddr, pagesize); 

    /* Give system a chance to process on possibly deep C-state idle cpus */
    usleep(100);
    return 0;
}

void usage()
{
    fprintf(stderr, "Usage: mm_uce_user_test -k|--check\n"
		    "\tCheck Bios support Memory UCE testcase\n");
    fprintf(stderr, "Usage: mm_uce_user_test -f|--copyfrom\n"
		    "\tMemory UCE testcase in copyfromuser\n");
    fprintf(stderr, "Usage: mm_uce_user_test -t|--copyto\n"
		    "\tMemory UCE testcase in copytouser\n");
    fprintf(stderr, "Usage: mm_uce_user_test -o|--copyonwrite\n"
		    "\tMemory UCE testcase in copyonwrite\n");
    fprintf(stderr, "Usage: Mm_uce_user_test -p|--putuser\n"
		    "\tMemory UCE testcase in putuser\n");
    fprintf(stderr, "Usage: Mm_uce_user_test -g|--getuser\n"
		    "\tMemory UCE testcase in getuser\n");
    fprintf(stderr, "Usage: mm_uce_user_test -C|--coredump\n"
		    "\tMemory UCE testcase in coredump\n");
}

int do_action(unsigned long uflag, int count)
{
    int ret = 0;
    if (uflag == 0)
    {
        exit(0);
    }

    if (uflag & COPY_FROM_USER_FLAG)
    {
	fprintf(stderr, "uflag: COPY_FROM_USER_FLAG\n");
        ret = do_copyfromuser_test();
    }
    else if (uflag & COPY_TO_USER_FLAG)
    {
	fprintf(stderr, "uflag: COPY_TO_USER_FLAG\n");
        ret = do_copytouser_test();
    }else if (uflag & GET_USER_FLAG)
    {
	fprintf(stderr, "uflag: GET_USER_FLAG\n");
        ret = do_getuser_test();
    }else if (uflag & PUT_USER_FLAG)
    {
	fprintf(stderr, "uflag: PUT_USER_FLAG\n");
        ret = do_putuser_test();
    }
    else if (uflag & COREDUMP_FLAG)
    {
	fprintf(stderr, "uflag: COREDUMP_FLAG\n");
        ret = do_coredump_test();
    }
    else if (uflag & COPY_ON_WRITE_FLAG)
    {
	fprintf(stderr, "uflag: COPY_ON_WRITE_FLAG\n");
        ret = do_copyonwrite_test();
    }

    return ret == 0;
}

static jmp_buf env;
static void recover(int sig, siginfo_t *si, void *v)
{
	printf("signal %d code %d addr %p\n", sig, si->si_code, si->si_addr);
	siglongjmp(env, 1);
}

struct sigaction recover_act = {
	.sa_sigaction = recover,
	.sa_flags = SA_SIGINFO,
};

int is_privileged(void)
{
	if (getuid() != 0) {
		fprintf(stderr, "%s: must be root to run error injection tests\n", progname);
		return 0;
	}
	return 1;
}

int is_einj_support(void)
{
	if (access("/sys/firmware/acpi/tables/EINJ", R_OK) == -1) {
		fprintf(stderr, "%s: Error injection not supported, check your BIOS settings\n", progname);
		return 0;
	}
	if (access(EINJ_MODULE, R_OK) == -1) {
		fprintf(stderr, "%s: Is the einj.ko module loaded? Please insert einj module to continue test\n", progname);
		return 0;
	}
	if (access(EINJ_VENDOR, R_OK) == -1) {
		fprintf(stderr, "%s: Does ACPI5.0 is enabled? Please check your BIOS settings!\n", progname);
		return 0;
	}
	if (access(EINJ_NOTRIGGER, R_OK|W_OK) == -1) {
		fprintf(stderr, "%s: Error injection not supported in this machine\n", progname);
		return 0;
	}
	return 1;
}

int is_einj_mem_uc_support(void)
{
    unsigned long long  val = 0x10; 
    if (check_errortype_available(EINJ_ETYPE, val) != 0) {
	fprintf(stderr, "%s: no support for error type: 0x%llx\n", progname, val);
	return 0;
    }
    return 1;
}

static void check_einj_mem_uc_support(void)
{
	if (!is_privileged() || !is_einj_support() || !is_einj_mem_uc_support()){
	    exit(1);
	}
	else{
            fprintf(stderr, "Congratulations! you can make a uce test on this machine\n" );
	    exit(0);
	}
}

int main(int argc, char **argv)
{
    int c;
    pagesize = getpagesize();
    int count = 1;
    unsigned long uflag = 0;
    int ret = 0;
    int i = 0;

    progname = argv[0];
    if(argc < 2)
    {
        usage();
    }

    sigaction(SIGBUS, &recover_act, NULL);
    
    while ((c = getopt_long (argc, argv, shortopts, longopts, NULL)) != -1)
    {
        switch (c)
        {
        case 'f':
	    uflag |= COPY_FROM_USER_FLAG;
            break;
        case 't':
	    uflag |= COPY_TO_USER_FLAG;
            break;
        case 'p':
	    uflag |= PUT_USER_FLAG;
            break;
        case 'g':
	    uflag |= GET_USER_FLAG;
            break;
	case 'c':
            count = atoi(optarg);	    
            break;
	case 'C':
	    uflag |= COREDUMP_FLAG;
            break;
	case 'k':
	    check_einj_mem_uc_support();
            break;
	case 'o':
	    uflag |= COPY_ON_WRITE_FLAG;
            break;
	case 'e':
            if (enable_mm_uce_tracepoint() != EXIT_SUCCESS) {
                fprintf(stderr, "Unable to ensure tracepoint is enabled.\n");
                return EXIT_FAILURE;
            }
            exit(0);
	default:
            usage();
	    exit(-1);
        }
    }

    
    for(i=0; i < count; i++)
    {
	if (sigsetjmp(env, 1)) {
            fprintf(stderr, "recover from SIGBUS\n");
	}else {
            if ((uflag != 0) && !(uflag & COREDUMP_FLAG)) {
                fprintf(stderr, "test: %d, uflag:%lu \n", i, uflag);
    	    }else {
    	        fprintf(stderr, "uflag:%lu \n", uflag);
    	    }
    
            ret = do_action(uflag, count);
            if(ret == 1){
                fprintf(stderr, "test passed\n");
            }else {
                fprintf(stderr, "test fail\n");
            }
        }	
        
    	if (child_process){
            break;
    	}
    }
    return 0;
}

