#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <xalarm/register_xalarm.h>
#include <time.h>
#include <signal.h>
#include "smh_common_type.h"

#define SLEEP_TIME 1
#define SMH_MESSAGE_MAX 4
#define ID_LIST_LENGTH SMH_MESSAGE_MAX
#define TIME_UNIT_MILLISECONDS 1000
#define URMA_SEND_DATA_MAX_LEN 100

int event_id;
int ack_result = 0;
int g_wait_ack_event_id;
struct alarm_register* register_info;

void signal_handler(int signum){
    printf("收到信号：%d, 程序将退出\n", signum);
    xalarm_unregister_event(register_info);
}
void process_alarm_info(struct alarm_msg *param)
{
    int alarmid;
    long long alarmtime;
    char *pucParas;
    if (param == NULL){
        perror("接受插件发送的消息失败\n");
        return;
    }
    alarmid = param->usAlarmId;
    event_id= alarmid;
    alarmtime = ((long long)(param->AlarmTime.tv_sec)* TIME_UNIT_MILLISECONDS + (long long)(param->AlarmTime.tv_usec) / TIME_UNIT_MILLISECONDS);
    pucParas = (char *)param ->pucParas;
    printf ("plugin notified with [alarmid:%d] [alarmtime:%lld ms] [msg:%s]\n", alarmid, alarmtime, pucParas);
    return;
}
int main(int argc, char **argv)
{
    struct alarm_msg *msg =malloc(sizeof(struct alarm_msg));
    struct alarm_subscription_info id_filter;
    id_filter.id_list[0] = ALARM_REBOOT_EVENT;
    id_filter.id_list[1] = ALARM_OOM_EVENT;
    id_filter.id_list[2] = ALARM_PANIC_EVENT;
    id_filter.id_list[3] = ALARM_KERNEL_REBOOT_EVENT;
    
    id_filter.len = ID_LIST_LENGTH;
    int ret;
    ack_result = atoi(argv[1]);
    time_t start_time, current_time;
    bool time_start_flag = false;
    double elapsed_seconds;
    int delay_ack_time=0;
    sscanf(argv[2], "%d", &delay_ack_time);
    int cnt = 0;
    
    ret = xalarm_register_event(&register_info, id_filter);
    if(ret < 0){
        perror("Failed to register xalarm\n");
        return 1;
    }
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);

    while (1){
        printf("waiting for plugin msg....\n");
        ret = xalarm_get_event(msg, register_info);
        if (ret<0){
            perror("Failed to get msg \n");
            return 1;
        }else {
            printf("get mgs success, cnt is %d.\n", ++cnt);
        }
        process_alarm_info(msg);
        if(!time_start_flag){
            time(&start_time);
            time_start_flag = true;
            g_wait_ack_event_id = event_id;
        }
        if (g_wait_ack_event_id == ALARM_REBOOT_EVENT){
            if (ack_result !=2){
                char res_str[256];
                snprintf(res_str, 256, "%s_%d", msg->pucParas, ack_result);
                ret = xalarm_report_event(ALARM_REBOOT_ACK_EVENT, res_str);
                if(ret < 0){
                    perror("Failed to send reboot ack msg \n");
                    return 1;
                }
                printf("send reboot ack msg to plugin \n");
            }
        }else if (g_wait_ack_event_id == ALARM_OOM_EVENT){
            if(ack_result !=2){
                char res_str[256];
                snprintf(res_str, 256, "%s_%d", msg->pucParas, ack_result);
                ret=xalarm_report_event(ALARM_OOM_ACK_EVENT, res_str);
                if(ret < 0){
                    perror("Failed to send oom ack msg\n");
                    return 1;
                }
                printf("send oom ack msg to plugin \n");
            }
        }else if (g_wait_ack_event_id == ALARM_PANIC_EVENT){
            if(ack_result !=2){
                char res_str[URMA_SEND_DATA_MAX_LEN];
                snprintf(res_str, URMA_SEND_DATA_MAX_LEN, "%s_%d", msg->pucParas, ack_result);
                if (delay_ack_time <=0){
                    time_start_flag =false;
                    ret = xalarm_report_event(ALARM_PANIC_ACK_EVENT, res_str);
                    if(ret < 0) {
                        printf("Failed to send panic ack msg %s\n", res_str);
                        return 1;

                    }
                    printf("send panic ack msg to plugin %s\n", res_str);
                    continue;
                }
                time(&current_time);
                elapsed_seconds = difftime(current_time, start_time);

                printf("pass: %.0fs | remain:%ds",
                    elapsed_seconds, delay_ack_time - (int)elapsed_seconds);
                fflush(stdout);
                if(elapsed_seconds >= delay_ack_time){
                    time_start_flag = false;
                    ret = xalarm_report_event(ALARM_PANIC_ACK_EVENT, res_str);
                    if(ret < 0){
                        printf("Failed to send panic ack msg %s\n", res_str);
                        return 1;
                    }
                    printf("send panic ack msg to plugin %s\n", res_str);
                }

            }
        }else if (g_wait_ack_event_id == ALARM_KERNEL_REBOOT_EVENT){
            if(ack_result !=2){
                char res_str[URMA_SEND_DATA_MAX_LEN];
                snprintf(res_str, URMA_SEND_DATA_MAX_LEN, "%s_%d", msg->pucParas, ack_result);
                if(delay_ack_time <=0){
                    time_start_flag=false;
                    ret = xalarm_report_event(ALARM_KERNEL_REBOOT_ACK_EVENT, res_str);
                    if(ret < 0){
                        printf("Failed to send kernel reboot ack msg %s\n", res_str);
                        return 1;                        
                    }
                    printf("send kernel reboot ack msg to plugin %s\n", res_str);
                    continue;
                }
                time(&current_time);
                elapsed_seconds = difftime(current_time, start_time);
                printf("pass: %.0fs | remain:%ds",
                    elapsed_seconds, delay_ack_time - (int)elapsed_seconds);
                fflush(stdout);                
                if (elapsed_seconds >=delay_ack_time){
                    time_start_flag =false;
                    ret = xalarm_report_event(ALARM_KERNEL_REBOOT_ACK_EVENT, res_str);
                     if(ret < 0){
                        printf("Failed to send kernel reboot ack msg %s\n", res_str);
                        return 1;                        
                    }
                    printf("send kernel reboot ack msg to plugin %s\n", res_str);
                }
            }
        }
    }
    xalarm_unregister_event(register_info);
    return 0;

}