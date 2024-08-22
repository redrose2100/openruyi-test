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
 * Author: queyanwen
 * Create: 2022-06-23
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

/***************************** CPU ***************************/
static void TEST_PWR_CPU_GetInfo(void)
{
    int ret = -1;
    PWR_CPU_Info *info = (PWR_CPU_Info *)malloc(sizeof(PWR_CPU_Info));
    if (!info) {
        return;
    }
    bzero(info, sizeof(PWR_CPU_Info));
    ret = PWR_CPU_GetInfo(info);
    PrintResult("PWR_CPU_GetInfo", ret);
    printf("    arch: %s\n    coreNum: %d\n    maxFreq: %f\n    minFreq: %f\n    "
        "modelName: %s\n    numaNum: %d\n    threadsPerCore: %d\n", info->arch,
        info->coreNum, info->maxFreq, info->minFreq, info->modelName, info->numaNum,
        info->threadsPerCore);
    for (int i = 0; i < info->numaNum; i++) {
        printf("    numa node[%d]  cpuList: %s\n", info->numa[i].nodeNo, info->numa[i].cpuList);
    }
    free(info);
}


static void TEST_PWR_CPU_GetFreqAbility(void)
{
    int ret = -1;
    size_t len = sizeof(PWR_CPU_FreqAbility) + AVG_LEN_PER_CORE * TEST_CORE_NUM * sizeof(int);
    PWR_CPU_FreqAbility *freqAbi = (PWR_CPU_FreqAbility *)malloc(len);
    if (!freqAbi) {
        return;
    }
    bzero(freqAbi, len);
    ret = PWR_CPU_GetFreqAbility(freqAbi, len);
    PrintResult("PWR_CPU_GetFreqAbility", ret);
    printf("    freqDrv: %s, govNum: %d, freqDomainNum: %d \n", freqAbi->curDriver,
        freqAbi->avGovNum, freqAbi->freqDomainNum);
    for (int i = 0; i < freqAbi->avGovNum; i++) {
        printf("    gov[%d]: %s\n", i, freqAbi->avGovList[i]);
    }
    for (int i = 0; i < freqAbi->freqDomainNum; i++) {
        char *freqDomainInfo = freqAbi->freqDomain + i * freqAbi->freqDomainStep;
        int policyId = *((int *)freqDomainInfo);
        char *affectCpuList = freqDomainInfo + sizeof(int);
        printf("    FreqDomain[%d] affectCpuList: %s\n", policyId, affectCpuList);
    }
    free(freqAbi);
}

static void TEST_PWR_CPU_SetIdleGovernor(void)
{
    size_t size = sizeof(PWR_CPU_IdleInfo) + PWR_MAX_CPU_CSTATE_NUM * sizeof(PWR_CPU_Cstate);
    PWR_CPU_IdleInfo *info = (PWR_CPU_IdleInfo *)malloc(size);
    bzero(info, size);
    info->cstateNum = PWR_MAX_CPU_CSTATE_NUM;
    int ret = PWR_CPU_GetIdleInfo(info);
    PrintResult("PWR_CPU_GetIdleInfo", ret);
    char governor[PWR_MAX_ELEMENT_NAME_LEN] = {0};
    strncpy(governor, info->currGov, PWR_MAX_ELEMENT_NAME_LEN);
    printf("\t curr drv: %s, curr gov: %s\n", info->currDrv, info->currGov);
    for (int i = 0; i < PWR_MAX_CPU_CSTATE_NUM; i++) {
        if (strlen(info->avGovs[i]) != 0) {
            printf("\t gov%d: %s\n", i, info->avGovs[i]);
        } else{
            break;
        }
    }
    char gov[PWR_MAX_ELEMENT_NAME_LEN] = {0};
    char curgov[PWR_MAX_ELEMENT_NAME_LEN] = {0};
    strncpy(gov, info->avGovs[2], PWR_MAX_ELEMENT_NAME_LEN);
    ret = PWR_CPU_SetIdleGovernor(gov);
    PrintResult("PWR_CPU_SetIdleGovernor", ret);
    PWR_CPU_GetIdleGovernor(curgov, PWR_MAX_ELEMENT_NAME_LEN);
    printf("current gov is %s\n", curgov);
    if(strcmp(gov, curgov) == 0){
        printf("PWR_CPU_SetIdleGovernor SUCCESS");
    }
    PWR_CPU_SetIdleGovernor(governor);
}

static void TEST_PWR_CPU_GetFreqGovernor(void)
{
    int ret = -1;
    char governor[PWR_MAX_ELEMENT_NAME_LEN] = {0};
    ret = PWR_CPU_GetFreqGovernor(governor, PWR_MAX_ELEMENT_NAME_LEN);
    PrintResult("PWR_CPU_GetFreqGovernor", ret);
    printf("    governor: %s\n", governor);
}

static void TEST_PWR_CPU_SetFreqGovernor(void)
{
    int ret = -1;
    char governor[PWR_MAX_ELEMENT_NAME_LEN] = {0};
    char gov[] = "ondemand";
    PWR_CPU_SetFreqGovernor(gov);
    ret = PWR_CPU_GetFreqGovernor(governor, PWR_MAX_ELEMENT_NAME_LEN);
    PrintResult("PWR_CPU_GetFreqGovernor", ret);
    printf("    governor: %s\n", governor);
    if (strcmp(governor, gov) == 0) {
        printf("PWR_CPU_SetFreqGovernor SUCCESS\n");
    }
}

