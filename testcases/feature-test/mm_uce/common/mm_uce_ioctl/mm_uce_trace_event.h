// SPDX-License-Identifier: GPL-2.0

/*
 * Copyright (C) 2024 Cloud Inspur Corporation
 * Authors: Che liequan
 *
 * This software may be redistributed and/or modified under the terms of
 * the GNU General Public License ("GPL") version 2 only as published by the
 * Free Software Foundation.
 */

#undef TRACE_SYSTEM
#define TRACE_SYSTEM mm_uce_trace_event

#if !defined(_TRACE_MM_UCE_TRACE_EVENT_H) || defined(TRACE_HEADER_MULTI_READ)
#define _TRACE_MM_UCE_TRACE_EVENT_H

#include <linux/tracepoint.h>

TRACE_EVENT(mm_uce_open,
    TP_PROTO(void *virt_addr, unsigned long long phys_addr),
    TP_ARGS(virt_addr, phys_addr),
    TP_STRUCT__entry(
        __field(    void *,         virt_addr   )
        __field(    unsigned long long,  phys_addr   )
    ),
    TP_fast_assign(
        __entry->virt_addr = virt_addr;
        __entry->phys_addr = phys_addr;
    ),
    TP_printk("virt: %p, phys: %llx\n", __entry->virt_addr, __entry->phys_addr)
);

#endif /* _TRACE_MM_UCE_H */

//#undef TRACE_INCLUDE_PATH
//#define TRACE_INCLUDE_PATH .
#define TRACE_INCLUDE_FILE mm_uce_trace_event
#include <trace/define_trace.h>

