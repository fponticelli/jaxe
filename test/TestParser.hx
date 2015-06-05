import utest.Assert;
using thx.Arrays;
using thx.Strings;
using thx.Tuple;
import jaxe.core.*;
import jaxe.core.Node;
import jaxe.core.Nodes;
import jaxe.core.Parser;
import jaxe.core.Token;
import jaxe.core.Tokens;
import TestLexer;

class TestParser {
	public function new() {}

	public function testCases() {
		var cases = loadCases("test/cases/parser");
		cases.map(function(p : TU) {
			var node, ob : NodeObject, ts : Array<TokenObject>, test, expected;

			try {
				ts = yaml.Yaml.parse(p.left.content, yaml.Parser.options().useObjects());
			} catch(e : Dynamic) {
				Assert.fail('failed to parse test YAML ${p.left.name} $e');
				return;
			}
			try {
				test = try ts.pluck(Tokens.fromObject(_)) catch(e : LexerParseError) throw 'Unable to transform test object: ${e.message}';
			} catch(e : String) {
				Assert.fail('in ${p.left.name} $e');
				return;
			}

			try {
				ob = yaml.Yaml.parse(p.right.content, yaml.Parser.options().useObjects());
			} catch(e : Dynamic) {
				Assert.fail('failed to parse expected YAML ${p.right.name} $e');
				return;
			}
			try {
				expected = try Nodes.fromObject(ob) catch(e : Dynamic) throw 'Unable to transform expected object: ${e.message}';
			} catch(e : String) {
				Assert.fail('in ${p.left.name} $e');
				return;
			}

			var parser = new Parser(test, p.left.name);

			try {
				node = parser.parse();
			} catch(e : Dynamic) {
				Assert.fail('failed to parse ${p.left.name}, error: ${e.message.split("\n").join("\\\\n")}');
				return;
			}
			Assert.same(expected, node);
		});
	}

	function message(t, name : String, expected : Array<Token>, test : Array<Token>) {
		return 'in ${name} expected ${expected.pluck(_.token)} but got ${test.pluck(_.token)}';
	}

	function loadCases(path : String) : Array<TU> {
		function t(list : Array<String>, ext : String)
			return list
				.filterPluck(_.endsWith('.$ext'))
				.order(Strings.compare)
				.pluck({
					name : _,
					content : js.node.Fs.readFileSync('$path/$_').toString()
				});

		var files = js.node.Fs.readdirSync(path),
				cases = t(files, "test.yaml"),
				expected = t(files, "expected.yaml");
		return cases.zip(expected);
	}
}
