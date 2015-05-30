package jaxe.core;

import byte.ByteData;
import jaxe.core.Lexer;
import jaxe.core.Token;

/*
class Parser extends hxparse.Parser<hxparse.LexerTokenSource<DomToken>, DomToken> implements hxparse.ParserBuilder {
	public function new(input : ByteData, source : String) {
		var lexer = new Lexer(input, source);
		var ts = new hxparse.LexerTokenSource(lexer, Lexer.node);
		super(ts);
	}

	var nodes : Array<Node> = [];
	var chain : Array<Node> = [];
	var current : Node;
	var indent : Int = 0;

	public function parse() {
		switch stream {
			case [TIndent(level)]:
				if(level > indent + 1) throw 'Invalid indentation';
				indent = level;
				current = null;
			case [TElement(name)]:
				if(indent == 0)
					ensureNode();
				current.name = name;
			case [TEof]: return nodes;
		}
	}

	function ensureNode() {
		if(null != current)
			return;
		current = {};
		if(indent == 0)
			nodes.push(current);
		chain.push(current);
	}
}

typedef Node = {
	?name : String,
	?id : String,
	?cls : String,
	children : Array<Node>
};
*/