static void TEST_PWR_CPU_GetFreqRange(void)
{
    int ret = -1;
    PWR_CPU_FreqRange freqRange = {0};
    ret = PWR_CPU_GetFreqRange(&freqRange);
    PrintResult("PWR_CPU_GetFreqRange", ret);
    printf("    min freq: %d, max freq: %d\n", freqRange.minFreq, freqRange.maxFreq);
}

static void TEST_PWR_CPU_SetFreqRange_1(void)
{
    int ret = -1;
    PWR_CPU_FreqRange freqRange_old = {0};
    PWR_CPU_GetFreqRange(&freqRange_old);
    printf("    min freq: %d, max freq: %d\n", freqRange_old.minFreq, freqRange_old.maxFreq);
    PWR_CPU_FreqRange freqRange = {0};
    freqRange.minFreq = freqRange_old.minFreq;
    freqRange.maxFreq = freqRange_old.maxFreq;
    ret = PWR_CPU_SetFreqRange(&freqRange);
    PrintResult("PWR_CPU_SetFreqRange", ret);
    bzero(&freqRange, sizeof(PWR_CPU_FreqRange));
    PWR_CPU_GetFreqRange(&freqRange);
    printf("    current min freq: %d, max freq: %d\n", freqRange.minFreq, freqRange.maxFreq);
}

static void TEST_PWR_CPU_SetFreqRange_2(void)
{
    int ret = -1;
    PWR_CPU_FreqRange freqRange_old = {0};
    PWR_CPU_GetFreqRange(&freqRange_old);
    printf("    min freq: %d, max freq: %d\n", freqRange_old.minFreq, freqRange_old.maxFreq);
    PWR_CPU_FreqRange freqRange = {0};
    freqRange.minFreq = freqRange_old.minFreq - 1;
    freqRange.maxFreq = freqRange_old.maxFreq + 1;
    ret = PWR_CPU_SetFreqRange(&freqRange);
    PrintResult("PWR_CPU_SetFreqRange", ret);
    bzero(&freqRange, sizeof(PWR_CPU_FreqRange));
    PWR_CPU_GetFreqRange(&freqRange);
    printf("    current min freq: %d, max freq: %d\n", freqRange.minFreq, freqRange.maxFreq);
}

static void TEST_PWR_CPU_SetFreqRange_3(void)
{
    int ret = -1;
    PWR_CPU_FreqRange freqRange_old = {0};
    PWR_CPU_GetFreqRange(&freqRange_old);
    printf("    min freq: %d, max freq: %d\n", freqRange_old.minFreq, freqRange_old.maxFreq);
    PWR_CPU_FreqRange freqRange = {0};
    freqRange.minFreq = freqRange_old.minFreq + 1;
    freqRange.maxFreq = freqRange_old.maxFreq - 1;
    ret = PWR_CPU_SetFreqRange(&freqRange);
    PrintResult("PWR_CPU_SetFreqRange", ret);
    bzero(&freqRange, sizeof(PWR_CPU_FreqRange));
    PWR_CPU_GetFreqRange(&freqRange);
    printf("    current min freq: %d, max freq: %d\n", freqRange.minFreq, freqRange.maxFreq);
    PWR_CPU_SetFreqRange(&freqRange_old);
}

static void TEST_PWR_CPU_SetFreqRange_4(void)
{
    int ret = -1;
    PWR_CPU_FreqRange freqRange_old = {0};
    PWR_CPU_GetFreqRange(&freqRange_old);
    printf("    min freq: %d, max freq: %d\n", freqRange_old.minFreq, freqRange_old.maxFreq);
    PWR_CPU_FreqRange freqRange = {0};
    freqRange.minFreq = freqRange_old.minFreq + 2;
    freqRange.maxFreq = freqRange_old.maxFreq + 3;
    ret = PWR_CPU_SetFreqRange(&freqRange);
    PrintResult("PWR_CPU_SetFreqRange", ret);
    bzero(&freqRange, sizeof(PWR_CPU_FreqRange));
    PWR_CPU_GetFreqRange(&freqRange);
    printf("    current min freq: %d, max freq: %d\n", freqRange.minFreq, freqRange.maxFreq);
    PWR_CPU_SetFreqRange(&freqRange_old);
}

