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
	TFilter(name : String);
	TId(name : String);
	TOutdent;
	TLiteral(text : String);
	TTag(name : String, selfClosing : Bool);
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
