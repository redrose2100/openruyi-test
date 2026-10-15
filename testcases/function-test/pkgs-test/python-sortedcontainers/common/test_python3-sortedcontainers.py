from sortedcontainers import SortedList

def run_tests():
    test_create_sorted_list()
    test_add_items_to_sorted_list()
    test_remove_items_from_sorted_list()

def test_create_sorted_list():
    sl = SortedList()
    assert len(sl) == 0, "Failed: test_create_sorted_list"
    print("Test Passed: test_create_sorted_list")

def test_add_items_to_sorted_list():
    sl = SortedList()
    sl.add(5)
    sl.add(2)
    sl.add(8)
    assert len(sl) == 3, "Failed: test_add_items_to_sorted_list"
    assert sl[0] == 2, "Failed: test_add_items_to_sorted_list"
    assert sl[-1] == 8, "Failed: test_add_items_to_sorted_list"
    print("Test Passed: test_add_items_to_sorted_list")

def test_remove_items_from_sorted_list():
    sl = SortedList([1, 2, 3, 4, 5])
    sl.remove(3)
    assert 3 not in sl, "Failed: test_remove_items_from_sorted_list"
    sl.discard(6)
    assert len(sl) == 4, "Failed: test_remove_items_from_sorted_list"
    sl.clear()
    assert len(sl) == 0, "Failed: test_remove_items_from_sorted_list"
    print("Test Passed: test_remove_items_from_sorted_list")

run_tests()
