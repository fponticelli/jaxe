import utest.Assert;

import jaxe.core.Lexer;
import jaxe.core.Token;

class TestLexer {
	public function new() { }

	public function testBasic() {
		var tests = [
			{ test : "text", expected : [TString("text", null)] },
			{ test : "$name", expected : [TExpression("name", null)] },
			{ test : "the name is $name", expected : [TString("the name is ", null), TExpression("name", null)] },
			{ test : "a$b c", expected : [TString("a", null), TExpression("b", null), TString(" c", null)] },
			{ test : "a${b}c", expected : [TString("a", null), TExpression("b", null), TString("c", null)] },
		];

		for(test in tests)
			assertLexer(test.expected, test.test);
	}

	function assertLexer(expected : Array<ValueToken>, test : String, ?pos : haxe.PosInfos) {
		var data = byte.ByteData.ofString(test);
		var lexer = new Lexer(data, "test");
		var tokens = [];
		try while (true) {
			var t = lexer.token(Lexer.value);
			tokens.push(t);
		} catch (e:Dynamic) { }
		Assert.equals(expected.length, tokens.length, "number of expressions do not match for $expected and $tests");
		for(i in 0...expected.length) {
			assertSameValueToken(expected[i], tokens[i]);
		}
	}

	function assertSameValueToken(a, b) {
		switch [a, b] {
			case [TString(sa, _), TString(sb, _)]:
				Assert.equals(sa, sb);
			case [TExpression(sa, _), TExpression(sb, _)]:
				Assert.equals(sa, sb);
			case [_, _]:
				Assert.fail('$a doesn\'t match $b');
		}
	}
}
