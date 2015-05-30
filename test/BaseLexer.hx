import utest.Assert;

import jaxe.core.Lexer;
import jaxe.core.Token;
import hxparse.Ruleset;

class BaseLexer {
	public function new() { }

	function assertLexer<T>(ruleset : Ruleset<T>, expected : Array<T>, test : String, ?pos : haxe.PosInfos) {
		var data = byte.ByteData.ofString(test);
		var lexer = new Lexer(data, '${pos.className}.${pos.methodName}');
		var tokens = [];
		try while (true) {
			var t = lexer.token(ruleset);
			tokens.push(t);
		} catch (e:Dynamic) {
			trace(e);
		}
		Assert.equals(expected.length, tokens.length, "number of expressions do not match for $expected and $tests", pos);
		for(i in 0...expected.length) {
			Assert.same(expected[i], tokens[i], pos);
		}
	}

/*
	function assertSameValueToken<T>(a : T, b : T, ?pos : haxe.PosInfos) {
		switch [a, b] {
			case [TString(sa, _), TString(sb, _)]:
				Assert.equals(sa, sb, pos);
			case [TExpression(sa, _), TExpression(sb, _)]:
				Assert.equals(sa, sb, pos);
			case [_, _]:
				Assert.fail('$a doesn\'t match $b', pos);
		}
	}
*/
	public inline static function here(?pos : haxe.PosInfos) return pos;
}
