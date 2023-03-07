/**
 * @title:测试StartDiscovery释放订阅/探测特定服务能力函数，
 *    入参PACKAGE_NAME为NULL、&info为空、&cb为空
 */
#include "dsoftbus_common.h"

static int Discovery_Null(void)
{
    SubscribeInfo info = {
    };
    IDiscoveryCallback cb = {
    };
    return StartDiscovery(NULL, &info, &cb);
}

int main(int argc, char **argv)
{
    int ret = Discovery_Null();
    if (ret) {
        printf("DiscoveryInterface fail, ret=%d\n", ret);
        return 1;
    }
    printf("DiscoveryInterface success, ret=%d\n", ret);
    return 0;
}