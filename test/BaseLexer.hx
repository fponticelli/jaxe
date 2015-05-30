import utest.Assert;

import jaxe.core.Lexer;
import jaxe.core.Token;

class BaseLexer {
	public function new() { }

/*
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
*/
	public inline static function here(?pos : haxe.PosInfos) return pos;
}
