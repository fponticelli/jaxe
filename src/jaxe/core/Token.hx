package jaxe.core;

typedef Token = {
	token : TToken,
	pos : {
		line : Int,
		source : String
	}
}

enum TToken {
	TCommentInline(value : String);
	TComment;
	TDoctype(type : Doctype);
	TEos;
	TOutdent;
	TLiteral(text : String);
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
