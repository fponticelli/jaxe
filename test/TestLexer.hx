import utest.Assert;

import jaxe.core.Lexer;
import jaxe.core.Token;

class TestLexer {
	public function new() { }

	public function testBasic() {
		assertValueLexer([VString("text")], "text");
		assertValueLexer([VExpression("name")], "$name");
		assertValueLexer([VString("the name is "), VExpression("name")], "the name is $name");
	}

	function assertValueLexer(expected : Array<ValueToken>, test : String, ?pos : haxe.PosInfos) {
		var data = byte.ByteData.ofString(test);
		var lexer = new ValueLexer(data, "test");
		var tokens = [];
		try while (true) {
			tokens.push(lexer.token(ValueLexer.value));
		} catch (e:Dynamic) { }
		Assert.same(expected, tokens, 'expected $test to parse to $expected but it is $tokens', pos);
	}
}
