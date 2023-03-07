/**
 * @title:测试GetAllNodeDeviceInfo获取当前组网内所有节点信息函数，
 *     GetAllNodeDeviceInfoInterface入参ERR_PACKAGE_NAMEE为123
 */
#include "dsoftbus_common.h"

#define ERR_PACKAGE_NAME 123

static int GetAllNodeDeviceInfo_ErrPackageName(NodeBasicInfo **dev)
{
    int ret, num;

    ret = GetAllNodeDeviceInfo(ERR_PACKAGE_NAME, dev, &num);
    if (ret) {
        printf("GetAllNodeDeviceInfo fail:%d\n", ret);
        return -1;
    }

    printf("<GetAllNodeDeviceInfo>return %d Node\n", num);
    for (int i = 0; i < num; i++) {
        printf("<num %d>deviceName=%s\n", i + 1, dev[i]->deviceName);
        printf("\tnetworkId=%s\n", dev[i]->networkId);
        printf("\tType=%d\n", dev[i]->deviceTypeId);
    }

    return num;
}

static void Communicate_ErrPackageName(void)
{
    NodeBasicInfo *dev = NULL;
    int dev_num;

    dev_num = GetAllNodeDeviceInfo_ErrPackageName(&dev);
    if (dev_num <= 0) {
        printf("GetAllNodeDeviceInfo fail\n");
    }
}

int main(int argc, char **argv)
{
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

    Communicate_ErrPackageName();

    StopDiscoveryInterface();
    UnPublishServiceInterface();
    RemoveSessionServerInterface();
    return 0;
}