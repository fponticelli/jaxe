package jaxe.core;

import jaxe.core.Token;

class Lexer {
	var input : String;
	var source : String;
	var lastIndents : Int;
	var lineNumber : Int;
	var ended : Bool;
	var tokens : Array<Token>;
	var indentStack : Array<Int>;
	var pipeless : Bool;

	public function new(content : String, source : String) {
		input = content;
		// normalize BOM
		input = (~/^\uFEFF/).replace(input, "");
		// normalize endlines
		input = (~/\r\n|\n\r|\r/).replace(input, "\n");

		this.source = source;
		lastIndents = 0;
		lineNumber = 1;
		tokens = [];
		indentStack = [];
		pipeless = false;
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

	function id()
		return scan(~/^#([\w-]+)/, function(reg) {
			return TId(reg.matched(1));
		});

	function tag()
		return scan(~/^(\w(?:[-:\w]*\w)?)(\/?)/, function(reg) {
			var name = reg.matched(1),
					selfClosing = reg.matched(2) == "/";
			return TTag(name, selfClosing);
		});

	// utility functions
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
			|| doctype()
			|| tag()
			|| filter()
			|| id()
			|| className()
			|| comment()
			|| fail();
}
