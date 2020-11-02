import engine, httpclient

var html = Engine(html: newHttpClient().getContent("http://example.com"))
html.run()

echo len(html.findAll(""))
