package jaxe.core;

import jaxe.core.Node;
import jaxe.core.Token;
import jaxe.core.TokenStream;

@:access(jaxe.core.Lexer)
class Parser {
  var tokens : TokenStream<Token>;
  var source : String;
  public function new(toks : Array<Token>, source : String) {
    this.tokens = new TokenStream(toks);
    this.source = source;
  }

  public function parse() {
    var block = new Block([], 0, source),
        next;
    while(true) {
      next = peek();
      switch next.token {
        case TEos: break;
        case TNewline: advance();
        case other: error('Not Implemented Yet: other');
      }
    }

    return block;
  }

  // utility
  inline function advance()
    return tokens.advance();

  function error(message : String, ?pos : haxe.PosInfos)
    throw new ParserError(message, pos);

  inline function peek()
    return tokens.peek();

  inline function lookahead(n : Int)
    return tokens.lookahead(n);
}
