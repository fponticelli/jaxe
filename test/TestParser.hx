import utest.Assert;

import jaxe.core.Lexer;
import jaxe.core.Parser;
import jaxe.core.Token;

class TestParser {
	public function new() { }

	public function testBasic() {
		var data = byte.ByteData.ofString("div#main");
		var parser = new Parser(data, "test");
		parser.parse();
	}
}
