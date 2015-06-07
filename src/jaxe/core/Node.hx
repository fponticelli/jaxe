package jaxe.core;

import jaxe.core.Nodes;
using thx.Arrays;
using thx.MapList;

class Node {
  public var line : Int;
  public var source : String;
  public function new(line : Int, source : String) {
    this.line = line;
    this.source = source;
  }

  public function toObject() : NodeObject {
    var ob = {
      pos : {
        line : line,
        source : source
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
    return new Block(nodes, ob.pos.line, ob.pos.source);
  }

  public var nodes : Array<Node>;
  public function new(nodes : Array<Node>, line : Int, source : String) {
    super(line, source);
    this.nodes = nodes;
  }

  override function toObject() : NodeObject {
    var o = super.toObject();
    o.type = "block";
    o.nodes = nodes.pluck(_.toObject());
    return o;
  }
}

class Tag extends Block {
  public static function fromObject(ob : NodeObject) {
    if(ob.type != "tag") throw new ParserParseError('Tag.fromObject is working on wrong type.');
    var nodes = ob.nodes.map(Nodes.fromObject);
    return new Tag(ob.name, ob.selfClosing, nodes, ob.pos.line, ob.pos.source);
  }

  public var name : String;
  public var selfClosing : Bool;
  public var attributes : StringMapList<Content>;
  public function new(name : String, selfClosing : Bool, nodes : Array<Node>, line : Int, source : String) {
    super(nodes, line, source);
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
    return new Text(ob.content, ob.pos.line, ob.pos.source);
  }

  public var content : String;
  public function new(content : String, line : Int, source : String) {
    super(line, source);
    this.content = content;
  }

  override function toObject() : NodeObject {
    var o = super.toObject();
    o.type = "test";
    o.content = content;
    return o;
  }
}

enum Content {
  Literal(value : String);
  Expression(code : String);
  Composite(left : Content, right : Content);
}
