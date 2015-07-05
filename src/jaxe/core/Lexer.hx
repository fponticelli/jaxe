package jaxe.core;

import jaxe.core.Token;
using thx.ERegs;
using thx.Strings;
using thx.Arrays;

class Lexer {
  static var EXPRESSION_SYMBOL = "$";
  static var EXPRESSION_OPEN   = "{";
  static var EXPRESSION_CLOSE  = "}";
  static var EXPRESSION_PREFIX = EXPRESSION_SYMBOL + EXPRESSION_OPEN;

  var input : String;
  var source : String;
  var lastIndents : Int;
  var lineNumber : Int;
  var ended : Bool;
  var tokens : Array<Token>;
  var indentStack : Array<Int>;
  var pipeless : Bool;
  var interpolated : Bool;
  var indentRe : EReg;

  public function new(content : String, source : String, ?interpolated : Bool = false) {
    input = content;
    // normalize BOM
    input = (~/^\uFEFF/).replace(input, "");
    // normalize endlines
    input = (~/\r\n|\n\r|\r/g).replace(input, "\n");
    //input = input.rtrim();

    this.source = source;
    this.interpolated = interpolated;
    lastIndents = 0;
    lineNumber = 1;
    tokens = [];
    indentStack = [];
    pipeless = false;
    indentRe = null;
    ended = false;
  }

  public function getTokens() : Array<Token> {
    while(!ended)
      advance();
    return tokens;
  }

  function blank() {
    var re = ~/^\n *\n/;
    if(re.match(input)) {
      nextLine();
      consume(re.matched(0).length - 1);
      trace('consume blanks');
      if(pipeless) {
        trace('adding TEXT 0: ""');
        tok(TText(""));
      }
      return true;
    }
    return false;
  }

  function className()
    return scan(~/^\.([\w-]+)/, function(reg) {
      trace('adding CLASS: ${reg.matched(1)}');
      return TClassName(reg.matched(1));
    });

  function comment()
    return scan(~/^\/\/(-)?([^\n]*)/, function(reg) {
      if(reg.matched(1) == "-") {
        trace('adding COMMENT INLINE: ${reg.matched(2)}');
        return TCommentInline(reg.matched(2));
      } else {
        pipeless = true;
        trace("adding COMMENT");
        return TComment;
      }
    });

  function doctype()
    return scan(~/^doctype *([^\n]*)/, function(reg) {
      trace('adding DOCTYPE: ${reg.matched(1)}');
      return TDoctype(switch reg.matched(1) {
        case "html": HtmlDoctype;
        case "xml": XmlDoctype;
        case "transitional": XhtmlTransitionalDoctype;
        case "strict": XhtmlStrictDoctype;
        case "frameset": XhtmlFramesetDoctype;
        case "1.1": Xhtml11Doctype;
        case "basic": BasicDoctype;
        case "mobile": MobileDoctype;
        case "": DefaultDoctype;
        case custom: CustomDoctype(custom);
      });
    });

  function eos() {
    if(input.length > 0) return false;
    for(i in 0...indentStack.length) {
      trace("adding OUTDENT");
      tok(TOutdent);
    }
    trace("adding EOS");
    tok(TEos);
    ended = true;
    return true;
  }

  function filter()
    return scan(~/^:([\w\-]+)/, function(reg) {
      pipeless = true;
      trace('adding FILTER: ${reg.matched(1)}');
      return TFilter(reg.matched(1));
    });

  function fail() : Bool {
    return throw new LexerError('unexpected text: "${input.substring(0, 20)}"');
  }

  function expression()
    return scan(new EReg('^${(EXPRESSION_SYMBOL + EXPRESSION_OPEN).escape()}', ''), function(reg) {
      var rest = reg.matchedRight(),
          close = Utils.match(input, EXPRESSION_OPEN, EXPRESSION_CLOSE);
      if(close < 0) throw new LexerError('Unable to find closing sequence $EXPRESSION_CLOSE after ${input.substring(0, 50).replace("\n", "\\n")} ...');
      var code = rest.substring(0, close);
      input = rest.substring(close + EXPRESSION_CLOSE.length);
      trace('adding EXPRESSION: ${code}');
      return TExpression(code);
    });

