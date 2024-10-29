/* *****************************************************************************
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022 All rights reserved.
 * PowerAPI licensed under the Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan PSL v2.
 * You may obtain a copy of Mulan PSL v2 at:
 * http://license.coscl.org.cn/MulanPSL2
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR
 * PURPOSE.
 * See the Mulan PSL v2 for more details.
 * Author: jinye
 * Create: 2024-10-29
 * Description: PowerAPI DEMO for testing the interface.
 * **************************************************************************** */
#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>
#include <pwrapic/powerapi.h>

#define MAIN_LOOP_INTERVAL 5
#define TEST_FREQ 2400
#define TEST_CORE_NUM 128
#define AVG_LEN_PER_CORE 5
#define TEST_CPU_DMA_LATENCY 2000000000
#define TASK_INTERVAL 1000
#define TASK_MIN_INTERVAL 1000
#define TASK_MAX_INTERVAL 100000000
#define TASK_RUN_TIME 10
#define TEST_FREQ_RANGE_MIN 500
#define TEST_FREQ_RANGE_MAX 2500
#define TEST_MAX_PROC_NUM 100
#define INVALIDE_STATE (-1)
#define TEST_PID_NUM 1

static int g_run = 1;

static void PrintResult(char *function, int ret)
{
    int length = 24;
    printf("[TEST ]    ");
    printf("%-*s", length, function);
    printf(":");
    if (ret == PWR_SUCCESS) {
        printf("SUCCESS ret: %d\n", ret);
    } else {
        printf("ERROR   ret: %d\n", ret);
    }
}

enum {
    DEBUG = 0,
    INFO,
    WARNING,
    ERROR
};

static const char *GetLevelName(int level)
{
    static char debug[] = "DEBUG";
    static char info[] = "INFO";
    static char warning[] = "WARNING";
    static char error[] = "ERROR";
    switch (level) {
        case DEBUG:
            return debug;
        case INFO:
            return info;
        case WARNING:
            return warning;
        case ERROR:
            return error;
        default:
            return info;
    }
}

void LogCallback(int level, const char *fmt, va_list vl)
{
    char logLine[4096] = {0};
    char message[4000] = {0};
    int length = 5;

    if (vsnprintf(message, sizeof(message) - 1, fmt, vl) < 0) {
        return;
    }

    printf("[");
    printf("%-*s", length, GetLevelName(level));
    printf("]    %s\n", message);
}

void MetaDataCallback(const PWR_COM_CallbackData *callbackData)
{
    PWR_CPU_PerfData *perfData = NULL;
    PWR_CPU_Usage *usage = NULL;
    switch (callbackData->dataType) {
        case PWR_COM_DATATYPE_CPU_PERF:
            perfData = (PWR_CPU_PerfData *)(callbackData->data);
            printf("[TASK ]    Get perf data. ipc: %f  miss: %f, ctime:%s\n", perfData->ipc, perfData->llcMiss,
                callbackData->ctime);
            break;
        case PWR_COM_DATATYPE_CPU_USAGE:
            usage = (PWR_CPU_Usage *)(callbackData->data);
            printf("[TASK ]    Get cpu usage. avgUsage: %f, coreNum:%d, ctime:%s\n", usage->avgUsage, usage->coreNum,
                callbackData->ctime);
            /* for (int i = 0; i < usage->coreNum; i++) {
                printf("      core%d usage: %f\n", usage->coreNum[i].coreNo, usage->coreNum[i].usage);
            } */
            break;
        default:
            printf("[TASK ]    Get invalide data.\n");
            break;
    }
}

void EventCallback(const PWR_COM_EventInfo *eventInfo)
{
    printf("[Event]    Get event notification\n");
    switch (eventInfo->eventType) {
        case PWR_COM_EVTTYPE_CRED_FAILED:
            printf("[Event]    ctime: %s, type: %d, info: %s\n", eventInfo->ctime,
                eventInfo->eventType, eventInfo->info);
            break;
        default:
            printf("[Event]    Get invalid event.\n");
            break;
    }
}

static void SignalHandler(int none)
{
    g_run = 0;
}

static void SetupSignal(void)
{
    // regist signal handler
    (void)signal(SIGINT, SignalHandler);
    (void)signal(SIGUSR1, SignalHandler);
    (void)signal(SIGUSR2, SignalHandler);
    (void)signal(SIGTERM, SignalHandler);
    (void)signal(SIGKILL, SignalHandler);
}
/************************** COMMON ************************/
static void TEST_PWR_SetLogCallback(void)
{
    int ret = -1;
    ret = PWR_SetLogCallback(LogCallback);
    PrintResult("PWR_SetLogCallback", ret);
}

static void TEST_PWR_SetServerInfo(void)
{
    int ret = -1;
    char sock_file[] = "/etc/sysconfig/pwrapis/pwrserver.sock";
    ret = PWR_SetServerInfo(sock_file);
    PrintResult("PWR_SetServerInfo", ret);
}

static void TEST_PWR_Register(void)
{
    while (PWR_Register() != PWR_SUCCESS) {
        sleep(MAIN_LOOP_INTERVAL);
        PrintResult("PWR_Register", PWR_ERR_COMMON);
        continue;
    }
    PrintResult("PWR_Register", PWR_SUCCESS);
}

