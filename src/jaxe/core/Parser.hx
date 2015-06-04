package jaxe.core;

import tokens.Tokens as T;

@:access(jaxe.core.Lexer)
class Parser {
  var tokens : T<Token>;
  var source : String;
  public function new(toks : Array<Token>, source : String) {
    this.tokens = new T(toks);
    this.source = source;
  }

  function error(message : String, ?pos : haxe.PosInfos) {
    throw new ParserError(message, pos);
  }

  // utility
  function peek() {

  }
}
