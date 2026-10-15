#include <stdio.h>
#include <git2.h>

int main(int argc, char **argv)
{

    // 初始化libgit2
    git_libgit2_init();

    git_repository *repo = NULL;
    // 使用/tmp/myrepo路径下的内部Git仓库的镜像
    const char *url = "file:///tmp/myrepo";
    // 指定本地克隆路径
    const char *path = "./testdir";
    git_clone_options opts = GIT_CLONE_OPTIONS_INIT;

    // 克隆仓库
    int error;
    error = git_clone(&repo, url, path, &opts);
    if (error != 0)
    {
        printf("Could not clone repository\n");
        return -1;
    }
    printf("Cloned successfully!\n");

    // 清理并关闭库
    git_repository_free(repo);
    git_libgit2_shutdown();
    return 0;
}
