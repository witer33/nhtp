import engine, strtabs, nimpy, types, json

proc get_engine(html: string): Engine {.exportpy.} =
    var e = Engine(html: html)
    e.run()
    return e

proc find(e: Engine, name: string, args: string = "{}", level: int = -1, after: int = 0): Tag {.exportpy.} =
    var parsed_args = parseJson(args)
    var table_args = newStringTable()
    if parsed_args.kind != JNull:
        for arg, value in parsed_args.pairs():
            table_args[arg] = value.getStr()
    return e.find(name, table_args, level, after)

proc find_all(e: Engine, name: string, args: string = "{}", level: int = -1, after: int = 0): seq[Tag] {.exportpy.} =
    var parsed_args = parseJson(args)
    var table_args = newStringTable()
    if parsed_args.kind != JNull:
        for arg, value in parsed_args.pairs():
            table_args[arg] = value.getStr()
    return e.findAll(name, table_args, level, after)

proc get_tag(tag: Tag): string {.exportpy.} =
    var args: seq[seq[string]]
    for arg, value in tag.args.pairs():
        args.add(@[arg, value])
    return $(%* {"name": tag.name, "args": args, "level": tag.level, "index": tag.index, "texts": tag.texts, "no_closer": tag.no_closer})
