#include <iostream>
#include <string>

#ifdef BOOST_TEST_FILESYSTEM
#include <boost/filesystem.hpp>
#endif

#ifdef BOOST_TEST_SYSTEM
#include <boost/system/error_code.hpp>
#endif

#ifdef BOOST_TEST_REGEX
#include <boost/regex.hpp>
#endif

#ifdef BOOST_TEST_THREAD
#include <boost/thread.hpp>
#endif

#ifdef BOOST_TEST_SMART_PTR
#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>
#include <memory>
#endif

#ifdef BOOST_TEST_ASIO
#include <boost/asio.hpp>
#endif

#ifdef BOOST_TEST_DATE_TIME
#include <boost/date_time/gregorian/gregorian.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>
#endif

#ifdef BOOST_TEST_STRING_ALGO
#include <boost/algorithm/string.hpp>
#include <vector>
#endif

#ifdef BOOST_TEST_OPTIONAL
#include <boost/optional.hpp>
#endif

#ifdef BOOST_TEST_VARIANT
#include <boost/variant.hpp>
#endif

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cout << "Usage: boost_test <module>\n";
        return 1;
    }

    std::string module = argv[1];

#ifdef BOOST_TEST_FILESYSTEM
    if (module == "filesystem") {
        boost::filesystem::path p(".");
        if (boost::filesystem::exists(p)) std::cout << "BOOST_FS_EXISTS_OK\n";
        if (boost::filesystem::is_directory(p)) std::cout << "BOOST_FS_ISDIR_OK\n";
        boost::filesystem::path tmp = boost::filesystem::temp_directory_path();
        std::cout << "BOOST_FS_TEMP_OK\n";
        boost::filesystem::path abs = boost::filesystem::absolute(p);
        std::cout << "BOOST_FS_ABS_OK\n";
        std::string name = p.filename().string();
        std::cout << "BOOST_FS_FILENAME_OK\n";
    }
#endif

#ifdef BOOST_TEST_SYSTEM
    if (module == "system") {
        boost::system::error_code ec;
        ec.assign(2, boost::system::generic_category());
        if (ec.value() == 2) std::cout << "BOOST_SYS_ERRCODE_OK\n";
        std::string msg = ec.message();
        std::cout << "BOOST_SYS_MSG_OK\n";
        boost::system::error_code ec2 = boost::system::errc::make_error_code(boost::system::errc::permission_denied);
        if (ec2) std::cout << "BOOST_SYS_MAKE_OK\n";
    }
#endif

#ifdef BOOST_TEST_REGEX
    if (module == "regex") {
        std::string text = "Hello Boost 1.91.0, Test 2026";
        boost::regex expr("Boost ([0-9.]+)");
        boost::smatch matches;
        if (boost::regex_search(text, matches, expr)) std::cout << "BOOST_REGEX_SEARCH_OK\n";
        std::string replaced = boost::regex_replace(text, expr, "C++");
        std::cout << "BOOST_REGEX_REPLACE_OK\n";
        boost::regex expr2("^[0-9]+$");
        if (boost::regex_match("12345", expr2)) std::cout << "BOOST_REGEX_MATCH_OK\n";
    }
#endif

#ifdef BOOST_TEST_THREAD
    if (module == "thread") {
        boost::mutex mtx;
        int counter = 0;
        boost::thread t1([&]() { boost::lock_guard<boost::mutex> lock(mtx); counter++; });
        boost::thread t2([&]() { boost::lock_guard<boost::mutex> lock(mtx); counter++; });
        t1.join(); t2.join();
        if (counter == 2) std::cout << "BOOST_THREAD_SYNC_OK\n";
        boost::thread::id id = t1.get_id();
        std::cout << "BOOST_THREAD_ID_OK\n";
        boost::this_thread::sleep_for(boost::chrono::milliseconds(1));
        std::cout << "BOOST_THREAD_SLEEP_OK\n";
    }
#endif

#ifdef BOOST_TEST_SMART_PTR
    if (module == "smart_ptr") {
        boost::shared_ptr<int> sp = boost::make_shared<int>(42);
        if (*sp == 42 && sp.use_count() == 1) std::cout << "BOOST_SP_OK\n";
        boost::shared_ptr<int> sp2 = sp;
        if (sp2.use_count() == 2) std::cout << "BOOST_SP_SHARE_OK\n";
        std::unique_ptr<int> up(new int(100));
        if (*up == 100) std::cout << "BOOST_UP_OK\n";
    }
#endif

#ifdef BOOST_TEST_ASIO
    if (module == "asio") {
        boost::asio::io_context io;
        boost::asio::steady_timer timer(io, boost::asio::chrono::milliseconds(10));
        timer.async_wait([](const boost::system::error_code&) {});
        io.run();
        std::cout << "BOOST_ASIO_TIMER_OK\n";
        boost::asio::ip::tcp::socket sock(io);
        std::cout << "BOOST_ASIO_SOCKET_OK\n";
    }
#endif

#ifdef BOOST_TEST_DATE_TIME
    if (module == "date_time") {
        boost::gregorian::date d(2026, 7, 20);
        if (d.year() == 2026 && d.month() == 7 && d.day() == 20) std::cout << "BOOST_DATE_OK\n";
        boost::gregorian::date today = boost::gregorian::day_clock::local_day();
        std::cout << "BOOST_DATE_TODAY_OK\n";
        boost::posix_time::ptime now = boost::posix_time::microsec_clock::local_time();
        std::cout << "BOOST_TIME_NOW_OK\n";
    }
#endif

#ifdef BOOST_TEST_STRING_ALGO
    if (module == "string_algo") {
        std::string s = "  Hello Boost  ";
        boost::trim(s);
        if (s == "Hello Boost") std::cout << "BOOST_SA_TRIM_OK\n";
        boost::to_upper(s);
        if (s == "HELLO BOOST") std::cout << "BOOST_SA_UPPER_OK\n";
        bool found = boost::contains(s, "BOOST");
        if (found) std::cout << "BOOST_SA_CONTAINS_OK\n";
        std::vector<std::string> parts;
        boost::split(parts, s, boost::is_any_of(" "));
        if (parts.size() == 2) std::cout << "BOOST_SA_SPLIT_OK\n";
    }
#endif

#ifdef BOOST_TEST_OPTIONAL
    if (module == "optional") {
        boost::optional<int> opt;
        if (!opt) std::cout << "BOOST_OPT_EMPTY_OK\n";
        opt = 42;
        if (*opt == 42) std::cout << "BOOST_OPT_VALUE_OK\n";
        boost::optional<int> opt2 = boost::none;
        if (!opt2) std::cout << "BOOST_OPT_NONE_OK\n";
    }
#endif

#ifdef BOOST_TEST_VARIANT
    if (module == "variant") {
        boost::variant<int, std::string> v(42);
        std::cout << "BOOST_VAR_INT_OK\n";
        v = std::string("test");
        std::cout << "BOOST_VAR_STRING_OK\n";
        struct visitor : boost::static_visitor<void> {
            void operator()(int) const {}
            void operator()(const std::string&) const {}
        };
        boost::apply_visitor(visitor(), v);
        std::cout << "BOOST_VAR_VISITOR_OK\n";
    }
#endif

    return 0;
}
