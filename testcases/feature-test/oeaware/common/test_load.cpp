/*
 * 测试程序：创建指定数量的高负载和低负载的线程
 * 编译：g++ test_load.cpp -o test_load -O2
 * 运行：./test_load [有负载线程数] [低负载线程数]
 * 示例：./test_load 4 2
 * 使用Ctrl+C停止程序
 */

#include <iostream>
#include <vector>
#include <thread>
#include <atomic>
#include <chrono>
#include <signal.h>

class LoadTest {
private:
    static std::atomic<bool> stop_flag;
    int load_threads_count;
    int idle_threads_count;
    
public:
    LoadTest(int load_threads, int idle_threads) 
        : load_threads_count(load_threads), idle_threads_count(idle_threads) {}
    
    static void signal_handler(int signal) {
        stop_flag.store(true);
    }
    
    // 有负载的线程函数 - 简单while循环
    void load_worker(int thread_id) {
        while (!stop_flag.load()) {
            // 空循环，消耗CPU
        }
    }
    
    // 低负载的线程函数，负载手动修改修换调节
    void idle_worker(int thread_id) {
        while (!stop_flag.load()) {
            // 低负载
            std::this_thread::sleep_for(std::chrono::milliseconds(1));
            int cnt = 0;
            for (int i = 0; i < 100000000; i++) {
                for(int j = 0; j < i+ 10000; j++) {
                    cnt = i + j + i * j + i * i - j * j;
                }
            }
        }
    }
    
    void run_test() {
        std::vector<std::thread> threads;
        
        // 创建有负载的线程
        for (int i = 0; i < load_threads_count; i++) {
            threads.emplace_back(&LoadTest::load_worker, this, i);
        }
        
        // 创建无负载的线程
        for (int i = 0; i < idle_threads_count; i++) {
            threads.emplace_back(&LoadTest::idle_worker, this, i);
        }
        
        // 等待所有线程完成
        for (auto& thread : threads) {
            thread.join();
        }
    }
};

// 定义静态成员变量
std::atomic<bool> LoadTest::stop_flag{false};

int main(int argc, char* argv[]) {
    int load_threads = 2;    // 默认2个有负载线程
    int idle_threads = 1;    // 默认1个无负载线程
    
    // 解析命令行参数
    if (argc > 1) {
        load_threads = std::stoi(argv[1]);
    }
    if (argc > 2) {
        idle_threads = std::stoi(argv[2]);
    }
    
    // 设置信号处理
    signal(SIGINT, LoadTest::signal_handler);
    
    LoadTest test(load_threads, idle_threads);
    test.run_test();
    
    return 0;
}
