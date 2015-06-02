package jaxe.core;

import jaxe.core.Token;
using thx.ERegs;

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
		input = (~/\r\n|\n\r|\r/).replace(input, "\n");

		this.source = source;
		this.interpolated = interpolated;
		lastIndents = 0;
		lineNumber = 1;
		tokens = [];
		indentStack = [];
		pipeless = false;
		indentRe = null;
	}

	public function getTokens() {
		while(!ended)
			advance();
		return tokens;
	}

	function blank()
		return scan(~/^\n( *)$/, function(reg) {
			nextLine();
			return pipeless ? TLiteral(reg.matched(1)) : null;
		});

	function className()
		return scan(~/^\.([\w-]+)/, function(reg) {
			return TClassName(reg.matched(1));
		});

	function comment()
		return scan(~/^\/\/(-)?([^\n]*)/, function(reg) {
			if(reg.matched(1) == "-")
				return TCommentInline(reg.matched(2));
			else {
				pipeless = true;
				return TComment;
			}
		});

	function doctype()
		return scan(~/^doctype +([^\n]+)?/, function(reg) {
			return TDoctype(switch reg.matched(1) {
				case "html": HtmlDoctype;
				case "xml": XmlDoctype;
				case "transitional": XhtmlTransitionalDoctype;
				case "strict": XhtmlStrictDoctype;
				case "frameset": XhtmlFramesetDoctype;
				case "1.1": Xhtml11Doctype;
				case "basic": BasicDoctype;
				case "mobile": MobileDoctype;
				case custom: CustomDoctype(custom);
			});
		});

	function eos() {
		if(input.length > 0) return false;
		for(i in 0...indentStack.length)
			tok(TOutdent);
		tok(TEos);
		ended = true;
		return true;
	}

	function filter()
		return scan(~/^:([\w\-]+)/, function(reg) {
			pipeless = true;
			return TFilter(reg.matched(1));
		});

	function fail() : Bool
		return throw new LexerError('unexpected text: ${input.split("\n").shift()}');

	function expression()
		return scan(new EReg('^${(EXPRESSION_SYMBOL + EXPRESSION_OPEN).escape()}', ''), function(reg) {
			var rest = reg.matchedRight(),
					close = Utils.match(input, EXPRESSION_OPEN, EXPRESSION_CLOSE);
			if(close < 0) throw new LexerError('Unable to find closing sequence $EXPRESSION_CLOSE after ${input.substring(0, 20)} ...');
			var code = rest.substring(0, close);
			input = rest.substring(close + EXPRESSION_CLOSE.length);
			return TExpression(code);
		});

	function id()
		return scan(~/^#([\w-]+)/, function(reg) {
			return TId(reg.matched(1));
		});

	function indent() {
		if(null == indentRe) {
			var re = ~/^\n(\t*) */,
					matches = re.match(input);
			if(matches && (re.matched(1) == null || re.matched(1) == "")) { // TODO check which one is correct
				re = ~/^\n( *)/;
				matches = re.match(input);
			}

			if(matches && re.matched(1) != null && re.matched(1) != "") { // TODO check which one is correct
				indentRe = re;
			}
		}

		if(null == indentRe || !indentRe.match(input)) return false;
		var indents = indentRe.matched(1).length;
		nextLine();
		consume(indents + 1);
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
				tok(TOutdent);
				indentStack.shift();
			}
		// indent
		} else if(indents > 0 && indents != indentStack[0]) {
			indentStack.unshift(indents);
			tok(TIndent(indents));
		// newline
		} else {
			tok(TNewline);
		}


		pipeless = false;
		return true;
	}

	function tag()
		return scan(~/^(\w(?:[-:\w]*\w)?)(\/?)/, function(reg) {
			var name = reg.matched(1),
					selfClosing = reg.matched(2) == "/";
			return TTag(name, selfClosing);
		});

	function textHtml()
		return scan(~/^(<.*$)/, function(reg) {
			return TTextHtml(reg.matched(1));
		});

	// utility functions
	function addText(value : String, ?prefix : String = "") {
		if(value + prefix == "") return;

		var indexOfEnd = interpolated ? value.indexOf(EXPRESSION_CLOSE) : -1;
    var indexOfStart = value.indexOf(EXPRESSION_PREFIX);
    var indexOfEscaped = value.indexOf('\\$EXPRESSION_PREFIX');

		if(indexOfEscaped >= 0 && (indexOfEnd == - 1 || indexOfEscaped < indexOfEnd) && (indexOfStart == -1 || indexOfEscaped < indexOfStart)) {
			prefix = prefix + value.substr(0, value.indexOf('\\$EXPRESSION_PREFIX')) + EXPRESSION_PREFIX;
		  addText(value.substr(value.indexOf('\\$EXPRESSION_PREFIX') + EXPRESSION_PREFIX.length + 1), prefix);
			return;
		}

    if(indexOfStart >= 0 && (indexOfEnd == -1 || indexOfStart < indexOfEnd) && (indexOfEscaped == -1 || indexOfStart < indexOfEscaped)) {
			tok(TText(prefix + value.substr(0, indexOfStart)));
			tok(TExpressionStart);
      var child = new Lexer(value.substr(indexOfStart + 2), source, true);
      var interpolated = child.getTokens();
			for(token in interpolated) {
        tokens.push(token);
        switch token.token {
					case TEos:
						throw new LexerError('End of line was reached with no closing $EXPRESSION_CLOSE for interpolation.');
					case _:
        }
      }
			tok(TExpressionEnd);
      addText(child.input);
      return;
    }
    if(indexOfEnd >= 0 && (indexOfStart == -1 || indexOfEnd < indexOfStart) && (indexOfEscaped == -1 || indexOfEnd < indexOfEscaped)) {
      if("" != prefix + value.substr(0, value.indexOf(EXPRESSION_CLOSE))) {
				tok(TText(prefix + value.substr(0, value.indexOf(EXPRESSION_CLOSE))));
      }
      this.ended = true;
      this.input = value.substr(value.indexOf(EXPRESSION_CLOSE) + EXPRESSION_CLOSE.length) + this.input;
      return;
    }

    tok(TText(prefix + value));
	}

	function consume(len : Int)
		input = input.substring(len);

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
			//|| pipelessText()
			|| doctype()
			|| expression()
			|| tag()
			|| filter()
			|| id()
			|| className()
			//|| attrs(true)
			//|| attributesBlock()
			|| indent()
			//|| text()
			|| textHtml()
			|| comment()
			//|| textFail()
			|| fail();
}
