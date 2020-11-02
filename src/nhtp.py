#This is a simple Python class to use the parser.

import nimporter, libnhtp as nhtp
import json

class Tag:

    def __init__(self, name: str, args: dict, level: int, index: int, texts: list, no_closer: bool):
        self.name = name
        self.args = args
        self.level = level
        self.index = index
        self.texts = texts
        self.no_closer = no_closer

    def __repr__(self):
        return f"<Tag ({self.name})>"

class utils:

    def parse_args(args):
        parsed_args = {}
        for arg in args:
            parsed_args[arg[0]] = arg[1]
        return parsed_args

    def json_to_tag(json_tag):
        json_tag = json.loads(json_tag)
        return Tag(name=json_tag["name"], args=utils.parse_args(json_tag["args"]), level=json_tag["level"], index=json_tag["index"], texts=json_tag["texts"], no_closer=json_tag["no_closer"])

class Engine:

    def __init__(self, html: str):
        self.nim_engine = nhtp.get_engine(str(html))

    def find(self, name: str, args: dict = {}, level: int = -1, after: int = 0, **args2):
        args = json.dumps(args.update(args2))
        return utils.json_to_tag(nhtp.get_tag(nhtp.find(self.nim_engine, name, args, level, after)))

    def find_all(self, name: str, args: dict = {}, level: int = -1, after: int = 0, **args2):
        args = json.dumps(args.update(args2))
        results = []
        for tag in nhtp.find_all(self.nim_engine, name, args, level, after):
            results.append(utils.json_to_tag(nhtp.get_tag(tag)))
        return results
