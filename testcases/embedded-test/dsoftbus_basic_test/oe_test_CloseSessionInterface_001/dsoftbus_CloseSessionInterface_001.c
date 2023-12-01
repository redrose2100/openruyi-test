/**
 * @ttitle:测试CloseSessio断开传输连接函数正常入参，入参sessionID正常
 */
#include "dsoftbus_common.h"

void ComTest()
{
    NodeBasicInfo *dev = NULL;
    int dev_num = GetAllNodeDeviceInfoInterface(&dev);
    if (dev_num <= 0) {
        return;
    }

    int sessionId = OpenSessionInterface(dev[0].networkId);
    CloseSession(sessionId);
}

int main(int argc, char **argv)
{
    PreEnv();
    CommunicationLoop();
    return 0;
}
