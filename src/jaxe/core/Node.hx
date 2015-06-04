package jaxe.core;

class Node {
  public var line : Int;
  public var source : String;
  public function new(line : Int, source : String) {
    this.line = line;
    this.source = source;
  }
}

class Block extends Node {
  public var nodes : Array<Node>;
  public function new(nodes : Array<Node>, line : Int, source : String) {
    super(line, source);
    this.nodes = nodes;
  }
}
