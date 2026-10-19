#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <stdint.h>
#include <sys/mman.h>
#include <unistd.h>
#include <time.h>
#include <libobmm.h>
#include <errno.h>

int main(int argc, char *argv[])
{
    unsigned long mem_id, flag, mem_numa[OBMM_MAX_LOCAL_NUMA_NODES] = {0};
    unsigned int priv_len = 0;
    char *priv_info;
    clock_t start_time, end_time;
    double execution_time;

    if (argc < 4 || argc > 6) {
        printf("Invalid input: %s\nUsage:\n    <arg1> : memory size per numa (Byte, max length = 16, separated by "
               "','), example: '134217728,0,0' for 3 numa nodes\n    <arg2> : flag\n    <arg3> : export eid\n    "
               "<arg4> : priv_len (optional, default: 0)\n    <arg5> : priv info (required when arg3 is not null)\n",
            argv[0]);
        return 1;
    }

    // 以动态分配内存的方式创建内存描述符，并写入私有数据
    if (argc > 5) {
        priv_len = atoi(argv[4]);
        priv_info = argv[5];
    }
    struct obmm_mem_desc *pdesc = malloc(sizeof(struct obmm_mem_desc) + priv_len);
    if (pdesc == NULL) {
        printf("Memory allocation FAILED!");
        return 1;
    }
    pdesc->priv_len = priv_len;
    if (priv_len > 0) {
        strcpy(pdesc->priv, priv_info);
    }

    // 根据入参，以","为分隔符，指定每个 NUMA 节点需要借出的内存大小（单位：Byte）
    char *size_copy = strdup(argv[1]);
    int count = 0;
    char *token = strtok(size_copy, ",");
    char *endptr;

    while (token != NULL && count < OBMM_MAX_LOCAL_NUMA_NODES) {
        // 将分割后的字符串转换为整数
        mem_numa[count] = strtoul(token, &endptr, 10);
        count++;

        // 继续分割
        token = strtok(NULL, ",");
    }

    // 计算借出总内存大小
    unsigned long sum = 0;
    for (int i = 0; i < count; i++) {
        sum += mem_numa[i];
    }

    // OBMM_EXPORT_FLAG_ALLOW_MMAP     0x1
    // OBMM_EXPORT_FLAG_FAST           0x2
    flag = strtoul(argv[2], NULL, 16);

    long long int deid = strtoull(argv[3], &endptr, 10);
    memcpy(&(pdesc->deid), &deid, sizeof(deid));

    // 打印 obmm_export 入参信息
    printf("obmm_export input parameter:\n");
    printf(" -- size(Byte): ");
    for (int i = 0; i < OBMM_MAX_LOCAL_NUMA_NODES; i++) {
        printf("%lu,", mem_numa[i]);
    }
    printf(" (totally %dM)\n", sum / 1024 / 1024);
    printf(" -- flag: 0x%x\n", flag);
    printf(" -- export eid: %lld; ", deid);
    for (int i = 0; i < 16; i++) {
        printf("%02X ", pdesc->deid[i]);
    }
    printf("\n");
    printf(" -- priv_len: %d\n", pdesc->priv_len);

    // obmm_export
    start_time = clock();
    mem_id = obmm_export(mem_numa, flag, pdesc);
    end_time = clock();
    execution_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;
    printf("obmm_export execute time=%.6fs \n", execution_time);

    // 打印返回信息
    if (mem_id) {
        printf("obmm_export SUCCESS: mem_id=%lu\n", mem_id);
        printf("obmm_export meminfo:\n");
        printf(" -- token_id: %u\n", pdesc->tokenid);
        printf(" -- size: 0x%lx\n", pdesc->length);
        printf(" -- uba: 0x%lx\n", pdesc->addr);
        printf(" -- scna: 0x%lx\n", pdesc->scna);
        printf(" -- dcna: 0x%lx\n", pdesc->dcna);
    } else {
        printf("obmm_export FAILED! errno=%lu\n", errno);
        perror("obmm_export");
        printf("obmm_export FAILED! res=%lu\n", mem_id);
        return 1;
    }

    return 0;
}