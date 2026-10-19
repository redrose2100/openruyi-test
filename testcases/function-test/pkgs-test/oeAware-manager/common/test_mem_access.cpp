/*
* 测试用例，程序每个周期大量访问内存，并记录每个周期耗时，所有内存的numa节点分布情况
* 建议O2, 单位时间访存更多，容易触发算法流程
* g++ test_mem_access.cpp -o test_mem_access -O2 -lnuma
* ./test_mem_access 10240 1000
*/

#include <iostream>
#include <vector>
#include <chrono>
#include <cstring>
#include <unistd.h>
#include <sys/mman.h>
#include <numa.h>
#include <numaif.h>
#include <errno.h>

class SimpleNumaTest {
private:
    size_t memory_size;
    void* memory_ptr;
    size_t page_size;
    int num_pages;
    
public:
    SimpleNumaTest(size_t size_mb) : memory_size(size_mb * 1024 * 1024), memory_ptr(nullptr) {
        page_size = sysconf(_SC_PAGESIZE);
        num_pages = (memory_size + page_size - 1) / page_size;
        
        // 分配内存
        memory_ptr = mmap(nullptr, memory_size, PROT_READ | PROT_WRITE, 
                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (memory_ptr == MAP_FAILED) {
            std::cerr << "Failed to allocate memory" << std::endl;
            exit(1);
        }
        
        // 锁定内存
        if (mlock(memory_ptr, memory_size) != 0) {
            std::cerr << "Failed to lock memory" << std::endl;
        }
    }
    
    ~SimpleNumaTest() {
        if (memory_ptr != nullptr && memory_ptr != MAP_FAILED) {
            munlock(memory_ptr, memory_size);
            munmap(memory_ptr, memory_size);
        }
    }
    
    void access_memory() {
        char* data = static_cast<char*>(memory_ptr);
        for (size_t i = 0; i < memory_size; i += 64) {
            data[i] = data[i] + 1;
        }
    }
    
    std::vector<int> get_numa_distribution() {
        std::vector<int> node_counts;
        
        // 检查NUMA支持
        if (numa_available() < 0) {
            return node_counts;
        }
        
        int num_nodes = numa_num_configured_nodes();
        node_counts.resize(num_nodes, 0);
        
        // 方法1: 尝试使用move_pages获取精确的NUMA分布
        std::vector<void*> pages(num_pages);
        std::vector<int> nodes(num_pages, -1);
        
        // 获取每个页面的地址
        for (int i = 0; i < num_pages; i++) {
            pages[i] = static_cast<char*>(memory_ptr) + i * page_size;
        }
        
        // 调用move_pages获取NUMA分布
        int result = move_pages(0, num_pages, pages.data(), nullptr, nodes.data(), MPOL_MF_MOVE_ALL);
        
        if (result == 0) {
            // 统计每个节点的页面数量
            for (int i = 0; i < num_pages; i++) {
                if (nodes[i] >= 0 && nodes[i] < num_nodes) {
                    node_counts[nodes[i]]++;
                }
            }
        } else {
            std::cout << "move_pages failed" << strerror(errno) << std::endl;
        }
        
        return node_counts;
    }
    
    void run_test(int cycles) {
        std::cout << "Memory size: " << (memory_size / (1024 * 1024)) << "MB, Cycles: " << cycles << std::endl;
        
        for (int cycle = 1; cycle <= cycles; cycle++) {
            auto start = std::chrono::high_resolution_clock::now();
            
            access_memory();
            
            auto end = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            
            // 获取NUMA分布
            auto numa_dist = get_numa_distribution();
            
            // 输出结果：周期 耗时 节点分布
            std::cout << "Cycle " << cycle << " " << duration.count() << "us ";
                    
            for (size_t i = 0; i < numa_dist.size(); i++) {
                std::cout << "node" << i << ":" << numa_dist[i] << " ";
            }
            
            std::cout << std::endl;
        }
    }
};

int main(int argc, char* argv[]) {
    size_t memory_size_mb = 1024; // 默认1GB
    int cycles = 10;              // 默认10个周期
    
    // 解析命令行参数
    if (argc > 1) {
        memory_size_mb = std::stoul(argv[1]);
    }
    if (argc > 2) {
        cycles = std::stoi(argv[2]);
    }
    
    // 检查NUMA支持
    if (numa_available() < 0) {
        std::cerr << "NUMA not available" << std::endl;
        return 1;
    }
    
    try {
        SimpleNumaTest test(memory_size_mb);
        test.run_test(cycles);
    } catch (const std::exception& e) {
        std::cerr << "Test failed: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}