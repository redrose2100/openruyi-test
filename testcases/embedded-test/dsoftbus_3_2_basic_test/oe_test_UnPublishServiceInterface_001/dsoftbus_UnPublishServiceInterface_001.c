/**
 * @ttitle:测试UnPublishService取消发布特定服务能力函数，TestRes函数第二个入参为1时是正常测试，为0时是异常测试
 */
#include "dsoftbus_common.h"
#define UnDEFAULT_PUBLISH_ID 123
#define UnPACKAGE_NAME "softbus_sample"
#define WRONG_UnPACKAGE_1 NULL

void ComTest()
{
    char *interface_name = "UnPublishServiceInterface";
    PublishServiceInterface();
    int ret = UnPublishService(UnPACKAGE_NAME, UnDEFAULT_PUBLISH_ID);
    TestRes(ret, 1, interface_name, 1);

    PublishServiceInterface();
    ret = UnPublishService("    ", UnDEFAULT_PUBLISH_ID);
    TestRes(ret, 0, interface_name, 2);

    ret = UnPublishService(WRONG_UnPACKAGE_1, UnDEFAULT_PUBLISH_ID);
    TestRes(ret, 0, interface_name, 3);

    ret = UnPublishService(UnPACKAGE_NAME, 0);
    TestRes(ret, 0, interface_name, 4);

    ret = UnPublishService(UnPACKAGE_NAME, -1);
    TestRes(ret, 0, interface_name, 5);

    ret = UnPublishService(WRONG_UnPACKAGE_1, 0);
    TestRes(ret, 0, interface_name, 6);
}

int main(int argc, char **argv)
{
    ComTest();
    return 0;
}