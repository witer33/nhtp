import cursor, parser, types

type Builder* = ref object of RootObj
    parser*: Parser
    cursor: Cursor
    tags: seq[Tag]

method find_closer(this: Builder, tag: Token): bool {.base.} =
    var initial_index = this.cursor.get_index()
    var name = tag.name
    var closer_expected = 1
    for token in this.cursor.iter():
        if token.kind == TokenType.TagCloser and token.name == name:
            dec closer_expected
        elif token.kind == TokenType.TagOpener and token.name == name:
            inc closer_expected
        if closer_expected == 0:
            this.cursor.go_to(initial_index)
            return true
    this.cursor.go_to(initial_index)
    return false

method build*(this: Builder) {.base.} =
    this.cursor = Cursor(data: this.parser.tokens)
    var opened_tags: seq[Tag]
    var closer_tag = false
    var tag: Tag
    for token in this.cursor.iter():
        if token.kind == TokenType.TagOpener:
            closer_tag = this.find_closer(token)
            tag = Tag(name: token.name, args: token.args, level: len(opened_tags), no_closer: not closer_tag, index: len(this.tags))
            if closer_tag:
                opened_tags.add(tag)
            this.tags.add(tag)
        elif token.kind == TokenType.TagCloser:
            if opened_tags[len(opened_tags)-1].name == token.name:
                opened_tags.delete(len(opened_tags)-1)
        elif token.kind == TokenType.Text:
            if len(opened_tags) > 0:
                opened_tags[len(opened_tags)-1].texts.add(token.content)

method get_tags*(this: Builder): seq[Tag] {.base.} =
    return this.tags
