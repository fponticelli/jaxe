import utest.Assert;

using thx.Arrays;
using thx.Strings;
import jaxe.core.Lexer;
import jaxe.core.Token;

class TestLexer {
	public function new() {}

	public function testCases() {
		var cases = loadCases("test/cases/lexer");
		cases.map(function(p) {
			var lexer = new Lexer(p.left.content, p.left.name),
					tokens = lexer.getTokens();
		});
	}

	function loadCases(path : String) {
		function t(list : Array<String>, ext : String)
			return list
				.filterPluck(_.endsWith('.$ext'))
				.order(Strings.compare)
				.pluck({
					name : _,
					content : js.node.Fs.readFileSync('$path/$_').toString()
				});

		var files = js.node.Fs.readdirSync(path),
				cases = t(files, "jx"),
				expected = t(files, "json");
		return cases.zip(expected);
	}
}
