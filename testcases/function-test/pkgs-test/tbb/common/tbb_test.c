#include <tbb/tbb.h>
#include <tbb/parallel_for.h>
#include <tbb/parallel_reduce.h>
#include <tbb/parallel_sort.h>
#include <tbb/concurrent_vector.h>
#include <tbb/blocked_range.h>
#include <vector>
#include <cstdio>
#include <random>
#include <algorithm>

bool test_parallel_for() {
    const int N = 1000;
    std::vector<int> arr(N, 0);
    tbb::parallel_for(tbb::blocked_range<int>(0, N),
        [&](const tbb::blocked_range<int>& r) {
            for (int i = r.begin(); i < r.end(); ++i) arr[i] = i * 2;
        });
    for (int i = 0; i < N; ++i) {
        if (arr[i] != i * 2) return false;
    }
    printf("PASS: parallel_for\n");
    return true;
}

bool test_parallel_reduce() {
    const int N = 1000;
    std::vector<int> arr(N);
    for (int i = 0; i < N; ++i) arr[i] = i + 1;
    int expected = N * (N + 1) / 2;
    int actual = tbb::parallel_reduce(
        tbb::blocked_range<int>(0, N), 0,
        [&](const tbb::blocked_range<int>& r, int s) {
            for (int i = r.begin(); i < r.end(); ++i) s += arr[i];
            return s;
        }, std::plus<int>());
    bool result = actual == expected;
    printf("%s: parallel_reduce\n", result ? "PASS" : "FAIL");
    return result;
}

bool test_parallel_sort() {
    const int N = 1000;
    std::vector<int> arr(N);
    std::mt19937 rng;
    for (int i = 0; i < N; ++i) arr[i] = rng() % 10000;
    tbb::parallel_sort(arr.begin(), arr.end());
    bool sorted = std::is_sorted(arr.begin(), arr.end());
    printf("%s: parallel_sort\n", sorted ? "PASS" : "FAIL");
    return sorted;
}

bool test_concurrent_vector() {
    const int N = 1000;
    tbb::concurrent_vector<int> cv;
    tbb::parallel_for(tbb::blocked_range<int>(0, N),
        [&](const tbb::blocked_range<int>& r) {
            for (int i = r.begin(); i < r.end(); ++i) cv.push_back(i);
        });
    bool result = cv.size() == static_cast<size_t>(N);
    printf("%s: concurrent_vector\n", result ? "PASS" : "FAIL");
    return result;
}

int main() {
    bool all_pass = true;
    all_pass &= test_parallel_for();
    all_pass &= test_parallel_reduce();
    all_pass &= test_parallel_sort();
    all_pass &= test_concurrent_vector();

    printf("%s\n", all_pass ? "TBB_PARALLEL_TEST_PASS" : "TBB_PARALLEL_TEST_FAIL");
    return all_pass ? 0 : 1;
}
