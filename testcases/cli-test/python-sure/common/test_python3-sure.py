from sure import expect

def test_addition():
    result = 2 + 2
    expect(result).to.equal(4)

def test_subtraction():
    result = 5 - 3
    expect(result).to.equal(2)

if __name__ == "__main__":
    test_addition()
    test_subtraction()
