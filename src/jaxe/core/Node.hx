package jaxe.core;

import jaxe.core.Nodes;
import jaxe.core.Token;
using thx.Arrays;
using thx.Functions;
using thx.MapList;

class Node {
  public var position : Position;
  public function new(position : Position) {
    this.position = null == position ? { line : -1, source : null } : position;
  }

  public function toObject() : NodeObject {
    var ob = {
      pos : {
        line   : position.line,
        source : position.source
      },
      type : null
    };
    return ob;
  }
}

class Block extends Node {
  public static function fromObject(ob : NodeObject) {
    if(ob.type != "block") throw new ParserParseError('Block.fromObject is working on wrong type.');
    var nodes = ob.nodes.map(Nodes.fromObject);
    return new Block(nodes, ob.pos);
  }

  public var nodes : Array<Node>;
  public function new(nodes : Array<Node>, position : Position) {
    super(position);
    this.nodes = nodes;
  }

  override function toObject() : NodeObject {
    var o = super.toObject();
    o.type = "block";
    o.nodes = nodes.map.fn(_.toObject());
    return o;
  }
}

class Comment extends Node {
  public static function fromObject(ob : NodeObject) {
    if(ob.type != "comment") throw new ParserParseError('Comment.fromObject is working on wrong type.');
    return new Comment(ob.content, ob.pos);
  }

  public var content : String;
  public function new(content : String, position : Position) {
    super(position);
    this.content = content;
  }

  override function toObject() : NodeObject {
    var o = super.toObject();
    o.type = "comment";
    o.content = content;
    return o;
  }
}

class Tag extends Block {
  public static function fromObject(ob : NodeObject) {
    if(ob.type != "tag") throw new ParserParseError('Tag.fromObject is working on wrong type.');
    var nodes = ob.nodes.map(Nodes.fromObject);
    return new Tag(ob.name, ob.selfClosing, nodes, ob.pos);
  }

  public var name : String;
  public var selfClosing : Bool;
  public var attributes : StringMapList<Content>;
  public function new(name : String, selfClosing : Bool, nodes : Array<Node>, position : Position) {
    super(nodes, position);
    this.name = name;
    this.selfClosing = selfClosing;
    this.attributes = new StringMapList();
  }

  override function toObject() : NodeObject {
    var o = super.toObject();
    o.type = "tag";
    o.name = name;
    o.selfClosing = selfClosing;
    return o;
  }
}

class Text extends Node {
  public static function fromObject(ob : NodeObject) {
    if(ob.type != "text") throw new ParserParseError('Text.fromObject is working on wrong type.');
    return new Text(ob.content, ob.pos);
  }

  public var content : String;
  public function new(content : String, position : Position) {
    super(position);
    this.content = content;
  }

  override function toObject() : NodeObject {
    var o = super.toObject();
    o.type = "text";
    o.content = content;
    return o;
  }
}

class DoctypeNode extends Node {
  public static function fromObject(ob : NodeObject) {
    if(ob.type != "doctype") throw new ParserParseError('Doctype.fromObject is working on wrong type.');
    var doctype = switch ob.doctype {
          case "default": DefaultDoctype;
          case "html": HtmlDoctype;
          case "xml": XmlDoctype;
          case "transitional": XhtmlTransitionalDoctype;
          case "strict": XhtmlStrictDoctype;
          case "frameset": XhtmlFramesetDoctype;
          case "1.1": Xhtml11Doctype;
          case "basic": BasicDoctype;
          case "mobile": MobileDoctype;
        case "custom": CustomDoctype(ob.customType);
          case unknown: throw new LexerParseError('unknown doctype $unknown');
        };
    return new DoctypeNode(doctype, ob.pos);
  }

  public var doctype : Doctype;
  public function new(doctype : Doctype, position : Position) {
    super(position);
    this.doctype = doctype;
  }

  override function toObject() : NodeObject {
    var o = super.toObject();
    o.type = "doctype";
    switch doctype {
      case DefaultDoctype:
        o.doctype = "default";
      case HtmlDoctype:
        o.doctype = "html";
      case XmlDoctype:
        o.doctype = "xml";
      case XhtmlTransitionalDoctype:
        o.doctype = "transitional";
      case XhtmlStrictDoctype:
        o.doctype = "strict";
      case XhtmlFramesetDoctype:
        o.doctype = "frameset";
      case Xhtml11Doctype:
        o.doctype = "1.1";
      case BasicDoctype:
        o.doctype = "basic";
      case MobileDoctype:
        o.doctype = "mobile";
      case CustomDoctype(value):
        o.doctype = "custom";
        o.customType = value;
    }
    return o;
  }
}

enum Content {
  Literal(value : String);
  Expression(code : String);
  Composite(left : Content, right : Content);
}

typedef Position = {
  line : Int,
  source : String
}