static void TEST_PWR_CPU_SetFreqRange(void)
{
    int ret = -1;
    PWR_CPU_FreqRange freqRange = {0};
    freqRange.minFreq = TEST_FREQ_RANGE_MIN;
    freqRange.maxFreq = TEST_FREQ_RANGE_MAX;
    ret = PWR_CPU_SetFreqRange(&freqRange);
    PrintResult("PWR_CPU_SetFreqRange", ret);
    bzero(&freqRange, sizeof(PWR_CPU_FreqRange));
    PWR_CPU_GetFreqRange(&freqRange);
    printf("    current min freq: %d, max freq: %d\n", freqRange.minFreq, freqRange.maxFreq);

    freqRange.minFreq = 0;
    freqRange.maxFreq = 2300;
    ret = PWR_CPU_SetFreqRange(&freqRange);
    PrintResult("PWR_CPU_SetFreqRange", ret);
    bzero(&freqRange, sizeof(PWR_CPU_FreqRange));
    PWR_CPU_GetFreqRange(&freqRange);
    printf("    current min freq: %d, max freq: %d\n", freqRange.minFreq, freqRange.maxFreq);

    freqRange.minFreq = 300;
    freqRange.maxFreq = 0;
    ret = PWR_CPU_SetFreqRange(&freqRange);
    PrintResult("PWR_CPU_SetFreqRange", ret);
    bzero(&freqRange, sizeof(PWR_CPU_FreqRange));
    PWR_CPU_GetFreqRange(&freqRange);
    printf("    current min freq: %d, max freq: %d\n", freqRange.minFreq, freqRange.maxFreq);
}

static void TEST_PWR_CPU_GetFreq_1(void)
{
    int ret = -1;
    int num = 0;
    int spec = 0;
    int i = 0;

    /**
     * Test 1: spec = 0, get all policy freq.
     * Set the num to the number of CPU cores
     * (it is possible that one kernel corresponds to one policy)
     */
    num = TEST_CORE_NUM;
    spec = 0;
    PWR_CPU_CurFreq cpuCurFreq1[num];
    bzero(cpuCurFreq1, num * sizeof(PWR_CPU_CurFreq));
    ret = PWR_CPU_GetFreq(cpuCurFreq1, &num, spec);
    PrintResult("PWR_CPU_GetFreq", ret);
    for (i = 0; i < num; i++) {
        printf("    policy[%d]: %lf\n", cpuCurFreq1[i].policyId, cpuCurFreq1[i].curFreq);
    }
}

static void TEST_PWR_CPU_GetFreq_2(void)
{
    /**
     * Test 2: spec = 0 num = 2. get the previous 2 policies' freq
     */
    int ret = -1;
    // 2: previous 2 policies
    int num = 2;
    int spec = 0;
    int i = 0;
    PWR_CPU_CurFreq cpuCurFreq2[num];
    bzero(cpuCurFreq2, num * sizeof(PWR_CPU_CurFreq));
    ret = PWR_CPU_GetFreq(cpuCurFreq2, &num, spec);
    PrintResult("PWR_CPU_GetFreq", ret);
    for (i = 0; i < num; i++) {
        printf("    policy[%d]: %lf\n", cpuCurFreq2[i].policyId, cpuCurFreq2[i].curFreq);
    }
}

static void TEST_PWR_CPU_GetFreq_3(void)
{
    /**
     * Test 3: spec = 1, get the two target policy freq
     */
    int ret = -1;
    // 2: previous 2 policies
    int num = 2;
    int spec = 1;
    int i = 0;
    PWR_CPU_CurFreq cpuCurFreq3[num];
    bzero(cpuCurFreq3, num * sizeof(PWR_CPU_CurFreq));
    cpuCurFreq3[0].policyId = 0;
    // 32 : the Id of the second policy.
    cpuCurFreq3[1].policyId = 72;
    ret = PWR_CPU_GetFreq(cpuCurFreq3, &num, spec);
    PrintResult("PWR_CPU_GetFreq", ret);
    for (i = 0; i < num; i++) {
        printf("    policy[%d]: %lf\n", cpuCurFreq3[i].policyId, cpuCurFreq3[i].curFreq);
    }
}

static void TEST_PWR_CPU_SetFreq(char governor[PWR_MAX_ELEMENT_NAME_LEN], int freq)
{
    int ret = -1;
    int num = 1;
    PWR_CPU_CurFreq cpuCurFreq[num];
    bzero(cpuCurFreq, num * sizeof(PWR_CPU_CurFreq));
    cpuCurFreq[0].policyId = 0;
    //cpuCurFreq[0].curFreq = TEST_FREQ; 1200-2500
    char gover[PWR_MAX_ELEMENT_NAME_LEN] = {0};
    strcpy(gover, governor);
    //char gov[] = "ondemand";
    PWR_CPU_SetFreqGovernor(gover);

    cpuCurFreq[0].curFreq = freq;
    ret = PWR_CPU_SetFreq(cpuCurFreq, num);
    PrintResult("PWR_CPU_SetFreq", ret);

}

static void TEST_PWR_CPU_SetFreq_1(void)
{
    int ret = -1;
    char gov[] = "userspace";
    PWR_CPU_FreqRange freqRange = {0};
    char governor[PWR_MAX_ELEMENT_NAME_LEN] = {0};
    PWR_CPU_GetFreqGovernor(governor, PWR_MAX_ELEMENT_NAME_LEN);
    PWR_CPU_GetFreqRange(&freqRange);
    int freq = freqRange.minFreq - 1;
    printf("    min freq: %d, max freq: %d, freq: %d\n", freqRange.minFreq, freqRange.maxFreq, freq);
    TEST_PWR_CPU_SetFreq(gov, freq);
    PWR_CPU_SetFreqGovernor(governor);
}

