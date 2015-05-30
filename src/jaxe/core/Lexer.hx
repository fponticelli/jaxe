package jaxe.core;

import jaxe.core.Token;

class Lexer extends hxparse.Lexer implements hxparse.RuleBuilder {
	public static var doctype = @:rule [
		'doctype html' => HtmlDoctype,
		'doctype xml' => XmlDoctype,
		'doctype transitional' => XhtmlTransitionalDoctype,
		'doctype strict' => XhtmlStrictDoctype,
		'doctype frameset' => XhtmlFramesetDoctype,
		'doctype 1\\.1' => Xhtml11Doctype,
		'doctype basic' => BasicDoctype,
		'doctype mobile' => MobileDoctype,
		'doctype [^\n]+' => CustomDoctype(lexer.current.substring('doctype '.length))
	];

/*
	public static var value = @:rule [
		'[^$]+' => TString(lexer.current, lexer.curPos()),
	  '[$$]' => TString("$", lexer.curPos()),
		'[$][A-Za-z_][A-Za-z0-9_]*' => TExpression(lexer.current.substring(1), lexer.curPos()),
		'[$][{][^}]+[}]' => TExpression(lexer.current.substring(2, lexer.current.length-1), lexer.curPos()),
	];

	public static var node = @:rule [
		// dom
		'[^.#\\[ ]+' => TElement(lexer.current),
		'\\.[^.#\\[ ]+' => TClass(lexer.current),
		'#[^.#\\[ ]+' => TId(lexer.current),
	];
*/
}
