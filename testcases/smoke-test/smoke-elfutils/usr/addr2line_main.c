/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */

#include <stdio.h>
#include <unistd.h>
#define SLEEPTIME 100
int TestFun1()
{
    printf("test_fun1");
    return 1;
}

int main(void)
{
    char *str = "hello";
    sleep(SLEEPTIME);
    TestFun1;
    return 0;
}
