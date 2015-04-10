import utest.Assert;

import jaxe.core.Lexer;
import jaxe.core.Token;

class TestLexer {
	public function new() { }

	public function testBasic() {
		var tests = [
			{ test : "text", expected : [VString("text")] },
			{ test : "$name", expected : [VExpression("name")] },
			{ test : "the name is $name", expected : [VString("the name is "), VExpression("name")] },
			{ test : "a$b c", expected : [VString("a"), VExpression("b"), VString(" c")] },
			{ test : "a${b}c", expected : [VString("a"), VExpression("b"), VString("c")] },
		];

		for(test in tests)
			assertValueLexer(test.expected, test.test);
	}

	function assertValueLexer(expected : Array<ValueToken>, test : String, ?pos : haxe.PosInfos) {
		var data = byte.ByteData.ofString(test);
		var lexer = new ValueLexer(data, "test");
		var tokens = [];
		try while (true) {
			var t = lexer.token(ValueLexer.value);
			trace(t);
			tokens.push(t);
		} catch (e:Dynamic) { }
		Assert.same(expected, tokens, 'expected $test to parse to $expected but it is $tokens', pos);
	}
}
