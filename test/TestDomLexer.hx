import utest.Assert;

import jaxe.core.DomLexer;

class TestDomLexer {
	public function new() { }

	public function testBasic() {
		var data = byte.ByteData.ofString("div.star");
		var lexer = new DomLexer(data);
		lexer.token(DomLexer.dom);
	}
}
