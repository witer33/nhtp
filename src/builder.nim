import cursor, parser, types, tables

type Builder* = ref object of RootObj
    parser*: Parser
    cursor: Cursor
    tags: seq[Tag]

method find_closers(this: Builder) {.base.} =
    var initial_index = this.cursor.get_index()
    var opened_tags = initTable[string, seq[Token]]()
    for token in this.cursor.iter():
        if token.kind == TokenType.TagOpener:
            if opened_tags.hasKey token.name:
                opened_tags[token.name].add(token)
            else:
                opened_tags[token.name] = @[token]
        elif token.kind == TokenType.TagCloser:
            if opened_tags.hasKey(token.name) and len(opened_tags[token.name]) > 0:
                opened_tags[token.name][len(opened_tags[token.name]) - 1].self_closing = false
                opened_tags[token.name].delete(len(opened_tags[token.name]) - 1)
    this.cursor.go_to(initial_index)

method build*(this: Builder) {.base.} =
    this.cursor = Cursor(data: this.parser.parse_tokens())
    this.find_closers()
    var opened_tags: seq[Tag]
    var tag: Tag
    for token in this.cursor.iter():
        if token.kind == TokenType.TagOpener:
            tag = Tag(name: token.name, args: token.args, level: len(opened_tags), no_closer: token.self_closing, index: len(this.tags))
            if not tag.no_closer:
                opened_tags.add(tag)
            this.tags.add(tag)
        elif token.kind == TokenType.TagCloser:
            if len(opened_tags) > 0 and opened_tags[len(opened_tags)-1].name == token.name:
                opened_tags.delete(len(opened_tags)-1)
        elif token.kind == TokenType.Text:
            if len(opened_tags) > 0:
                opened_tags[len(opened_tags)-1].texts.add(token.content)

method get_tags*(this: Builder): seq[Tag] {.base.} =
    return this.tags
