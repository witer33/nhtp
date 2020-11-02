import engine, httpclient

var html = Engine(html: newHttpClient().getContent("http://example.com"))

echo len(html.findAll(""))
