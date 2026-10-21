from typing import  Tuple

def get_name_age() -> Tuple[str, int]:
    name = "John"
    age = 30
    return name, age

if __name__ == "__main__":
    name, age = get_name_age()
    print("Name:", name, "Age:", age)
