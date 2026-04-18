#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <xalarm/register_xalarm.h>


#define ID_LIST_LENGTH 1
#define ID_INDEX_0 0
#define TIME_UNIT_MILLISECONDS 1000

void RefreshOutput(void)
{
    int ret = fflush(stdout);
    if (ret !=0){
        printf("Failed to fflush \n");

    }
}
void print_alarm_info(struct alarm_msg *param)
{
    int alarmid;
    long long alarmtime;
    char *pucParas;
    alarmid=(param == NULL ? 0 : param->usAlarmId);
    alarmtime = (param == NULL ? 0 : ((long long)(param->AlarmTime.tv_sec) * TIME_UNIT_MILLISECONDS + 
    (long long)(param->AlarmTime.tv_usec) / TIME_UNIT_MILLISECONDS));
    pucParas = (param == NULL ? NULL : (char *)param->pucParas);
    printf("plugin notified with [alarmid:%d] [alarmtime:%lld ms] [msg:%s]\n",
     alarmid, alarmtime, pucParas);
     return;
}

int main(int argc, char **argv)
{
    struct alarm_register* register_info;
    pthread_t thread_id;
    int ret;
    struct alarm_subscription_info id_filter;
    struct alarm_msg *msg = malloc(sizeof(struct alarm_msg));
    char input[256];
    const char *auto_input = "hello";
    size_t len = strlen(auto_input);

    strncpy(input, auto_input, sizeof(input));
    input[sizeof(input)-1] = '\0';

    if(len > 0 && input[len-1] == '\n'){
        input[len-1] = '\0';
    }

    printf ("Sending %s msg to RA ...", input);
    xalarm_report_event(ALARM_REBOOT_EVENT, input, strlen(input));
    id_filter.id_list[ID_INDEX_0] = ALARM_REBOOT_ACK_EVENT;
    id_filter.len = ID_LIST_LENGTH;
    ret = xalarm_register_event(&register_info, id_filter);
    if(ret < 0 ){
        printf("%d\n", ret);
        perror("Failed to register xalarm\n");
        return 1;
    }
    printf("Waiting for RA msg .....\n");
    ret = xalarm_get_event(msg, register_info);
    if(ret < 0){
        perror("Failed to get msg\n");
        return 1;
    }
    RefreshOutput();
    print_alarm_info(msg);
    xalarm_unregister_event(&register_info);
    RefreshOutput();
    return 0;
}