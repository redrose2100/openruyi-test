/**
 * @title:测试FreeNodeInfo释放GetAllNodeDeviceInfo返回的节点信息内存函数，
 *     入参dev为NULL
 */
#include "dsoftbus_common.h"

static void Commnunicate_NullDev(void)
{
    NodeBasicInfo *dev = NULL;

    FreeNodeInfoInterface(dev);
    printf("FreeNodeInfo success 1");
    FreeNodeInfoInterface(dev);
    printf("FreeNodeInfo success 2");
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
                Commnunicate_NullDev();
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