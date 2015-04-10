package jaxe.core;

enum ValueToken {
	TExpression(expr : String, pos : hxparse.Position);
	TString(text : String, pos : hxparse.Position);
}

/*
typedef DomAttribute = {
	name : String,
	value : DomAttributeValue
}

enum DomNode {
	DDoctype(value : String);
	DElement(?name : String, attributes : Array<DomAttribute>, children : Array<DomNode>);
	DComment(comment : DomValue);
	DText(text : DomValue);
}

enum DomValue {
	VExpression(expr : String);
	VString(text : String);
}

enum DomAttributeValue {
	VAExpression(expr : String);
	VAString(text : String);
	VABool(value : Bool);
}
*/
