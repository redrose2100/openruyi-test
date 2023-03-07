/**
 * @title:测试GetAllNodeDeviceInfo获取当前组网内所有节点信息函数，
 *   入参GET_PACKAGE_NAME为正常
 */
#include "dsoftbus_common.h"

static void Commnuicate_GetAllNode(void)
{
    NodeBasicInfo *dev = NULL;
    int dev_num;

    dev_num = GetAllNodeDeviceInfoInterface(&dev);
    if (dev_num <= 0) {
        printf("GetAllNodeDeviceInfo fail\n");
    }
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
                Commnuicate_GetAllNode();
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