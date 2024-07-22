/**
 * @ttitle:测试软总线完成自动组网并且创建传输连接之后，进行字节流数据传输的功能场景
 */
#include "dsoftbus_common.h"

void ComTest()
{
    NodeBasicInfo *dev = NULL;
    char cData[] = "hello world test";
    int dev_num, sessionId, ret;
    int timeout = 5;

    dev_num = GetAllNodeDeviceInfoInterface(&dev);
    if (dev_num <= 0) {
        return;
    }

    SetGlobalSessionId(-1);
    sessionId = OpenSessionInterface(dev[0].networkId, TYPE_BYTES);
    if (sessionId < 0) {
        printf("OpenSessionInterface fail, ret=%d\n", sessionId);
        goto err_OpenSessionInterface;
    }

    while (timeout) {
        if (sessionId == GetGlobalSessionId()) {
            ret = SendBytes(sessionId, cData, strlen(cData) + 1);
            if (ret) {
                printf("SendBytes fail:%d\n", ret);
                goto err_SendBytesInterface;
            }
            break;
        }
        timeout--;
        sleep(1);
    }
    printf("SendBytes success:%d\n", ret);

err_SendBytesInterface:
    CloseSessionInterface(sessionId);
err_OpenSessionInterface:
    FreeNodeInfoInterface(dev);
}

int main(int argc, char **argv)
{
    PreEnv();
    CommunicationLoop();

    CleanEnv();
    return 0;
}