static void TEST_PWR_CPU_SetFreq_2(void)
{
    int ret = -1;
    char gov[] = "userspace";
    PWR_CPU_FreqRange freqRange = {0};
    char governor[PWR_MAX_ELEMENT_NAME_LEN] = {0};
    PWR_CPU_GetFreqGovernor(governor, PWR_MAX_ELEMENT_NAME_LEN);
    PWR_CPU_GetFreqRange(&freqRange);
    int freq = freqRange.minFreq + 1;
    printf("    min freq: %d, max freq: %d, freq: %d\n", freqRange.minFreq, freqRange.maxFreq, freq);
    TEST_PWR_CPU_SetFreq(gov, freq);
    PWR_CPU_SetFreqGovernor(governor);
}

static void TEST_PWR_CPU_SetFreq_3(void)
{
    int ret = -1;
    char gov[] = "ondemand";
    PWR_CPU_FreqRange freqRange = {0};
    PWR_CPU_GetFreqRange(&freqRange);
    int freq = freqRange.minFreq - 1;
    printf("    min freq: %d, max freq: %d, freq: %d\n", freqRange.minFreq, freqRange.maxFreq, freq);
    TEST_PWR_CPU_SetFreq(gov, freq);
}

static void TEST_PWR_CPU_SetFreq_4(void)
{
    int ret = -1;
    char gov[] = "ondemand";
    PWR_CPU_FreqRange freqRange = {0};
    PWR_CPU_GetFreqRange(&freqRange);
    int freq = freqRange.minFreq + 1;
    printf("    min freq: %d, max freq: %d, freq: %d\n", freqRange.minFreq, freqRange.maxFreq, freq);
    TEST_PWR_CPU_SetFreq(gov, freq);
} 

static void TEST_PWR_CPU_GetFreqGovAttrs(void)
{
    int ret = 0;
    char gov[] = "ondemand";
    PWR_CPU_SetFreqGovernor(gov);
    PWR_CPU_FreqGovAttrs attrs = {0};
    ret = PWR_CPU_GetFreqGovAttrs(&attrs);
    PrintResult("PWR_CPU_GetFreqGovAttrs", ret);
    for (int i = 0; i < attrs.attrNum; i++) {
        printf("attr%d: %s: %s\n", i, attrs.attrs[i].key, attrs.attrs[i].value);
    }
}

static void TEST_PWR_CPU_GetFreqGovAttr_Exists_Attr(void)
{
    int ret = 0;
    //char governor[PWR_MAX_ELEMENT_NAME_LEN] = {0};
    //PWR_CPU_GetFreqGovernor(governor, PWR_MAX_ELEMENT_NAME_LEN);
    char gov[] = "ondemand";
    PWR_CPU_SetFreqGovernor(gov);
    PWR_CPU_FreqGovAttrs attrs = {0};
    PWR_CPU_GetFreqGovAttrs(&attrs);
    char sr[PWR_MAX_ELEMENT_NAME_LEN];
    strcpy(sr, attrs.attrs[0].key);
    PWR_CPU_FreqGovAttr attr = {0};
    strncpy(attr.attr.key, sr, strlen(sr));
    ret = PWR_CPU_GetFreqGovAttr(&attr);
    PrintResult("PWR_CPU_GetFreqGovAttr", ret);
    printf("attr: %s: %s\n", sr, attr.attr.value);
}

static void TEST_PWR_CPU_GetFreqGovAttr_NoExists_Attr(void)
{
    int ret = 0;
    char gov[] = "ondemand";
    PWR_CPU_SetFreqGovernor(gov);
    PWR_CPU_FreqGovAttrs attrs = {0};
    PWR_CPU_GetFreqGovAttrs(&attrs);
    char sr[PWR_MAX_ELEMENT_NAME_LEN] = "test";
    PWR_CPU_FreqGovAttr attr = {0};
    strncpy(attr.attr.key, sr, strlen(sr));
    ret = PWR_CPU_GetFreqGovAttr(&attr);
    PrintResult("PWR_CPU_GetFreqGovAttr", ret);
    printf("attr: %s: %s\n", sr, attr.attr.value);
}

static void TEST_PWR_CPU_GetFreqGovAttr_NoExists_Attr_1(void)
{
    int ret = 0;
    char gov[] = "ondemand";
    PWR_CPU_SetFreqGovernor(gov);
    PWR_CPU_FreqGovAttrs attrs = {0};
    PWR_CPU_GetFreqGovAttrs(&attrs);
    char sr1[PWR_MAX_ELEMENT_NAME_LEN];
    strcpy(sr1, attrs.attrs[0].key);
    char sr[PWR_MAX_ELEMENT_NAME_LEN] = "test";
    PWR_CPU_FreqGovAttr attr = {0};
    strncpy(attr.attr.key, sr1, strlen(sr1));
    strncpy(attr.attr.key, sr, strlen(sr));
    ret = PWR_CPU_GetFreqGovAttr(&attr);
    PrintResult("PWR_CPU_GetFreqGovAttr", ret);
    printf("attr: %s: %s\n", sr, attr.attr.value);
}

