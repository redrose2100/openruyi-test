class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def test_hasattr(self):
        assert hasattr(self, 'name') is True and hasattr(self, 'age') is True


if __name__ == '__main__':
    person = Person('qinjiaxi', 18)
    person.test_hasattr()
