/**
 * @title:测试已完成可信设备添加时，自动组网的功能
 */
#include "dsoftbus_common.h"

static void Communicate_DoubleFree(void)
{
    NodeBasicInfo *dev = NULL;
    int dev_num;
    SetGlobalSessionId(-1);

    dev_num = GetAllNodeDeviceInfoInterface(&dev);
    if (dev_num <= 0) {
        printf("GetAllNodeDeviceInfo fail\n");
        goto err_GetAllNodeDeviceInfoInterface;
    }
    printf("GetAllNodeDeviceInfo success\n");
    FreeNodeInfoInterface(dev);
    FreeNodeInfoInterface(dev);

err_GetAllNodeDeviceInfoInterface:
    printf("The networking is complete\n");
}

int main(int argc, char **argv)
{
    bool loop = true;
    int ret;

    HichainInit();

    ret = CreateSessionServerInterface();
    if (ret) {
        printf("CreateSessionServer fail, ret=%d\n", ret);
        return 1;
    }

    ret = PublishServiceInterface();
    if (ret) {
        printf("PublishService fail, ret=%d\n", ret);
        return 1;
    }

    ret = DiscoveryInterface();
    if (ret) {
        printf("DiscoveryInterface fail, ret=%d\n", ret);
        return 1;
    }

    while (loop) {
        printf("\nInput c to commnuication, Input s to stop:");
        char op = getchar();
        switch (op) {
            case 'c':
                Communicate_DoubleFree();
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
    UnPublishServiceInterface();
    RemoveSessionServerInterface();
    return 0;
}