import simplejson as json

# 创建一个字典
data = {
    "name": "Alice",
    "age": 25,
    "city": "New York"
}

# 序列化为 JSON 字符串
json_string = json.dumps(data)
print("Serialized JSON:", json_string)

# 反序列化 JSON 字符串
parsed_data = json.loads(json_string)
print("Deserialized Data:", parsed_data)
