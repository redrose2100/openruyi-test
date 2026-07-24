#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <signal.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <seccomp.h>

#define TEST_PASS 0
#define TEST_FAIL 1

static int g_pass = 0;
static int g_fail = 0;

#define RUN_TEST(name, func) do { \
    int r = run_in_child(func); \
    printf("  %-45s %s\n", name, r == TEST_PASS ? "PASS" : "FAIL"); \
    if (r == TEST_PASS) g_pass++; else g_fail++; \
} while (0)

static int run_in_child(int (*test_func)(void))
{
    pid_t pid = fork();
    if (pid < 0) {
        fprintf(stderr, "    fork failed\n");
        return TEST_FAIL;
    }

    if (pid == 0) {
        int ret = test_func();
        exit(ret == TEST_PASS ? 0 : 1);
    }

    int status;
    waitpid(pid, &status, 0);
    return (WIFEXITED(status) && WEXITSTATUS(status) == 0) ? TEST_PASS : TEST_FAIL;
}

int test_init_release(void)
{
    scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_ALLOW);
    if (!ctx) {
        fprintf(stderr, "    seccomp_init failed\n");
        return TEST_FAIL;
    }
    seccomp_release(ctx);
    return TEST_PASS;
}

int test_rule_add_errno(void)
{
    scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_ALLOW);
    if (!ctx) return TEST_FAIL;

    int ret = seccomp_rule_add(ctx, SCMP_ACT_ERRNO(EPERM), SCMP_SYS(open), 0);
    if (ret != 0) {
        fprintf(stderr, "    seccomp_rule_add errno failed: %d\n", ret);
        seccomp_release(ctx);
        return TEST_FAIL;
    }
    seccomp_release(ctx);
    return TEST_PASS;
}

int test_rule_add_kill(void)
{
    scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_ALLOW);
    if (!ctx) return TEST_FAIL;

    int ret = seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(getpid), 0);
    if (ret != 0) {
        fprintf(stderr, "    seccomp_rule_add kill failed: %d\n", ret);
        seccomp_release(ctx);
        return TEST_FAIL;
    }
    seccomp_release(ctx);
    return TEST_PASS;
}

int test_filter_block_open(void)
{
    scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_ALLOW);
    if (!ctx) return TEST_FAIL;

    if (seccomp_rule_add(ctx, SCMP_ACT_ERRNO(EPERM), SCMP_SYS(openat), 0) < 0) {
        seccomp_release(ctx);
        return TEST_FAIL;
    }

    if (seccomp_load(ctx) < 0) {
        seccomp_release(ctx);
        return TEST_FAIL;
    }

    seccomp_release(ctx);

    int fd = open("/dev/null", O_RDONLY);
    return (fd < 0 && errno == EPERM) ? TEST_PASS : TEST_FAIL;
}

int test_filter_kill_getpid(void)
{
    scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_ALLOW);
    if (!ctx) return TEST_FAIL;

    if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(getpid), 0) < 0) {
        seccomp_release(ctx);
        return TEST_FAIL;
    }

    if (seccomp_load(ctx) < 0) {
        seccomp_release(ctx);
        return TEST_FAIL;
    }

    seccomp_release(ctx);
    getpid();
    return TEST_FAIL;
}

int test_syscall_resolve(void)
{
    int n;

    n = seccomp_syscall_resolve_name("read");
    if (n < 0) {
        fprintf(stderr, "    resolve 'read' failed\n");
        return TEST_FAIL;
    }

    n = seccomp_syscall_resolve_name("write");
    if (n < 0) {
        fprintf(stderr, "    resolve 'write' failed\n");
        return TEST_FAIL;
    }

    n = seccomp_syscall_resolve_name("nonexistent_syscall_xyz");
    if (n >= 0) {
        fprintf(stderr, "    resolve invalid name should return error\n");
        return TEST_FAIL;
    }

    return TEST_PASS;
}

int test_attr_set(void)
{
    scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_ALLOW);
    if (!ctx) return TEST_FAIL;

    int ret = seccomp_attr_set(ctx, SCMP_FLTATR_CTL_LOG, 1);
    if (ret != 0) {
        fprintf(stderr, "    seccomp_attr_set failed: %d\n", ret);
        seccomp_release(ctx);
        return TEST_FAIL;
    }
    seccomp_release(ctx);
    return TEST_PASS;
}

int test_export_bpf(void)
{
    scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_ALLOW);
    if (!ctx) return TEST_FAIL;

    if (seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(write), 0) < 0) {
        seccomp_release(ctx);
        return TEST_FAIL;
    }

    FILE *fp = fopen("/tmp/test_seccomp.bpf", "wb");
    if (!fp) {
        seccomp_release(ctx);
        return TEST_FAIL;
    }

    int ret = seccomp_export_bpf(ctx, fileno(fp));
    fclose(fp);
    seccomp_release(ctx);

    if (ret < 0) {
        unlink("/tmp/test_seccomp.bpf");
        return TEST_FAIL;
    }

    struct stat st;
    int ok = (stat("/tmp/test_seccomp.bpf", &st) == 0 && st.st_size > 0);
    unlink("/tmp/test_seccomp.bpf");
    return ok ? TEST_PASS : TEST_FAIL;
}

int main(void)
{
    printf("=== libseccomp Package & Filter Test ===\n\n");

    RUN_TEST("init/release context",        test_init_release);
    RUN_TEST("add errno rule",              test_rule_add_errno);
    RUN_TEST("add kill rule",               test_rule_add_kill);
    RUN_TEST("filter blocks open()",        test_filter_block_open);
    RUN_TEST("syscall name resolve",        test_syscall_resolve);
    RUN_TEST("attribute set",               test_attr_set);
    RUN_TEST("export BPF",                  test_export_bpf);

    {
        pid_t pid = fork();
        if (pid < 0) {
            fprintf(stderr, "    fork failed\n");
            g_fail++;
        } else if (pid == 0) {
            test_filter_kill_getpid();
            exit(0);
        } else {
            int status;
            waitpid(pid, &status, 0);
            if (WIFSIGNALED(status)) {
                printf("  %-45s %s\n", "filter kill mode", "PASS");
                g_pass++;
            } else {
                printf("  %-45s %s\n", "filter kill mode", "FAIL");
                fprintf(stderr, "    child not killed by signal, status=%d\n", status);
                g_fail++;
            }
        }
    }

    printf("\n========================================\n");
    printf("Result: %d passed, %d failed\n", g_pass, g_fail);
    printf("========================================\n");

    return g_fail > 0 ? 1 : 0;
}