static void TEST_PWR_CPU_SetFreqGovAttr_Success(void)
{
    int ret = 0;
    char gov[] = "ondemand";
    PWR_CPU_SetFreqGovernor(gov);
    PWR_CPU_FreqGovAttrs attrs = {0};
    PWR_CPU_GetFreqGovAttrs(&attrs);
    for (int i = 0; i < attrs.attrNum; i++) {
        printf("attr%d: %s: %s\n", i, attrs.attrs[i].key, attrs.attrs[i].value);
    }
    char sr[PWR_MAX_ELEMENT_NAME_LEN];
    char srValue_old[PWR_MAX_VALUE_LEN];
    char srValue[] = "98";
    printf("attr: %s: %s\n", attrs.attrs[0].key, attrs.attrs[0].value);
    strcpy(sr, attrs.attrs[0].key);
    strcpy(srValue_old, attrs.attrs[0].value);
    PWR_CPU_FreqGovAttr attr = {0};
    strncpy(attr.attr.key, sr, strlen(sr));
    strncpy(attr.attr.value, srValue, PWR_MAX_VALUE_LEN);
    ret = PWR_CPU_SetFreqGovAttr(&attr);
    PrintResult("PWR_CPU_SetFreqGovAttr", ret);
    PWR_CPU_GetFreqGovAttr(&attr);
    printf("attr: %s: %s\n", sr, attr.attr.value);
    strncpy(attr.attr.value, srValue_old, PWR_MAX_VALUE_LEN);
    PWR_CPU_SetFreqGovAttr(&attr);
    PWR_CPU_GetFreqGovAttr(&attr);
    printf("attr: %s: %s\n", sr, attr.attr.value);
}

static void TEST_PWR_CPU_SetFreqGovAttr_Failure(void)
{
    int ret = 0;
    char gov[] = "ondemand";
    PWR_CPU_SetFreqGovernor(gov);
    PWR_CPU_FreqGovAttrs attrs = {0};
    PWR_CPU_GetFreqGovAttrs(&attrs);
    char sr[PWR_MAX_ELEMENT_NAME_LEN];
    char srValue_old[PWR_MAX_VALUE_LEN];
    char srValue[] = "test123";
    strcpy(sr, attrs.attrs[0].key);
    strcpy(srValue_old, attrs.attrs[0].value);
    PWR_CPU_FreqGovAttr attr = {0};
    strncpy(attr.attr.key, sr, strlen(sr));
    strncpy(attr.attr.value, srValue, PWR_MAX_VALUE_LEN);
    ret = PWR_CPU_SetFreqGovAttr(&attr);
    PrintResult("PWR_CPU_SetFreqGovAttr", ret);
    PWR_CPU_GetFreqGovAttr(&attr);
    printf("attr: %s: %s\n", sr, attr.attr.value);
}

static void TEST_PWR_CPU_SetFreqGovAttr_Failure_1(void)
{
    int ret = 0;
    char gov[] = "ondemand";
    PWR_CPU_SetFreqGovernor(gov);
    PWR_CPU_FreqGovAttrs attrs = {0};
    PWR_CPU_GetFreqGovAttrs(&attrs);
    char sr[PWR_MAX_ELEMENT_NAME_LEN];
    char srValue_old[PWR_MAX_VALUE_LEN];
    char srValue[] = "test123";
    strcpy(sr, attrs.attrs[0].key);
    strcpy(srValue_old, attrs.attrs[0].value);
    PWR_CPU_FreqGovAttr attr = {0};
    strncpy(attr.attr.key, sr, strlen(sr));
    strncpy(attr.attr.value, srValue_old, PWR_MAX_VALUE_LEN);
    strncpy(attr.attr.value, srValue, PWR_MAX_VALUE_LEN);
    ret = PWR_CPU_SetFreqGovAttr(&attr);
    PrintResult("PWR_CPU_SetFreqGovAttr", ret);
    PWR_CPU_GetFreqGovAttr(&attr);
    printf("attr: %s: %s\n", sr, attr.attr.value);
}


static void TEST_PWR_CPU_GetIdleInfo(void)
{
    size_t size = sizeof(PWR_CPU_IdleInfo) + PWR_MAX_CPU_CSTATE_NUM * sizeof(PWR_CPU_Cstate);
    PWR_CPU_IdleInfo *info = (PWR_CPU_IdleInfo *)malloc(size);
    if (!info) {
        return;
    }
    bzero(info, size);
    info->cstateNum = PWR_MAX_CPU_CSTATE_NUM;
    int ret = PWR_CPU_GetIdleInfo(info);
    PrintResult("PWR_CPU_GetIdleInfo", ret);
    printf("\t curr drv: %s, curr gov: %s\n", info->currDrv, info->currGov);
    for (int i = 0; i < PWR_MAX_CPU_CSTATE_NUM; i++) {
        if (strlen(info->avGovs[i]) != 0) {
            printf("\t gov%d: %s\n", i, info->avGovs[i]);
        } else{
            break;
        }
    }
    for (int i = 0; i < info->cstateNum; i++) {
        printf("\t state%d: name: %s, disable:%d, latency:%d\n", info->cstates[i].id,
            info->cstates[i].name, info->cstates[i].disable, info->cstates[i].latency);
    }
}

