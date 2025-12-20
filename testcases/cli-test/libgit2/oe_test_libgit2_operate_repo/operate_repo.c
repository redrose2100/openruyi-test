#include <git2.h>
#include <stdio.h>

int main() {
    git_libgit2_init();

    // 打开/创建 Git 仓库
    git_repository *repo = NULL;
    int error = git_repository_open(&repo, "./my_git_repo");
    if (error != 0) {
        fprintf(stderr, "Error opening repository: %s\n", giterr_last()->message);
        return 1;
    }

    // 创建一个新的文件example.txt
    FILE *file = fopen("./my_git_repo/example.txt", "w");
    fputs("Hello, libgit2!", file);
    fclose(file);

    // 添加文件 example.txt 到暂存区
    git_index *index = NULL;
    error = git_repository_index(&index, repo);
    if (error != 0) {
        fprintf(stderr, "Error getting repository index: %s\n", giterr_last()->message);
        return 1;
    }

    error = git_index_add_bypath(index, "example.txt");
    if (error != 0) {
        fprintf(stderr, "Error adding file to index: %s\n", giterr_last()->message);
        return 1;
    }
    git_index_write(index);

    // 写入暂存区更改到 Git 对象数据库
    git_oid tree_id, commit_id;
    git_tree *tree = NULL;
    error = git_index_write_tree(&tree_id, index);
    if (error != 0) {
        fprintf(stderr, "Error writing tree from index: %s\n", giterr_last()->message);
        return 1;
    }
    error = git_tree_lookup(&tree, repo, &tree_id);
    if (error != 0) {
        fprintf(stderr, "Error looking up tree: %s\n", giterr_last()->message);
        return 1;
    }

    // 创建提交对象
    git_signature *author, *committer;
    git_signature_now(&author, "Lisa", "lisa@163.com");
    committer = author;

    git_commit *parent = NULL;
    error = git_reference_name_to_id(&commit_id, repo, "HEAD");
    if (error != 0) {
        fprintf(stderr, "Error getting HEAD reference: %s\n", giterr_last()->message);
        return 1;
    }
    error = git_commit_lookup(&parent, repo, &commit_id);
    if (error != 0 && error != GIT_ENOTFOUND) {
        fprintf(stderr, "Error getting parent commit: %s\n", giterr_last()->message);
        return 1;
    }

    const char *message = "Add example.txt";
    error = git_commit_create_v(&commit_id, repo, "HEAD", author, committer, NULL, message, tree, error == GIT_ENOTFOUND ? 0 : 1, parent);
    if (error != 0) {
        fprintf(stderr, "Error creating commit: %s\n", giterr_last()->message);
        return 1;
    }

    printf("Commit created successfully.\n");

    // 释放资源
    git_tree_free(tree);
    git_commit_free(parent);
    git_signature_free(author);
    git_index_free(index);
    git_repository_free(repo);

    git_libgit2_shutdown();

    return 0;
}
