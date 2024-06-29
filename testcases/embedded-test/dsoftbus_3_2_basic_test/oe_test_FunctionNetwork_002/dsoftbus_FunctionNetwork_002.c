/**
 * @ttitle:测试软总线已完成可信设备添加时，自动组网的功能场景
 */
#include "dsoftbus_common.h"

void ComTest()
{
    int dev_num;
    NodeBasicInfo *dev = NULL;
    dev_num = GetAllNodeDeviceInfoInterface(&dev);
    if (dev_num <= 0) {
        printf("GetAllNodeDeviceInfo fail\n");
        return;
    }
    printf("GetAllNodeDeviceInfo success\n");
    FreeNodeInfoInterface(dev);
    FreeNodeInfoInterface(dev);
}

int main(int argc, char **argv)
{
    PreEnv();
    CommunicationLoop();
    CleanEnv();
    return 0;
}
