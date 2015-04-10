package jaxe.core;

import jaxe.core.Token;

class ValueLexer extends hxparse.Lexer implements hxparse.RuleBuilder {
	public static var value = @:rule [
		'[^$]+' => VString(lexer.current),
		'[$][A-Za-z_][A-Za-z0-9_]*' => VExpression(lexer.current.substring(1)),
		'[$][{][^}]+[}]' => VExpression(lexer.current.substring(2, lexer.current.length-1)),
	];
}
