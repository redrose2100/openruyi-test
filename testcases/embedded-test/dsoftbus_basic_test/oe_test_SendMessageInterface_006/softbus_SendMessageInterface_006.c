/**
 * @title:测试SendMessage消息数据传输能力函数，
 *    入参sessionId为正常、cData为正常、len_cData为0
 */
#include "dsoftbus_common.h"

static void Communicate_SendMessageZeroLen(void)
{
    NodeBasicInfo *dev = NULL;
    char cData[] = "hello world test";
    int dev_num, sessionId, ret;
    int len_cData = 0;
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
            ret = SendMessage(sessionId, cData, len_cData);
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
                Communicate_SendMessageZeroLen();
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