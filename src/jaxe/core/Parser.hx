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
      next = advance(); // was peek
      switch next.token {
        case TEos: break;
        case TNewline: // advance();
        case TTag(name, selfClosing):
          parseTag(name, selfClosing, next.pos);
        case other: error('Not Implemented Yet: $other', next.pos);
      }
    }

    return block;
  }

  function parseTag(name : String, selfClosing : Bool, pos) {
    var tag = new Tag(name, selfClosing, [], pos.line, pos.source),
        next;
    while(true) {
      next = advance(); // was peek
      switch next.token {
        case TId(name) if(tag.attributes.exists("id")):
          error('duplicate id: $name', next.pos);
        case TId(name):
          tag.attributes.set("id", Literal(name));
        case TClassName(name) if(tag.attributes.exists("class")):
          var left = tag.attributes.get("class");
          tag.attributes.set("class", Composite(left, Literal(name)));
        case TClassName(name):
          tag.attributes.set("class", Literal(name));
        case _:
          defer(next);
          break;
      }
    }

    while(true) {
      next = advance();
      switch next.token {
      case TText(text):
          // parseText
          break;
        case TNewline:
          // do nothing
        case TIndent(indents):
        case TOutdent:
        case TEos:
        case TPipelessStart:
        case _:
          error('Unexpected token $next', next.pos);
          break;
      }
    }
  }

  // utility
  inline function advance()
    return tokens.advance();

  inline function defer(token : Token)
    return tokens.defer(token);

  function error(message : String, pos : {}, ?posInfo : haxe.PosInfos) {
    // TODO pos
    throw new ParserError(message, posInfo);
  }

  inline function peek()
    return tokens.peek();

  inline function lookahead(n : Int)
    return tokens.lookahead(n);
}
