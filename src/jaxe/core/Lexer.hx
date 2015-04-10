package jaxe.core;

import jaxe.core.Token;

class ValueLexer extends hxparse.Lexer implements hxparse.RuleBuilder {
	public static var value = @:rule [
		'[^$]+' => TString(lexer.current, lexer.curPos()),
		'[$][A-Za-z_][A-Za-z0-9_]*' => TExpression(lexer.current.substring(1), lexer.curPos()),
		'[$][{][^}]+[}]' => TExpression(lexer.current.substring(2, lexer.current.length-1), lexer.curPos()),
	];
}
