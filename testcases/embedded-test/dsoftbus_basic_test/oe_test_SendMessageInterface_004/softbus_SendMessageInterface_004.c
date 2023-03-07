/**
 * @title:测试SendMessage消息数据传输能力函数，
 *   入参sessionId为正常、cData为NULL、len_cData为正常
 */
#include "dsoftbus_common.h"

#define cData NULL

static void Communicate_SendMessageNullData(void)
{
    NodeBasicInfo *dev = NULL;
    int dev_num, sessionId, ret;
    int timeout = 5;

    dev_num = GetAllNodeDeviceInfoInterface(&dev);
    if (dev_num <= 0) {
        return;
    }

    SetGlobalSessionId(-1);
    sessionId = OpenSessionInterface(dev[0].networkId);
    if (sessionId < 0) {
        printf("OpenSessionInterface fail, ret=%d\n", sessionId);
        goto err_OpenSessionInterface;
    }

    while (timeout) {
        if (GetGlobalSessionId() == sessionId) {
            ret = SendMessage(sessionId, cData, strlen(cData) + 1);
            if (ret) {
                printf("SendMessage fail:%d\n", ret);
                goto err_SendMessageInterface;
            }
            break;
        }
        timeout--;
        sleep(1);
    }
    printf("SendMessage success:%d\n", ret);

err_SendMessageInterface:
    CloseSessionInterface(sessionId);
err_OpenSessionInterface:
    FreeNodeInfoInterface(dev);
}

int main(int argc, char **argv)
{
    bool loop = true;
    int ret;

    HichainInit();

    ret = CreateSessionServerInterface();
    if (ret) {
        printf("CreateSessionServer fail, ret=%d\n", ret);
        return ret;
    }

    ret = PublishServiceInterface();
    if (ret) {
        printf("PublishService fail, ret=%d\n", ret);
        goto err_PublishServiceInterface;
    }

    ret = DiscoveryInterface();
    if (ret) {
        printf("DiscoveryInterface fail, ret=%d\n", ret);
        goto err_DiscoveryInterface;
    }

    while (loop) {
        printf("\nInput c to commnuication, Input s to stop:");
        char op = getchar();
        switch (op) {
            case 'c':
                Communicate_SendMessageNullData();
                continue;
            case 's':
                loop = false;
                break;
            case '\n':
                break;
            default:
                continue;
        }
    }

    StopDiscoveryInterface();
err_DiscoveryInterface:
    UnPublishServiceInterface();
err_PublishServiceInterface:
    RemoveSessionServerInterface();
    return 0;
}