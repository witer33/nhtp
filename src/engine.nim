import builder, parser, types, strtabs

type Engine* = ref object of RootObj
    html*: string
    tags: seq[Tag]

method run*(this: Engine) {.base.} =
    var parser = Parser(html: this.html)
    var builder = Builder(parser: parser)
    parser.parse_tokens()
    builder.build()
    this.tags = builder.get_tags()

method get_tags*(this: Engine): seq[Tag] {.base.} = this.tags

method find*(this: Engine, name: string, args: StringTableRef = newStringTable(), level: int = -1, after: int = 0): Tag {.base.} =
    var breaked = false
    for index, tag in this.tags[after..^1]:
        breaked = false
        if tag.name == name or name == "":
            if level == -1 or level == tag.level:
                for arg, value in args.pairs():
                    if (not tag.args.hasKey(arg)) or tag.args[arg] != value:
                        breaked = true
                        break
                if not breaked:
                    return tag
    raise newException(ValueError, "Tag not found.")

method findAll*(this: Engine, name: string, args: StringTableRef = newStringTable(), level: int = -1, startLevel: int = 0, after: int = 0): seq[Tag] {.base.} =
    var breaked = false
    var tags: seq[Tag]
    for index, tag in this.tags[after..^1]:
        breaked = false
        if tag.name == name or name == "":
            if level == -1 or level == tag.level and tag.level >= startLevel:
                for arg, value in args.pairs():
                    if (not tag.args.hasKey(arg)) or tag.args[arg] != value:
                        breaked = true
                        break
                if not breaked:
                   tags.add(tag)
    if len(tags) == 0:
        raise newException(ValueError, "Tag not found.")
    else:
        return tags

method get*(this: Tag, arg: string): string {.base.} = this.args[arg]

method getText*(this: Tag, index: int): string {.base.} = this.texts[index]

method getAllText*(this: Tag): string {.base.} = 
    var all_texts = ""
    for text in this.texts:
        all_texts.add(text)
    return all_texts
