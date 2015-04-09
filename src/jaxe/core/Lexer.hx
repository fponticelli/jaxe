package jaxe.core;

import jaxe.core.Token;

class ValueLexer extends hxparse.Lexer implements hxparse.RuleBuilder {
	static var keyword = "[A-Za-z_][A-Za-z0-9_]*";
	static var buf : StringBuf;
	public static var value = @:rule [
		'([^$]+)' => VString(lexer.current),
		'\\$($keyword)' => VExpression(lexer.current),
	];
}
