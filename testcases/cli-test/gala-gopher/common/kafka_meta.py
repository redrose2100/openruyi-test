from kafka import KafkaConsumer
import json

def main():
    consumer = KafkaConsumer(
        'gala_gopher_event',
        group_id="group3",
        bootstrap_servers=["ip:9092"]
    )
    for msg in consumer:
        print("in")
        print(msg)
        print("out")

if __name__ == '__main__':
    main()
