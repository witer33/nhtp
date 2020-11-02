import nhtp
import requests

html = nhtp.Engine(requests.get("https://example.com").content)

print(html.find_all(""))