static void TEST_PWR_CPU_GetIdleGovernor(void)
{
    char gov[PWR_MAX_ELEMENT_NAME_LEN] = {0};
    int ret = PWR_CPU_GetIdleGovernor(gov, PWR_MAX_ELEMENT_NAME_LEN);
    PrintResult("PWR_CPU_GetIdleGovernor", ret);
    printf("\t current idle gov: %s\n", gov);
}


static void TEST_PWR_CPU_DmaGetLatency(void)
{
    int ret = 0;
    int la = -1;
    ret = PWR_CPU_DmaGetLatency(&la);
    PrintResult("PWR_CPU_DmaGetLatency", ret);
    printf("latency: %d\n", la);
}

static void TEST_PWR_CPU_DmaSetLatency_1(void)
{
    int ret = 0;
    int la_old = -1;
    int la = -1;
    ret = PWR_CPU_DmaGetLatency(&la_old);
    ret = PWR_CPU_DmaSetLatency(0);
    PrintResult("PWR_CPU_DmaSetLatency", ret);
    PWR_CPU_DmaGetLatency(&la);
    printf("latency: %d\n", la);
    PWR_CPU_DmaSetLatency(la_old);
}

static void TEST_PWR_CPU_DmaSetLatency_2(void)
{
    int ret = 0;
    int la_old = -1;
    int la = -1;
    ret = PWR_CPU_DmaGetLatency(&la_old);
    ret = PWR_CPU_DmaSetLatency(TEST_CPU_DMA_LATENCY);
    PrintResult("PWR_CPU_DmaSetLatency", ret);
    PWR_CPU_DmaGetLatency(&la);
    printf("latency: %d\n", la);
    PWR_CPU_DmaSetLatency(la_old);
}

static void TEST_PWR_CPU_DmaSetLatency_3(void)
{
    int ret = 0;
    int la_old = -1;
    int la = -1;
    ret = PWR_CPU_DmaGetLatency(&la_old);
    ret = PWR_CPU_DmaSetLatency(-1);
    PrintResult("PWR_CPU_DmaSetLatency", ret);
    PWR_CPU_DmaGetLatency(&la);
    printf("latency: %d\n", la);
    PWR_CPU_DmaSetLatency(la_old);
}

static void TEST_PWR_CPU_DmaSetLatency_4(void)
{
    int ret = 0;
    int la_old = -1;
    int la = -1;
    ret = PWR_CPU_DmaGetLatency(&la_old);
    ret = PWR_CPU_DmaSetLatency(2000000001);
    PrintResult("PWR_CPU_DmaSetLatency", ret);
    PWR_CPU_DmaGetLatency(&la);
    printf("latency: %d\n", la);
    PWR_CPU_DmaSetLatency(la_old);
}

static void TEST_PWR_CPU_DmaSetLatency_5(void)
{
    int ret = 0;
    int la_old = -1;
    int la = -1;
    ret = PWR_CPU_DmaGetLatency(&la_old);
    ret = PWR_CPU_DmaSetLatency(-0.99);
    PrintResult("PWR_CPU_DmaSetLatency", ret);
    PWR_CPU_DmaGetLatency(&la);
    printf("latency: %d\n", la);
    PWR_CPU_DmaSetLatency(la_old);
}

static void TEST_PWR_CPU_DmaSetLatency_6(void)
{
    int ret = 0;
    int la_old = -1;
    int la = -1;
    ret = PWR_CPU_DmaGetLatency(&la_old);
    ret = PWR_CPU_DmaSetLatency(1.9);
    PrintResult("PWR_CPU_DmaSetLatency", ret);
    PWR_CPU_DmaGetLatency(&la);
    printf("latency: %d\n", la);
    PWR_CPU_DmaSetLatency(la_old);
}

static void TEST_PWR_SetEventCallback_1(void)
{
    int ret = -1;
    ret = PWR_SetEventCallback(EventCallback);
    PrintResult("PWR_SetEventCallback", ret);
    TEST_PWR_CPU_GetInfo();
    sleep(3);
}

static void TEST_PWR_SetEventCallback_2(void)
{
    int ret = -1;
    ret = PWR_SetEventCallback(EventCallback);
    PrintResult("PWR_SetEventCallback", ret);
    PWR_RequestControlAuth();
    sleep(30);
    PWR_ReleaseControlAuth();
}

static void TEST_PWR_CPU_GetUsage(void)
{
    int ret = -1;
    size_t buffSize = sizeof(PWR_CPU_Usage) + TEST_CORE_NUM * sizeof(PWR_CPU_CoreUsage);
    PWR_CPU_Usage *u = (PWR_CPU_Usage *)malloc(buffSize);
    if (!u) {
        return;
    }
    bzero(u, buffSize);
    ret = PWR_CPU_GetUsage(u, buffSize);
    PrintResult("PWR_CPU_GetUsage", ret);
    printf("    CPU avgUsage: %f, coreNum: %d \n", u->avgUsage, u->coreNum);
    for (int i = 0; i < u->coreNum; i++) {
        printf("    core[%d] usage: %f\n", u->coreUsage[i].coreNo, u->coreUsage[i].usage);
    }
    free(u);
}

