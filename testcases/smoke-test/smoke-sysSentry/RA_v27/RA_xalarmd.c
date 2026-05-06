#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <xalarm/register_xalarm.h>

#define SLEEP_TIME 10
#define ID_LIST_LENGTH 1
#define TIME_UNIT_MILLISECONDS 1000

void process_alarm_info(struct alarm_msg *param)
{
    int alarmid;
    long long alarmtime;
    char *pucParas;

    alarmid = (param == NULL ? 0 : param->usAlarmId);
    alarmtime = (param == NULL ? 0 : ((long long)(param->AlarmTime.tv_sec) * TIME_UNIT_MILLISECONDS + 
        (long long)(param->AlarmTime.tv_usec) / TIME_UNIT_MILLISECONDS));
    pucParas = (param == NULL ? NULL : (char *)param->pucParas);

    printf("plugin notified with [alarmid:%d] [alarmtime:%lld ms] [msg:%s]\n" ,
    alarmid, alarmtime,pucParas);
    return;
}
int main(int argc, char **argv)
{
    int ret;
    struct alarm_register *register_info;
    struct alarm_subscription_info id_filter;
    struct alarm_msg *msg = malloc(sizeof(struct alarm_msg));
    id_filter.id_list[0] = ALARM_REBOOT_EVENT;
    id_filter.len = 1;
    ret = xalarm_register_event(&register_info, id_filter);
    if(ret < 0){
        printf("%d\n", ret);
        perror("Failed to register xalarm\n");
        return 1;

    }
    printf("Waiting for plugin msg ... \n");
    ret = xalarm_get_event(msg, register_info);
    if(ret < 0){
        perror("Failed to get msg\n");
        return 1;
    }

    printf("Processing msg from plugin ... \n");

    process_alarm_info(msg);
    sleep(5);
    xalarm_unregister_event(register_info);
    printf("Reporting msg to plugin ... \n");

    ret = xalarm_report_event(ALARM_REBOOT_ACK_EVENT, "ACK OK");


    if(ret < 0){
        perror("Failed to send msg\n");
        return 1;
    }
    return 0;
    }