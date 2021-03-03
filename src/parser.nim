import types, strtabs

type Parser* = ref object of RootObj
    html*: string
    tokens*: seq[Token]
    cursor: int

iterator next_char(this: Parser): char = 
    while this.cursor < len(this.html):
        inc this.cursor
        yield this.html[this.cursor - 1]

method parse_string(this: Parser, sign: char): string {.base.} = 
    var value = ""

    for current_char in this.next_char():
        if current_char == sign:
            return value
        else:
            value.add(current_char)
    return value

method parse_tag(this: Parser) {.base.} = 
    var name = ""
    var args = newStringTable()
    var arg_name = ""
    var arg_value = ""
    var in_args = false
    var in_value = false
    var tag_closer = false

    for current_char in this.next_char():
        if current_char == ' ' and not in_args:
            in_args = true
        elif current_char == ' ':
            if arg_name != "":
                args[arg_name] = arg_value
            arg_name = ""
            arg_value = ""
            in_value = false
        elif current_char == '=' and not in_value:
            in_value = true
        elif current_char == '!' and arg_name == "":
            return
        elif current_char == '/' and not in_args and name == "":
            tag_closer = true
        elif current_char == '>':
            if arg_name != "":
                args[arg_name] = arg_value
            break
        elif (current_char == "'"[0] or current_char == '"') and in_args:
            if in_value:
                arg_value.add(this.parse_string(current_char))
            else:
                arg_name.add(this.parse_string(current_char))
        elif in_args and not in_value:
            arg_name.add(current_char)
        elif in_args and in_value:
            arg_value.add(current_char)
        else:
            name.add(current_char)
    if tag_closer:
        this.tokens.add(Token(kind: TokenType.TagCloser, name: name))
    else:
        this.tokens.add(Token(kind: TokenType.TagOpener, name: name, args: args))

method parse_tokens*(this: Parser) {.base.} = 
    var text = ""

    for current_char in this.next_char():
        if current_char == '<':
            if text != "":
                this.tokens.add(Token(kind: TokenType.Text, content: text))
                text = ""
            this.parse_tag()
        else:
            text.add(current_char)
    if text != "":
        this.tokens.add(Token(kind: TokenType.Text, content: text))
