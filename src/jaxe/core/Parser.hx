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
    var block = new Block([], { line : 0, source : source }),
        next;
    while(true) {
      next = advance(); // was peek
      switch next.token {
        case TComment:
          block.nodes.push(parseComment(next.pos));
        case TCommentInline(text):
          block.nodes.push(new Comment(text, next.pos));
        case TDoctype(doctype):
          block.nodes.push(parseDoctype(doctype, next.pos));
        case TEos: break;
        case TNewline: // advance();
        case TTag(name, selfClosing):
          block.nodes.push(parseTag(name, selfClosing, next.pos));
        case TTextHtml(html):
          block.nodes.push(parseTextHtml(html, next.pos));
        case other:
          error('Not Implemented Yet: $other', next.pos);
      }
    }

    return block;
  }

  function parseComment(pos : Position) {
    var text = parseTextBlock();
    return new Comment(text, pos);
  }

  function parseTextHtml(html : String, pos : Position) {
    html += parseTextBlock();
    return new Html(html, pos);
  }

  function parseTextBlock() {
    var text = "",
        next;
    while(true) {
      next = advance();
      switch next.token {
        case TText(ntext):
          text += ntext;
        case TNewline:
          text += "\n";
        case _:
          defer(next);
          return text;
      }
    }
  }

  function parseDoctype(doc : Doctype, pos : Position)
    return new DoctypeNode(doc, pos);

  function parseTag(name : String, selfClosing : Bool, pos : Position) {
    var tag = new Tag(name, selfClosing, [], pos),
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
          var t = parseText(text, next.pos);
          tag.nodes.push(t);
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

    return tag;
  }

  function parseText(text : String, pos : Position)
    return new Text(parseTextBlock(), pos);

  function parseHtml(html : String, pos : Position)
    return new Html(parseTextBlock(), pos);

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
