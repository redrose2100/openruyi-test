/**
 * @title:测试GetAllNodeDeviceInfo获取当前组网内所有节点信息函数，
 *      入参GET_PACKAGE_NAME为NULL
 */
#include "dsoftbus_common.h"

static int GetAllNodeDeviceInfo_NullPackageName(NodeBasicInfo **dev)
{
    int ret, num;

    ret = GetAllNodeDeviceInfo(NULL, dev, &num);
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

static int Communicate_NullPackageName(void)
{
    NodeBasicInfo *dev = NULL;
    int dev_num;

    dev_num = GetAllNodeDeviceInfo_NullPackageName(&dev);

    return dev_num;
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

    ret = Communicate_NullPackageName();
    if (ret == -1){
        printf("GetAllNodeDeviceInfo fail\n");
        return 1;
    }

    StopDiscoveryInterface();
    UnPublishServiceInterface();
    RemoveSessionServerInterface();
    return 0;
}