  function id()
    return scan(~/^#([\w-]+)/, function(reg) {
      trace('adding ID: ${reg.matched(1)}');
      return TId(reg.matched(1));
    });

  function indent() {
    var re = ensureIndentRe();
    if(!re.match(input)) return false;

    var indents = re.matched(1).length;
    nextLine();
    consume(indents + 1); // +1 is for the newline
    var c = input.substring(0, 1);

    if(' ' == c || '\t' == c)
      throw new LexerError('Invalid indentation, you can use tabs or spaces but not both');

    if('\n' == c) {
      pipeless = false;
      tok(TNewline);
      return true;
    }

    // outdent
    if(indentStack.length > 0 && indents < indentStack[0]) {
      while(indentStack.length > 0 && indentStack[0] > indents) {
        trace("adding OUTDENT 2");
        tok(TOutdent);
        indentStack.shift();
      }
    // indent
    } else if(indents > 0 && indents != indentStack[0]) {
      indentStack.unshift(indents);
      trace('adding INDENT: $indents');
      tok(TIndent(indents));
    // newline
    } else {
      trace("adding NEWLINE");
      tok(TNewline);
    }

    pipeless = false;
    return true;
  }

  function pipelessText() {
    if(!pipeless) return false;
    var re = ensureIndentRe();
    re.match(input);

    var indents = re.matched(1).length;

    if(indents > 0 && (indentStack.length == 0 || indents > indentStack[0])) {
      trace("adding PIPELESS START");
      tok(TPipelessStart);
      var indent = re.matched(1);
      var tokens = [];
      var isMatch;
      do {
        // text has `\n` as a prefix
        var i = input.substring(0, 1).indexOf('\n');
        if (-1 == i)
          i = input.length - 1;
        var str = input.substring(1, i+1);
        isMatch = str.substring(0, indent.length) == indent || "" == str.trim();
        if (isMatch) {
          // consume test along with `\n` prefix if match
          consume(str.length + 1);
          tokens.push(str.substring(0, indent.length));
        }
      } while(input.length > 0 && isMatch);
      while (input.length == 0 && tokens[tokens.length - 1] == '') tokens.pop();
      tokens.mapi(function(token, i) {
        nextLine();
        if (i != 0) {
          trace("adding NEWLINE 2");
          tok(TNewline);
        }
        addText(token);
      });
      trace("adding PIPELESS END");
      tok(TPipelessEnd);
      return true;
    }
    return false;
  }

  function tag()
    return scan(~/^(\w(?:[-:\w]*\w)?)(\/?)/, function(reg) {
      var name = reg.matched(1),
          selfClosing = reg.matched(2) == "/";
      trace('adding TAG: $name, $selfClosing');
      return TTag(name, selfClosing);
    });

  function text()
    return
      scan(~/^(?:\| ?| )([^\n]+)/, function(reg) {
        trace('adding TEXT 1: ${reg.matched(1)}');
        addText(reg.matched(1));
        return null;
      }) ||
      scan(~/^\|?( )/, function(reg) {
        trace('adding TEXT 2: ${reg.matched(1)}');
        addText(reg.matched(1));
        return null;
      });

  function textFail()
    return scan(~/^([^\.\n][^\n]+)/, function(reg) {
      //Warning: missing space before text for line $lineNumber in $source
      addText(reg.matched(1));
      return null;
    });

  function textHtml()
    return scan(~/^(<[^\n]*)/, function(reg) {
      trace('adding HTML: ${reg.matched(1)}');
      return TTextHtml(reg.matched(1));
    });

  // utility functions
  function addText(value : String, ?prefix : String = "") {
    if(value + prefix == "") return;

    var indexOfEnd = interpolated ? value.indexOf(EXPRESSION_CLOSE) : -1;
    var indexOfStart = value.indexOf(EXPRESSION_PREFIX);
    var indexOfEscaped = value.indexOf('\\$EXPRESSION_PREFIX');

    if(indexOfEscaped >= 0 && (indexOfEnd == - 1 || indexOfEscaped < indexOfEnd) && (indexOfStart == -1 || indexOfEscaped < indexOfStart)) {
      prefix = prefix + value.substring(0, value.indexOf('\\$EXPRESSION_PREFIX')) + EXPRESSION_PREFIX;
      addText(value.substring(0, value.indexOf('\\$EXPRESSION_PREFIX') + EXPRESSION_PREFIX.length + 1), prefix);
      return;
    }

    if(indexOfStart >= 0 && (indexOfEnd == -1 || indexOfStart < indexOfEnd) && (indexOfEscaped == -1 || indexOfStart < indexOfEscaped)) {
      trace('adding TEXT 3: ${prefix + value.substring(0, indexOfStart)}');
      tok(TText(prefix + value.substring(0, indexOfStart)));
      trace("adding EXPRESSION START");
      tok(TExpressionStart);
      var child = new Lexer(value.substring(0, indexOfStart + 2), source, true);
      var childTokens = child.getTokens();
      for(token in childTokens) {
        tokens.push(token);
        switch token.token {
          case TEos:
            trace("error TEos");
            throw new LexerError('End of line was reached with no closing $EXPRESSION_CLOSE for interpolation.');
          case _:
        }
      }
      trace("adding EXPRESSION END");
      tok(TExpressionEnd);
      addText(child.input);
      return;
    }
    if(indexOfEnd >= 0 && (indexOfStart == -1 || indexOfEnd < indexOfStart) && (indexOfEscaped == -1 || indexOfEnd < indexOfEscaped)) {
      if("" != prefix + value.substring(0, value.indexOf(EXPRESSION_CLOSE))) {
        trace('adding TEXT 4: ${prefix + value.substring(0, value.indexOf(EXPRESSION_CLOSE))}');
        tok(TText(prefix + value.substring(0, value.indexOf(EXPRESSION_CLOSE))));
      }
      this.ended = true;
      this.input = value.substring(0, value.indexOf(EXPRESSION_CLOSE) + EXPRESSION_CLOSE.length) + this.input;
      return;
    }

    trace('adding TEXT 5: ${prefix + value}');
    tok(TText(prefix + value));
  }

  function consume(len : Int)
    input = input.substring(len);

  function ensureIndentRe() {
    if(null == indentRe) {
      var re = ~/^\n(\t*) */,
          matches = re.match(input);
      if(matches && re.matched(1) == "") {
        re = ~/^\n( *)/;
        matches = re.match(input);
      }

      if(matches && re.matched(1) != null && re.matched(1) != "") {
        return indentRe = re;
      }
      return re;
    } else {
      return indentRe;
    }
  }

  function nextLine()
    lineNumber++;

  function tok(token : TToken)
    tokens.push({
      token : token,
      pos : {
        line : lineNumber,
        source : source
      }
    });

  function scan(reg : EReg, f : EReg -> Null<TToken>) : Bool {
    if(!reg.match(input)) return false;
    var v = f(reg);
    if(null != v)
      tok(v);
    input = reg.matchedRight();
    return true;
  }

  function advance()
    return blank()
      || eos()
      || pipelessText()
      || doctype()
      || expression()
      || tag()
      || filter()
      || id()
      || className()
      //|| attrs(true)
      //|| attributesBlock()
      || indent()
      || text()
      || textHtml()
      || comment()
      || textFail()
      || fail();
}
