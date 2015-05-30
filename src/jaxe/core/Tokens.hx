package jaxe.core;

class Tokens {
	public static function toObject(token : Token) : TokenObject {
		return switch token {
			case TDoctype(HtmlDoctype):
				{ type : "doctype", value : "html" };
			case TDoctype(XmlDoctype):
				{ type : "doctype", value : "xml" };
			case TDoctype(XhtmlTransitionalDoctype):
				{ type : "doctype", value : "transitional" };
			case TDoctype(XhtmlStrictDoctype):
				{ type : "doctype", value : "strict" };
			case TDoctype(XhtmlFramesetDoctype):
				{ type : "doctype", value : "frameset" };
			case TDoctype(Xhtml11Doctype):
				{ type : "doctype", value : "1.1" };
			case TDoctype(BasicDoctype):
				{ type : "doctype", value : "basic" };
			case TDoctype(MobileDoctype):
				{ type : "doctype", value : "mobile" };
			case TDoctype(CustomDoctype(value)):
				{ type : "doctype", value : "custom", attr : value };
			case TOutdent:
				{ type : "outdent" }
			case TEos:
				{ type : "eos" }
		};
	}

	public static function fromObject(token : TokenObject) : Token {
		return switch [token.type, token.value] {
			case ["doctype", "html"]: TDoctype(HtmlDoctype);
			case ["doctype", "xml"]: TDoctype(XmlDoctype);
			case ["doctype", "transitional"]: TDoctype(XhtmlTransitionalDoctype);
			case ["doctype", "strict"]: TDoctype(XhtmlStrictDoctype);
			case ["doctype", "frameset"]: TDoctype(XhtmlFramesetDoctype);
			case ["doctype", "1.1"]: TDoctype(Xhtml11Doctype);
			case ["doctype", "basic"]: TDoctype(BasicDoctype);
			case ["doctype", "mobile"]: TDoctype(MobileDoctype);
			case ["doctype", "custom"]: TDoctype(CustomDoctype(token.attr));
			case ["doctype", unknown]: throw new LexerParseError('unknown doctype $unknown');
			case ["outdent", _]: TOutdent;
			case ["eos", _]: TEos;
			case [type, _]: throw new LexerParseError('unknown object type $type');
		};
	}
}

typedef TokenObject = {
	type : String,
	?value : String,
	?attr : Dynamic
}
