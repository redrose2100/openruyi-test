#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <xalarm/register_xalarm.h>

#define SLEEP_TIME 10
#define ID_LIST_LENGTH 1
#define TIME_UNIT_MILLISECONDS 1000

int need_ack = 0;
unsigned long process_alarm_info(struct alarm_msg *param)
{
    int alarmid;
    long long alarmtime;
    char *pucParas;

    alarmid = (param == NULL ? 0 : param->usAlarmId);
    alarmtime = (param == NULL ? 0 : ((long long)(param->AlarmTime.tv_sec) * TIME_UNIT_MILLISECONDS + (long long)(param->AlarmTime.tv_usec) / TIME_UNIT_MILLISECONDS));
    pucParas = (param == NULL ? NULL : (char *)param->pucParas);

    unsigned long msgid;
    char buf[1024];
    sscanf(pucParas, "%lu_", &msgid);
    char *sync_pos = strstr(pucParas, "sync:");
    if(sync_pos)
    {
        sscanf(sync_pos, "sync:%d," , &need_ack);

    }
    printf("msgid : %lu\n" , msgid);
    printf("need_ack : %d\n" , need_ack);
    printf("plugin notified with [alarmid:%d] [alarmtime:%lld ms] [msg:%s]\n" ,
    alarmid, alarmtime,pucParas);
    return msgid;
}
int main(int argc, char **argv)
{
    int ret;
    struct alarm_register *register_info;
    struct alarm_subscription_info id_filter;
    struct alarm_msg *msg = malloc(sizeof(struct alarm_msg));
    id_filter.id_list[0] = ALARM_OOM_EVENT;
    id_filter.len = 1;
    ret = xalarm_register_event(&register_info, id_filter);
    if(ret < 0)
    {
        printf("%d\n", ret);
        perror("Failed to register xalarm\n");
        return 1;

    }
    while(1)
    {
        printf("===Waiting for plugin msg ... \n");
        ret = xalarm_get_event(msg, register_info);
        if(ret < 0)
        {
            perror("Failed to get msg\n");
            return 1;
        }
        printf("Processing msg from plugin ... \n");
        unsigned long msgid = process_alarm_info(msg);
        if (need_ack)
        {
            printf("Ack msg to plugin ...\n");
            char ack[256];
            int nr_freed = 0;
            sprintf(ack, "%lu_%d", msgid, nr_freed);
            ret = xalarm_report_event(ALARM_OOM_ACK_EVENT, ack);
            if(ret < 0)
            {
                perror("Failed to send msg\n");
                return 1;
            }
        }
        else
        {
            printf("no need ack .. \n");
        }
    }
    xalarm_unregister_event(register_info);
    return 0;
    }