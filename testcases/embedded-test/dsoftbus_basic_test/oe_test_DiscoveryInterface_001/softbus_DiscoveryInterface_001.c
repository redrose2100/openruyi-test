/**
 * @title:测试StartDiscovery释放订阅/探测特定服务能力函数，
 *   入参PACKAGE_NAME为正常、&info为正常、&cb为正常
 */
#include "dsoftbus_common.h"

int main(int argc, char **argv)
{
    int ret = DiscoveryInterface();
    if (ret) {
        printf("DiscoveryInterface fail, ret=%d\n", ret);
        return 1;
    }
    printf("DiscoveryInterface success, ret=%d\n", ret);
    return 0;
}