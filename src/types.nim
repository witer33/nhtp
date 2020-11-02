import strtabs

type TokenType* {.pure.} = enum TagOpener, TagCloser, Text

type Token* = ref object
    name*: string
    case kind*: TokenType
    of TagOpener: 
        args*: StringTableRef
        self_closing*: bool
    of Text:
        content*: string
    else:
        discard

type Tag* = ref object of RootObj
    name*: string
    args*: StringTableRef
    level*: int
    texts*: seq[string]
    no_closer*: bool
    index*: int
