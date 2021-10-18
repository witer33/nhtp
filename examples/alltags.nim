import engine, httpclient

var html = Engine()
html.run(newHttpClient().getContent("http://example.com"))

echo len(html.findAll(""))
