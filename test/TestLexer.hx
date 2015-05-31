import utest.Assert;

using thx.Arrays;
using thx.Strings;
import jaxe.core.Lexer;
import jaxe.core.Token;
import jaxe.core.Tokens;

class TestLexer {
	public function new() {}

	public function testCases() {
		var cases = loadCases("test/cases/lexer");
		cases.map(function(p) {
			var c : Array<TokenObject> = yaml.Yaml.parse(p.right.content, yaml.Parser.options().useObjects());
			var lexer = new Lexer(p.left.content, p.left.name),
					tokens = lexer.getTokens(),
					obs : Array<TokenObject> = yaml.Yaml.parse(p.right.content, yaml.Parser.options().useObjects()),
					expected = obs.pluck(Tokens.fromObject(_));
			tokens.zip(expected)
				.pluck(Assert.same(_.right.token, _.left.token));
			Assert.equals(expected.length, tokens.length);
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
				expected = t(files, "yaml");
		return cases.zip(expected);
	}
}
