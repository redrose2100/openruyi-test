/**
 * @ttitle:测试软总线完成自动组网后，两台设备创建到对端的传输连接功能
 */
#include "dsoftbus_common.h"

void ComTest()
{
    NodeBasicInfo *dev = NULL;
    int dev_num, sessionId;

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
    printf("OpenSessionInterface success, ret=%d\n", sessionId);
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