static void TEST_PWR_CPU_GetPerfData(void)
{
    int ret = -1;
    PWR_CPU_PerfData perfData = { 0 };
    ret = PWR_CPU_GetPerfData(&perfData);
    PrintResult("PWR_CPU_GetPerfData", ret);
    printf("    IPC: %.8f, LLC misses: %.8f \n", perfData.ipc, perfData.llcMiss);
}
/*************************** CPU END *************************/

/************************** PROC ************************/
static void TEST_PWR_PROC_QueryProcs(char keywords[])
{
    pid_t procs[TEST_MAX_PROC_NUM] = {0};
    uint32_t num = 100;
    printf("keywords:%s\n", keywords);
    int ret = PWR_PROC_QueryProcs(keywords, procs, &num);
    printf("PWR_PROC_QueryProcs. ret: %d num:%d\n", ret, num);
    for (int i = 0; i < num; i++) {
        printf("\tprocs[%d]: %d\n", i, procs[i]);
    }
}

static void TEST_PWR_PROC_SetAndGetWattState(void)
{
    int state = INVALIDE_STATE;
    int ret = PWR_SUCCESS;
    ret = PWR_PROC_GetWattState(&state);
    printf("PWR_PROC_GetWattState. ret: %d state:%d\n", ret, state);
}

static void TEST_PWR_PROC_SetAndGetWattState_1(int PWRState)
{
    int state = INVALIDE_STATE;
    int ret = PWR_SUCCESS;
    ret = PWR_PROC_SetWattState(PWRState);
    ret = PWR_PROC_GetWattState(&state);
    printf("PWR_PROC_GetWattState. ret: %d state:%d\n", ret, state);
}

static void TEST_PWR_PROC_RebuildAffinityDomain(void)
{
    int cpuId = 0;
    int ret = PWR_PROC_SetWattFirstDomain(cpuId);
    printf("PWR_PROC_SetWattFirstDomain: ret:%d\n", ret);

    cpuId = 1234;
    ret = PWR_PROC_SetWattFirstDomain(cpuId);
    printf("PWR_PROC_SetWattFirstDomain: ret:%d\n", ret);
}

static void TEST_PWR_PROC_RebuildAffinityDomain_1(void)
{
    system("echo 0 > /sys/devices/system/cpu/cpu1/online");
    int ret = PWR_PROC_SetWattFirstDomain(1);
    printf("PWR_PROC_SetWattFirstDomain: ret:%d\n", ret);
    system("echo 1 > /sys/devices/system/cpu/cpu1/online");
}

static void TEST_PWR_PROC_SetAndGetWattAttrs(int TEST_WATT_TH, int TEST_WATT_IT, int TEST_WATT_DM)
{
    int ret = PWR_SUCCESS;
    PWR_PROC_WattAttrs was = {0};
    ret = PWR_PROC_GetWattAttrs(&was);
    printf("PWR_PROC_GetWattAttrs: ret:%d th:%d, interval:%d dmask:%d\n", ret,
        was.scaleThreshold, was.scaleInterval, was.domainMask);
    was.scaleThreshold = TEST_WATT_TH;
    was.scaleInterval = TEST_WATT_IT;
    was.domainMask = TEST_WATT_DM;
    ret = PWR_PROC_SetWattAttrs(&was);
    printf("PWR_PROC_SetWattAttrs. ret: %d\n", ret);
    bzero(&was, sizeof(was));
    (void)PWR_PROC_GetWattAttrs(&was);
    printf("After PWR_PROC_SetWattAttrs: ret:%d th:%d, interval:%d dmask:%d\n", ret,
        was.scaleThreshold, was.scaleInterval, was.domainMask);

}

static void TEST_PWR_PROC_AddAndDelWattProcs(int TEST_PID)
{
    pid_t procs[TEST_PID_NUM] = {TEST_PID};
    int num = TEST_PID_NUM;
    int ret = -1;
    ret = PWR_PROC_GetWattProcs(procs, &num);
    printf("PWR_PROC_GetWattProcs: ret:%d num:%d\n", ret, num);
    for (int i = 0; i < num; i++) {
        printf("\tPWR_PROC_GetWattProcs. procs%d: %d.\n", i, procs[i]);
    }

    num = 1;
    ret = PWR_PROC_AddWattProcs(procs, num);
    printf("PWR_PROC_AddWattProcs: ret:%d\n", ret);

    bzero(procs, sizeof(procs));
    ret = PWR_PROC_GetWattProcs(procs, &num);
    printf("PWR_PROC_GetWattProcs: ret:%d num:%d\n", ret, num);
    for (int i = 0; i < num; i++) {
        printf("\tPWR_PROC_GetWattProcs. after add. procs%d: %d.\n", i, procs[i]);
    }

    ret = PWR_PROC_DelWattProcs(procs, num);
    printf("PWR_PROC_DelWattProcs: ret:%d\n", ret);
    bzero(procs, sizeof(procs));
    (void)PWR_PROC_GetWattProcs(procs, &num);
    printf("PWR_PROC_GetWattProcs: ret:%d num:%d\n", ret, num);
    for (int i = 0; i < num; i++) {
        printf("\tPWR_PROC_DelWattProcs. after del. procs%d: %d.\n", i, procs[i]);
    }
}

