import engine, httpclient, strtabs

var html = Engine(html: newHttpClient().getContent("http://example.com"))
html.run()

echo html.find("title").getAllText()

echo html.find("meta", args={"http-equiv": "Content-type"}.newStringTable).args["content"]
