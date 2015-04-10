package jaxe.core;

enum ValueToken {
	TExpression(expr : String, pos : hxparse.Position);
	TString(text : String, pos : hxparse.Position);
}

enum DomToken {
	TDoctype(type : Doctype);
	TElement(name : String);
	TClass(name : String);
	TId(name : String);
}

enum Doctype {
	HtmlDoctype;
	XmlDoctype;
	XhtmlTransitionalDoctype;
	XhtmlStrictDoctype;
	XhtmlFramesetDoctype;
	Xhtml1_1Doctype;
	BasicDoctype;
	MobileDoctype;
	CustomDoctype(value : String);
}