static void TEST_PWR_UnRegister(void)
{
    while (PWR_UnRegister() != PWR_SUCCESS) {
        sleep(MAIN_LOOP_INTERVAL);
        PrintResult("PWR_UnRegister", PWR_ERR_COMMON);
        continue;
    }
    PrintResult("PWR_UnRegister", PWR_SUCCESS);
}

static void TEST_PWR_RequestControlAuth(void)
{
    int ret = -1;
    ret = PWR_RequestControlAuth();
    PrintResult("PWR_RequestControlAuth", ret);
}

static void TEST_PWR_ReleaseControlAuth(void)
{
    int ret = -1;
    ret = PWR_ReleaseControlAuth();
    PrintResult("PWR_ReleaseControlAuth", ret);
}

static void TEST_PWR_SetClientSockPath(char str[])
{
    int ret = -1;
    ret = PWR_SetClientSockPath(str);
    PrintResult("PWR_SetClientSockPath", ret);
}

static void TEST_PWR_COM_DcTaskMgr(void)
{
    int ret = -1;
    ret = PWR_SetMetaDataCallback(MetaDataCallback);
    PrintResult("PWR_SetMetaDataCallback", ret);

    PWR_COM_BasicDcTaskInfo task = {0};
    task.dataType = PWR_COM_DATATYPE_CPU_PERF;
    task.interval = TASK_MIN_INTERVAL;
    ret = PWR_CreateDcTask(&task);
    PrintResult("PWR_CreateDcTask", ret);
    printf("dataType:%d\n", task.dataType);

    task.dataType = PWR_COM_DATATYPE_CPU_USAGE;
    ret = PWR_CreateDcTask(&task);
    PrintResult("PWR_CreateDcTask", ret);
    printf("dataType:%d\n", task.dataType);

    task.dataType = PWR_COM_DATATYPE_INVALIDE;
    ret = PWR_CreateDcTask(&task);
    PrintResult("PWR_CreateDcTask", ret);
    printf("dataType:%d\n", task.dataType);

    task.dataType = 4;
    ret = PWR_CreateDcTask(&task);
    PrintResult("PWR_CreateDcTask", ret);
    printf("dataType:%d\n", task.dataType);

    task.dataType = -1;
    ret = PWR_CreateDcTask(&task);
    PrintResult("PWR_CreateDcTask", ret);
    printf("dataType:%d\n", task.dataType);

    sleep(TASK_RUN_TIME);
    ret = PWR_DeleteDcTask(PWR_COM_DATATYPE_CPU_PERF);
    PrintResult("PWR_DeleteDcTask", ret);
    printf("dataType:%d\n", PWR_COM_DATATYPE_CPU_PERF);

    ret = PWR_DeleteDcTask(PWR_COM_DATATYPE_CPU_USAGE);
    PrintResult("PWR_DeleteDcTask", ret);
    printf("dataType:%d\n", PWR_COM_DATATYPE_CPU_USAGE);

    ret = PWR_DeleteDcTask(PWR_COM_DATATYPE_INVALIDE);
    PrintResult("PWR_DeleteDcTask", ret);
    printf("dataType:%d\n", PWR_COM_DATATYPE_INVALIDE);
}

static void TEST_PWR_COM_DcTaskMgr_1(void)
{
    int ret = -1;
    ret = PWR_SetMetaDataCallback(MetaDataCallback);
    PrintResult("PWR_SetMetaDataCallback", ret);

    PWR_COM_BasicDcTaskInfo task = {0};
    task.dataType = PWR_COM_DATATYPE_CPU_PERF;
    task.interval = TASK_MIN_INTERVAL;
    ret = PWR_CreateDcTask(&task);
    PrintResult("PWR_CreateDcTask", ret);
    printf("interval:%d\n", task.interval);

    task.interval = TASK_MAX_INTERVAL;
    ret = PWR_CreateDcTask(&task);
    PrintResult("PWR_CreateDcTask", ret);
    printf("interval:%d\n", task.interval);

    task.interval = TASK_MIN_INTERVAL-1;
    ret = PWR_CreateDcTask(&task);
    PrintResult("PWR_CreateDcTask", ret);
    printf("interval:%d\n", task.interval);

    task.interval = TASK_MAX_INTERVAL+1;
    ret = PWR_CreateDcTask(&task);
    PrintResult("PWR_CreateDcTask", ret);
    printf("interval:%d\n", task.interval);

    sleep(TASK_RUN_TIME);
    ret = PWR_DeleteDcTask(PWR_COM_DATATYPE_CPU_PERF);
    PrintResult("PWR_DeleteDcTask", ret);
    printf("dataType:%d\n", PWR_COM_DATATYPE_CPU_PERF);
}
/************************** COMMON END************************/

/***************************** SYS ***************************/
static void TEST_SYS_GetRtPowerInfo(void)
{
    int ret = -1;
    PWR_SYS_PowerInfo *powerInfo = (PWR_SYS_PowerInfo *)malloc(sizeof(PWR_SYS_PowerInfo));
    if (!powerInfo) {
        return;
    }
    bzero(powerInfo, sizeof(PWR_SYS_PowerInfo));
    ret = PWR_SYS_GetRtPowerInfo(powerInfo);
    PrintResult("PWR_SYS_GetRtPower", ret);
    printf("    sys rt power:%d\n", powerInfo->sysPower);
    printf("    cpu rt power:%d\n", powerInfo->cpuPower);
    printf("    mem rt power:%d\n", powerInfo->memPower);
    free(powerInfo);
}
/*************************** SYS END *************************/


