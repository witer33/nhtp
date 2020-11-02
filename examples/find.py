import nhtp
import requests

http = nhtp.Engine(requests.get("https://example.com").content)

print(http.find("title").texts[0])

print(http.find("meta", http-equiv="Content-type").args["content"])
