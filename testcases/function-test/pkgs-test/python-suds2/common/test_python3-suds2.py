from suds.client import Client

try:
    from suds.client import Client
    print("Import suds2 package successfully")
except ImportError:
    print("Failed to import suds2 package")

try:
    client = Client('http://www.dneonline.com/calculator.asmx?WSDL')
    result = client.service.Add(2, 3)
    if result is not None:
        print(f"Successfully connected to web service and got a result: {result}")
    else:
        print("Failed to get a result from web service")
except Exception as e:
    print(f"Failed to connect to web service: {e}")
