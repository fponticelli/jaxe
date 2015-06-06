package jaxe.core;

import jaxe.core.Node;

class Nodes {
	public static function toObject(node : Node) : NodeObject {
		return node.toObject();
	}

	public static function fromObject(obj : NodeObject) : Node {
		return switch obj.type {
      case "block": Block.fromObject(obj);
			case "tag": Tag.fromObject(obj);
			case "text": Text.fromObject(obj);
			case _: throw new ParserParseError('unknown type "${obj.type}"');
    };
	}
}

typedef NodeObject = {
  type : String,
  pos : {
    line : Int,
    source : String
  },
	?nodes : Array<NodeObject>,
	?name : String,
	?content : String,
	?selfClosing : Bool
}
