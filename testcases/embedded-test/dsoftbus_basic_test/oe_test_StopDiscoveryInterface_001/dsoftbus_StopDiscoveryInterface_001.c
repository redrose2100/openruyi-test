/**
 * @ttitle:测试StopDiscovery取消订阅特性服务能力，TestRes函数第二个入参为1时是正常测试，为0时是异常测试
 */
#include "dsoftbus_common.h"
#define STOP_DEFAULT_PUBLISH_ID 123
#define STOP_PACKAGE_NAME "softbus_sample"
#define WRONG_STOP_PACKAGE_1 NULL

void ComTest()
{
    char *interface_name = "StopDiscoveryInterface";
    DiscoveryInterface();
    int ret = StopDiscovery(STOP_PACKAGE_NAME, STOP_DEFAULT_PUBLISH_ID);
    TestRes(ret, 1, interface_name, 1);

    DiscoveryInterface();
    ret = StopDiscovery("    ", STOP_DEFAULT_PUBLISH_ID);
    TestRes(ret, 0, interface_name, 2);

    ret = StopDiscovery(WRONG_STOP_PACKAGE_1, STOP_DEFAULT_PUBLISH_ID);
    TestRes(ret, 0, interface_name, 3);

    ret = StopDiscovery(STOP_PACKAGE_NAME, 0);
    TestRes(ret, 0, interface_name, 4);

    ret = StopDiscovery(STOP_PACKAGE_NAME, -1);
    TestRes(ret, 0, interface_name, 5);

    ret = StopDiscovery(WRONG_STOP_PACKAGE_1, 0);
    TestRes(ret, 0, interface_name, 6);
}

int main(int argc, char **argv)
{
    ComTest();
    return 0;
}
