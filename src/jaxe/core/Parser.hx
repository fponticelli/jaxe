package jaxe.core;

import byte.ByteData;
import jaxe.core.Lexer;
import jaxe.core.Token;

class Parser extends hxparse.Parser<hxparse.LexerTokenSource<DomToken>, DomToken> implements hxparse.ParserBuilder {
	public function new(input : ByteData, source : String) {
		var lexer = new Lexer(input, source);
		var ts = new hxparse.LexerTokenSource(lexer, Lexer.node);
		super(ts);
	}
}
