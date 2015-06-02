package jaxe.core;

typedef Token = {
	token : TToken,
	pos : {
		line : Int,
		source : String
	}
}

enum TToken {
	TClassName(name : String);
	TCommentInline(value : String);
	TComment;
	TDoctype(type : Doctype);
	TEos;
	TExpression(code : String);
	TExpressionStart;
	TExpressionEnd;
	TFilter(name : String);
	TId(name : String);
	TIndent(indents : Int);
	TLiteral(text : String);
	TOutdent;
	TNewline;
	TTag(name : String, selfClosing : Bool);
	TTextHtml(html : String);
}

enum Doctype {
	HtmlDoctype;
	XmlDoctype;
	XhtmlTransitionalDoctype;
	XhtmlStrictDoctype;
	XhtmlFramesetDoctype;
	Xhtml11Doctype;
	BasicDoctype;
	MobileDoctype;
	CustomDoctype(value : String);
}
