/**
 * @title:测试UnPublishService取消发布特定服务能力函数，
 *    入参UnPACKAGE_NAME为正常、UnDEFAULT_PUBLISH_ID为正常
 */
#include "dsoftbus_common.h"

#define UnPACKAGE_NAME "softbus_sample"
#define UnDEFAULT_PUBLISH_ID 123

int main(int argc, char **argv)
{
    PublishServiceInterface();
    int ret = UnPublishService(UnPACKAGE_NAME, UnDEFAULT_PUBLISH_ID);
    if (ret) {
        printf("UnPublishService fail:%d\n", ret);
        return 1;
    }
    else {
        printf("UnPublishService success:%d\n", ret);
        return 0;
    }
}