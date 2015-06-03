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
	TOutdent;
	TNewline;
	TPipelessStart;
	TPipelessEnd;
	TTag(name : String, selfClosing : Bool);
	TText(text : String);
	TTextHtml(html : String);
}

enum Doctype {
	DefaultDoctype;
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
