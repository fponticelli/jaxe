package jaxe.core;

import jaxe.core.Token;

class Tokens {
	public static function toObject(token : Token) : TokenObject {
		return switch token.token {
			case TComment:
				{ type : "comment", pos : token.pos }
			case TCommentInline(content):
				{ type : "comment-inline", value : content, pos : token.pos }
			case TDoctype(HtmlDoctype):
				{ type : "doctype", value : "html", pos : token.pos };
			case TDoctype(XmlDoctype):
				{ type : "doctype", value : "xml", pos : token.pos };
			case TDoctype(XhtmlTransitionalDoctype):
				{ type : "doctype", value : "transitional", pos : token.pos };
			case TDoctype(XhtmlStrictDoctype):
				{ type : "doctype", value : "strict", pos : token.pos };
			case TDoctype(XhtmlFramesetDoctype):
				{ type : "doctype", value : "frameset", pos : token.pos };
			case TDoctype(Xhtml11Doctype):
				{ type : "doctype", value : "1.1", pos : token.pos };
			case TDoctype(BasicDoctype):
				{ type : "doctype", value : "basic", pos : token.pos };
			case TDoctype(MobileDoctype):
				{ type : "doctype", value : "mobile", pos : token.pos };
			case TDoctype(CustomDoctype(value)):
				{ type : "doctype", value : "custom", attr : { type : value }, pos : token.pos };
			case TEos:
				{ type : "eos", pos : token.pos }
			case TFilter(name):
				{ type : "filter", value : name, pos : token.pos }
			case TLiteral(text):
				{ type : "literal", value : text, pos : token.pos }
			case TOutdent:
				{ type : "outdent", pos : token.pos }
			case TTag(name, selfClosing):
				{ type : "tag", value : name, attr : { selfClosing : selfClosing }, pos : token.pos }
		};
	}

	public static function fromObject(token : TokenObject) : Token {
		var t = switch [token.type, token.value] {
			case ["comment", _]: TComment;
			case ["comment-inline", content]: TCommentInline(content);
			case ["doctype", "html"]: TDoctype(HtmlDoctype);
			case ["doctype", "xml"]: TDoctype(XmlDoctype);
			case ["doctype", "transitional"]: TDoctype(XhtmlTransitionalDoctype);
			case ["doctype", "strict"]: TDoctype(XhtmlStrictDoctype);
			case ["doctype", "frameset"]: TDoctype(XhtmlFramesetDoctype);
			case ["doctype", "1.1"]: TDoctype(Xhtml11Doctype);
			case ["doctype", "basic"]: TDoctype(BasicDoctype);
			case ["doctype", "mobile"]: TDoctype(MobileDoctype);
			case ["doctype", "custom"]: TDoctype(CustomDoctype(token.attr.type));
			case ["doctype", unknown]: throw new LexerParseError('unknown doctype $unknown');
			case ["eos", _]: TEos;
			case ["filter", name]: TFilter(name);
			case ["literal", text]: TLiteral(text);
			case ["outdent", _]: TOutdent;
			case ["tag", name]: TTag(name, token.attr.selfClosing);
			case [type, _]: throw new LexerParseError('unknown object type $type');
		};
		return {
			token : t,
			pos : token.pos
		};
	}
}

typedef TokenObject = {
	type : String,
	?value : String,
	?attr : Dynamic,
	pos : {
		line : Int,
		source : String
	}
}
