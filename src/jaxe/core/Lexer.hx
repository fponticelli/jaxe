package jaxe.core;

import jaxe.core.Token;

class Lexer extends hxparse.Lexer implements hxparse.RuleBuilder {

/*
	public static var value = @:rule [
		'[^$]+' => TString(lexer.current, lexer.curPos()),
	  '[$$]' => TString("$", lexer.curPos()),
		'[$][A-Za-z_][A-Za-z0-9_]*' => TExpression(lexer.current.substring(1), lexer.curPos()),
		'[$][{][^}]+[}]' => TExpression(lexer.current.substring(2, lexer.current.length-1), lexer.curPos()),
	];

	public static var node = @:rule [
		// doctype
		'doctype html' => TDoctype(HtmlDoctype),
		'doctype xml' => TDoctype(XmlDoctype),
		'doctype transitional' => TDoctype(XhtmlTransitionalDoctype),
		'doctype strict' => TDoctype(XhtmlStrictDoctype),
		'doctype frameset' => TDoctype(XhtmlFramesetDoctype),
		'doctype 1\\.1' => TDoctype(Xhtml1_1Doctype),
		'doctype basic' => TDoctype(BasicDoctype),
		'doctype mobile' => TDoctype(MobileDoctype),
		'doctype ([^\n]+)' => TDoctype(CustomDoctype(lexer.current)),

		// dom
		'[^.#\\[ ]+' => TElement(lexer.current),
		'\\.[^.#\\[ ]+' => TClass(lexer.current),
		'#[^.#\\[ ]+' => TId(lexer.current),
	];
*/
}