static void TEST_PWR_PROC_AddAndDelWattProcs_1(int TEST_PID)
{
    pid_t procs[TEST_PID_NUM] = {TEST_PID};
    int num = TEST_PID_NUM;
    int ret = -1;
    ret = PWR_PROC_GetWattProcs(procs, &num);
    printf("PWR_PROC_GetWattProcs: ret:%d num:%d\n", ret, num);
    for (int i = 0; i < num; i++) {
        printf("\tPWR_PROC_GetWattProcs. procs%d: %d.\n", i, procs[i]);
    }

    num = 1;
    ret = PWR_PROC_AddWattProcs(procs, num);
    printf("PWR_PROC_AddWattProcs: ret:%d\n", ret);

    bzero(procs, sizeof(procs));
    ret = PWR_PROC_GetWattProcs(procs, &num);
    printf("PWR_PROC_GetWattProcs: ret:%d num:%d\n", ret, num);
    for (int i = 0; i < num; i++) {
        printf("\tPWR_PROC_GetWattProcs. after add. procs%d: %d.\n", i, procs[i]);
    }
}

static void TEST_PWR_PROC_SetAndGetSmartGridState(void)
{
    int state = INVALIDE_STATE;
    int ret = PWR_SUCCESS;
    ret = PWR_PROC_GetSmartGridState(&state);
    printf("PWR_PROC_GetSmartGridState. ret: %d state:%d\n", ret, state);
    PWR_PROC_SetWattState(PWR_ENABLE);
    ret = PWR_PROC_SetSmartGridState(PWR_ENABLE);
    printf("PWR_PROC_SetSmartGridState. ret: %d\n", ret);
    ret = PWR_PROC_GetSmartGridState(&state);
    printf("PWR_PROC_GetSmartGridState. ret: %d state:%d\n", ret, state);
    ret = PWR_PROC_SetSmartGridState(PWR_DISABLE);
    printf("PWR_PROC_SetSmartGridState. ret: %d\n", ret);
    ret = PWR_PROC_GetSmartGridState(&state);
    printf("PWR_PROC_GetSmartGridState. ret: %d state:%d\n", ret, state);
    ret = PWR_PROC_SetSmartGridState(-1);
    printf("PWR_PROC_SetSmartGridState. ret: %d\n", ret);
    PWR_PROC_SetWattState(PWR_DISABLE);
}

static void TEST_PWR_PROC_SetAndGetSmartGridGov(void)
{
    PWR_PROC_SmartGridGov sgGov = {0};
    int ret = PWR_PROC_GetSmartGridGov(&sgGov);
    printf("PWR_PROC_GetSmartGridGov: ret:%d sgAgentState:%d, sgLevel0Gov:%s sgLevel1Gov:%s\n",
        ret, sgGov.sgAgentState, sgGov.sgLevel0Gov, sgGov.sgLevel1Gov);
}

static void TEST_PWR_PROC_SetAndGetSmartGridGov_1(int sgAgentState, char level0Gov[], char level1Gov[])
{
    PWR_PROC_SmartGridGov sgGov = {0};
    sgGov.sgAgentState = sgAgentState;
    printf("PWR_MAX_ELEMENT_NAME_LEN:%d\n", PWR_MAX_ELEMENT_NAME_LEN);
    strncpy(sgGov.sgLevel0Gov, level0Gov, PWR_MAX_ELEMENT_NAME_LEN);
    strncpy(sgGov.sgLevel1Gov, level1Gov, PWR_MAX_ELEMENT_NAME_LEN);
    int ret = PWR_PROC_SetSmartGridGov(&sgGov);
    printf("PWR_PROC_SetSmartGridGov: ret:%d\n", ret);
    bzero(&sgGov, sizeof(PWR_PROC_SmartGridGov));
    PWR_PROC_GetSmartGridGov(&sgGov);
    printf("PWR_PROC_GetSmartGridGov: after set. ret:%d sgAgentState:%d, sgLevel0Gov:%s sgLevel1Gov:%s\n",
        ret, sgGov.sgAgentState, sgGov.sgLevel0Gov, sgGov.sgLevel1Gov);
}

static void TEST_PWR_PROC_SetServiceState(int sname, int sstate)
{
    size_t size = sizeof(PWR_PROC_ServiceState);
    PWR_PROC_ServiceState sState = {0};
    sState.name = sname;
    sState.state = sstate;
    int ret = PWR_PROC_SetServiceState(&sState);
    printf("PWR_PROC_SetServiceState ret:%d\n", ret);
}

static void TEST_PWR_PROC_GetServiceState(void)
{
    size_t size = sizeof(PWR_PROC_ServiceStatus);
    PWR_PROC_ServiceStatus sStatus = {0};
    sStatus.name = PWR_PROC_SERVICE_EAGLE;
    int ret = PWR_PROC_GetServiceState(&sStatus);
    printf("PWR_PROC_GetServiceState ret:%d status:%d\n", ret, sStatus.status);
}
/************************** PROC END ************************/
