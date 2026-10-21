from schema import Schema, And, Use

def main():
    # 定义 Schema
    person_schema = Schema({
        "name": And(str, len),
        "age": And(Use(int), lambda n: 18 <= n <= 99),
        "email": And(str, Use(str.lower))
    })

    # 测试数据
    person = {"name": "John Doe", "age": "30", "email": "JOHN@EXAMPLE.COM"}

    # 验证测试数据是否符合 Schema
    try:
        validated_person = person_schema.validate(person)
        print("验证通过：", validated_person)
    except Exception as e:
        print("验证失败：", e)

if __name__ == "__main__":
    main()
