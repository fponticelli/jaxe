package jaxe.core;

typedef Token = {
	token : TToken,
	pos : {
		line : Int,
		source : String
	}
}

enum TToken {
	TDoctype(type : Doctype);
	TEos;
	TOutdent;
	TCommentInline(value : String);
	TComment;
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
