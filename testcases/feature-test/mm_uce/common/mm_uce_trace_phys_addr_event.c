// SPDX-License-Identifier: GPL-2.0

/*
 * Copyright (C) 2024 Cloud Inspur Corporation
 * Authors: Che liequan
 *
 * This software may be redistributed and/or modified under the terms of
 * the GNU General Public License ("GPL") version 2 only as published by the
 * Free Software Foundation.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

#define TRACE_PATH "/sys/kernel/debug/tracing/trace_pipe"
#define ENABLE_PATH "/sys/kernel/debug/tracing/events/mm_uce_trace_event/enable"
#define BUFFER_SIZE 1024
#define TIMEOUT_SECONDS 30

// 检查路径存在性的函数
int check_path_exists(const char *path) {
    struct stat statbuf;
    if (stat(path, &statbuf) == 0) {
        return 1; // 路径存在
    }
    return 0; // 路径不存在
}

// 启用 tracepoint
int ensure_tracepoint_enabled(const char *enable_path) {
    if (!check_path_exists(enable_path)) {
        fprintf(stderr, "Tracepoint enable file does not exist.\n");
        return EXIT_FAILURE;
    }

    FILE *fp = fopen(enable_path, "r+");
    if (!fp) {
        perror("Failed to open enable file for reading");
        return EXIT_FAILURE;
    }

    char enabled;
    if (fread(&enabled, 1, 1, fp) != 1 || enabled != '1') {
        fseek(fp, 0, SEEK_SET);
        if (fwrite("1", 1, 1, fp) != 1) {
            perror("Failed to write to enable file");
            fclose(fp);
            return EXIT_FAILURE;
        }
        printf("Tracepoint enabled.\n");
    }
    fclose(fp);
    return EXIT_SUCCESS;
}

int enable_mm_uce_tracepoint(void) {
    if (ensure_tracepoint_enabled(ENABLE_PATH) != EXIT_SUCCESS) {
        fprintf(stderr, "Unable to ensure tracepoint is enabled.\n");
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}

int is_tracepoint_enabled() {
    const char *enable_path = ENABLE_PATH;
    if (!check_path_exists(enable_path)) {
        fprintf(stderr, "Tracepoint enable file does not exist.\n");
        return EXIT_FAILURE;
    }

    FILE *fp = fopen(enable_path, "r+");
    if (!fp) {
        perror("Failed to open enable file for reading");
        return EXIT_FAILURE;
    }

    char enabled;
    if (fread(&enabled, 1, 1, fp) != 1 || enabled != '1') {
            fclose(fp);
            return EXIT_FAILURE;
    } 
    fclose(fp);
    return EXIT_SUCCESS;
}

int wait_for_data(int fd, int timeout) {
    fd_set readfds;
    struct timeval tv;

    FD_ZERO(&readfds);
    FD_SET(fd, &readfds);

    tv.tv_sec = timeout;
    tv.tv_usec = 0;

    int ret = select(fd + 1, &readfds, NULL, NULL, &tv);
    if (ret > 0) {
        return EXIT_SUCCESS; // 数据准备就绪
    } else if (ret == 0) {
        fprintf(stderr, "Timeout, no data available.\n");
        return EXIT_FAILURE; // 超时
    } else {
        perror("select error");
        return EXIT_FAILURE; // 出错
    }
}

int read_trace_pipe(int fd, unsigned long long *ptr_phys_addr) {
    char buffer[BUFFER_SIZE] = {0};
    ssize_t bytesRead = read(fd, buffer, BUFFER_SIZE - 1);
    if (bytesRead > 0) {
        buffer[bytesRead] = '\0'; // Ensure null-terminated string
        if (strstr(buffer, "mm_uce_open")) {
            char *ptr = strstr(buffer, "phys: ");
            if (ptr) {
                ptr += strlen("phys: ");
                if (sscanf(ptr, "%p", ptr_phys_addr) == 1) {
                    fprintf(stderr, "Physical Address: %p\n", (void *)*ptr_phys_addr);
                    return EXIT_SUCCESS;
                }
            }
        }
    } else if (bytesRead == -1 && errno != EAGAIN && errno != EWOULDBLOCK) {
        perror("Failed to read from trace_pipe");
        return EXIT_FAILURE;
    }
    return EXIT_FAILURE;
}

int get_mm_uce_trace_phys_addr_bypipe(unsigned long long *ptr_phys_addr)
{
    if (ensure_tracepoint_enabled(ENABLE_PATH) != EXIT_SUCCESS) {
        fprintf(stderr, "Unable to ensure tracepoint is enabled.\n");
        return EXIT_FAILURE;
    }

    int fd = open(TRACE_PATH, O_RDONLY | O_NONBLOCK);
    if (fd < 0) {
        perror("Failed to open trace_pipe");
        return EXIT_FAILURE;
    }

    // 使用 select() 等待数据
    if (wait_for_data(fd, TIMEOUT_SECONDS) != EXIT_SUCCESS) {
        close(fd);
        return EXIT_FAILURE;
    }
    
    // Optional: Use select() or other mechanism to wait for data
    // Here, directly attempt to read assuming data might be available
    if (read_trace_pipe(fd, ptr_phys_addr) != EXIT_SUCCESS) {
        fprintf(stderr, "Failed to read physical address from trace_pipe.\n");
    } else {
        fprintf(stderr, "Successfully read physical address: %llx\n", *ptr_phys_addr);
    }

    close(fd);
    return EXIT_SUCCESS;

}

int mm_uce_trace_phys_addr_event(unsigned long long *ptr_phys_addr) {
    int pipefd[2];
    pid_t pid;

    if (pipe(pipefd) == -1) {
        perror("pipe");
        return EXIT_FAILURE;
    }

    pid = fork();
    if (pid == -1) {
        perror("fork");
        close(pipefd[0]);
        close(pipefd[1]);
        return EXIT_FAILURE;
    } else if (pid == 0) { // Child process
        close(pipefd[0]); // Close read end
        if (get_mm_uce_trace_phys_addr_bypipe(ptr_phys_addr) == EXIT_SUCCESS) {
            write(pipefd[1], ptr_phys_addr, sizeof(*ptr_phys_addr));
        }
        close(pipefd[1]);
        exit(EXIT_SUCCESS);
    } else { // Parent process
        close(pipefd[1]); // Close write end
        wait(NULL); // Wait for child to finish

        ssize_t count = read(pipefd[0], ptr_phys_addr, sizeof(*ptr_phys_addr));
        close(pipefd[0]);

        if (count == sizeof(*ptr_phys_addr)) {
            return EXIT_SUCCESS;
        }
    }
    return EXIT_FAILURE;
}

/*int main(void) {
    unsigned long long phys_addr = 0;
    if (mm_uce_trace_phys_addr_event(&phys_addr) == EXIT_SUCCESS) {
        fprintf(stderr, "Physical Address: %llx\n", phys_addr);
    } else {
        fprintf(stderr, "Failed to get physical address.\n");
    }
    return 0;
}*/
