/**
 * @title:测试正常情况下，进行可信设备添加后，两个设备之间自动组网、连接、通信的场景
 */
#include "dsoftbus_common.h"

static void Communicate_Input(void)
{
    NodeBasicInfo *dev = NULL;
    char cData[] = "hello world test";
    int dev_num, sessionId, input, ret;
    int timeout = 5;

    dev_num = GetAllNodeDeviceInfoInterface(&dev);
    if (dev_num <= 0) {
        return;
    }

    printf("\nInput Node num to commnunication:");
    scanf_s("%d", &input);
    if (input <= 0 || input > dev_num) {
        printf("error input num\n");
        goto err_input;
    }

    SetGlobalSessionId(-1);
    sessionId = OpenSessionInterface(dev[input - 1].networkId);
    if (sessionId < 0) {
        printf("OpenSessionInterface fail, ret=%d\n", sessionId);
        goto err_OpenSessionInterface;
    }

    while (timeout) {
        if (GetGlobalSessionId() == sessionId) {
            ret = SendBytes(sessionId, cData, strlen(cData) + 1);
            if (ret) {
                printf("SendBytes fail:%d\n", ret);
            }
            break;
        }
        timeout--;
        sleep(1);
    }

    CloseSessionInterface(sessionId);
err_OpenSessionInterface:
err_input:
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
                Communicate_Input();
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
