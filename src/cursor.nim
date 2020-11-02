import types

type Cursor* = ref object of RootObj
    data*: seq[Token]
    index: int

method go_to*(this: Cursor, index: int) {.base.} = 
    this.index = index

method get_index*(this: Cursor): int {.base.} =
    return this.index

method next*(this: Cursor): Token {.base.} =
    if this.index < len(this.data):
        inc this.index
        return this.data[this.index - 1]

iterator iter*(this: Cursor): Token =
    while this.index < len(this.data):
        inc this.index
        yield this.data[this.index - 1]
