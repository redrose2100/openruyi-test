/**
 * @ttitle:测试FreeNodeInfo释放GetAllNodeDeviceInfo返回的节点信息内存函数，ComTest1为正常测试，ComTest2为异常测试
 */
#include "dsoftbus_common.h"

void ComTest()
{
    NodeBasicInfo *dev = NULL;

    FreeNodeInfoInterface(dev);
    printf("FreeNodeInfo success 1\n");
    FreeNodeInfoInterface(dev);
    printf("FreeNodeInfo success 2\n");
}

void ComTest1()
{
    int num;
    NodeBasicInfo *dev = NULL;

    GetAllNodeDeviceInfo("softbus_sample", &dev, &num);

    FreeNodeInfoInterface(dev);
    printf("FreeNodeInfo success 3\n");
    FreeNodeInfoInterface(dev);
    printf("FreeNodeInfo success 4\n");
}

int main(int argc, char **argv)
{
    PreEnv();
    bool loop = true;

    while (loop) {
        printf("\nInput c to commnuication, Input s to stop:");
        char op = getchar();
        switch (op) {
            case 'c':
                ComTest();
                continue;
            case 't':
                ComTest1();
                continue;
            case 's':
                loop = false;
                break;
            default:
                continue;
        }
    }

    return 0;
}
