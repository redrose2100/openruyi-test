#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/file.h>
#include <libtar.h>

int main(int argc, char **argv)
{
        TAR *pTarHandle = NULL;
        int iRet = -1;

        if(argc != 2)
        {
                printf("tartest tar|untar\n");
                return -1;
        }

        if(strcmp(argv[1], "tar") == 0)  //打包
        {
                char *pTarName = "tartest.tar";
                char *file1 = "1.txt";
                char *file2 = "2.txt";

                iRet = tar_open(&pTarHandle, pTarName, NULL, O_WRONLY|O_CREAT, 0644, TAR_GNU);
                if(iRet == -1)
                {
                        printf("tar_open failed reason: %s\n", strerror(errno));
                        return -1;
                }

                tar_append_file(pTarHandle, file1, file1);
                tar_append_file(pTarHandle, file2, file2);
                tar_append_eof(pTarHandle);

                tar_close(pTarHandle);
        }
        else if(strcmp(argv[1], "untar") == 0)  //解包
        {
                char *pTarName = "tartest.tar";
                char *pSaveDir = "test";

                iRet = tar_open(&pTarHandle, pTarName, NULL, O_RDONLY, 0644, TAR_GNU);
                if(iRet == -1)
                {
                        printf("tar_open failed reason: %s\n", strerror(errno));
                        return -1;
                }

                tar_extract_all(pTarHandle, pSaveDir);

                tar_close(pTarHandle);
        }
        else
        {
                printf("tartest tar|untar\n");
                return -1;
        }

        return 0;
}