package jaxe.core;

import jaxe.core.Token;

class Lexer {
	var input : String;
	var source : String;
	var lastIndents : Int;
	var lineNumber : Int;
	var ended : Bool;
	var tokens : Array<Token>;

	public function new(content : String, source : String) {
		input = content;
		// normalize BOM
		input = (~/^\uFEFF/).replace(input, "");
		// normalize endlines
		input = (~/\r\n|\n\r|\r/).replace(input, "\n");

		this.source = source;
		lastIndents = 0;
		lineNumber = 1;
	}

	function getTokens() {
		while(!ended)
			advance();
		return tokens;
	}

	function blank()
		return false;

	function eos()
		return false;

	function fail() : Bool
		return throw new LexerError('unexpected text: ${input.split("\n").shift()}');

	function advance()
		return blank()
			|| eos()
			|| fail();
}
