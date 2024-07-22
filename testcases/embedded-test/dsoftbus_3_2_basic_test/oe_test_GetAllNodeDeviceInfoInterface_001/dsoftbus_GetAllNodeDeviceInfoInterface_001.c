/**
 * @ttitle:测试GetAllNodeDeviceInfo获取当前组网内所有节点信息函数，TestRes函数第二个入参为2时是正常测试，为0或3时是异常测试
 */
#include "dsoftbus_common.h"

void ComTest(NodeBasicInfo **dev, NodeBasicInfo **dev1)
{
    char *interface_name = "GetAllNodeDeviceInfoInterface";
    int num, ret;

    ret = GetAllNodeDeviceInfo("softbus_sample", dev, &num);
    TestRes(num, 2, interface_name, 1);

    printf("<GetAllNodeDeviceInfo>return %d Node\n", num);
    for (int i = 0; i < num; i++) {
        printf("<num %d>deviceName=%s\n", i + 1, dev[i]->deviceName);
        printf("\tnetworkId=%s\n", dev[i]->networkId);
        printf("\tType=%d\n", dev[i]->deviceTypeId);
    }

    ret = GetAllNodeDeviceInfo("ERR_PACKAGE_NAME", dev1, &num);
    TestRes(ret, 3, interface_name, 2);

    ret = GetAllNodeDeviceInfo("", dev1, &num);
    TestRes(ret, 3, interface_name, 3);

    ret = GetAllNodeDeviceInfo("    ", dev1, &num);
    TestRes(ret, 0, interface_name, 4);

    ret = GetAllNodeDeviceInfo(NULL, dev1, &num);
    TestRes(ret, 0, interface_name, 5);
}

int main(int argc, char **argv)
{
    PreEnv();
    NodeBasicInfo *dev = NULL;
    NodeBasicInfo *dev1 = NULL;
    bool loop = true;

    while (loop) {
        printf("\nInput c to commnuication, Input s to stop:");
        char op = getchar();
        switch (op) {
            case 'c':
                ComTest(&dev, &dev1);
                FreeNodeInfoInterface(dev);
                FreeNodeInfoInterface(dev1);
                loop = false;
            case 's':
                loop = false;
                break;
            default:
                continue;
        }
    }
    CleanEnv();
    return 0;
}