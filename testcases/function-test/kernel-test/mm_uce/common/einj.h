// SPDX-License-Identifier: GPL-2.0

/*
 * Copyright (C) 2023 Alibaba Corporation
 * Authors: Shuai Xue
 *
 * This software may be redistributed and/or modified under the terms of
 * the GNU General Public License ("GPL") version 2 only as published by the
 * Free Software Foundation.
 */

#ifndef EINJ_H
#define EINJ_H

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <linux/version.h>
#include <sys/mman.h>
#include <string.h>
#include <stdint.h>
#include <errno.h>

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

#define PRINT_INJECTING printf("injecting ...\n")
#define PRINT_TRIGGERING printf("triggering ...\n")
#define EINJ_MODULE "/sys/kernel/debug/apei/einj"

extern char *progname;
extern int Sflag;
extern long pagesize;

struct error_type {
	int type;
	char *type_name;
};

int check_errortype_available(char *file, unsigned long long val);

void wfile(char *file, unsigned long long val);

int is_einj_support(void);

int is_einj_mem_uc_support(void);

int is_privileged(void);

void inject_mem_uc(unsigned long long addr, void *vaddr, int notrigger);

char *lookup_type_name(unsigned long long type);

#endif /* EINJ_H */
