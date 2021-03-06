import utest.Assert;
using thx.Arrays;
using thx.Functions;
using thx.Strings;
using thx.Tuple;
import jaxe.core.*;
import jaxe.core.Lexer;
import jaxe.core.Token;
import jaxe.core.Tokens;

class TestLexer {
  public function new() {}

  public function testCases() {
    var cases = loadCases("test/cases/lexer");
    cases.map(function(p : TU) {
      var lexer = new Lexer(p.left.content, p.left.name),
          tokens, obs : Array<TokenObject>, expected;
      try {
        obs = yaml.Yaml.parse(p.right.content, yaml.Parser.options().useObjects());
      } catch(e : Dynamic) {
        Assert.fail('failed to parse YAML ${p.right.name} $e');
        return;
      }
      try {
        expected = obs.map.fn(try Tokens.fromObject(_) catch(e : LexerParseError) throw 'Unable to tokenize object: ${e.message}');
      } catch(e : String) {
        Assert.fail('in ${p.left.name} $e');
        return;
      }
      try {
        tokens = lexer.getTokens();
      } catch(e : Dynamic) {
        Assert.fail('failed to parse ${p.left.name}, error: ${e.message.split("\n").join("\\\\n")}');
        return;
      }
      for(t in tokens.zip(expected)) {
        var res = thx.Dynamics.equals(t.right.token, t.left.token);
        Assert.isTrue(res, message(t, p.left.name, expected, tokens));
        if(!res) return;
      }
      Assert.equals(expected.length, tokens.length);
    });
  }

  function message(t, name : String, expected : Array<Token>, test : Array<Token>) {
    return 'in ${name} expected ${expected.map.fn(_.token)} but got ${test.map.fn(_.token)}';
  }

  function loadCases(path : String) : Array<TU> {
    function t(list : Array<String>, ext : String)
      return list
        .filter.fn(_.endsWith('.$ext'))
        .order(Strings.compare)
        .map.fn({
          name : _,
          content : js.node.Fs.readFileSync('$path/$_').toString()
        });

    var files = js.node.Fs.readdirSync(path),
        cases = t(files, "jx"),
        expected = t(files, "yaml");
    return cases.zip(expected);
  }
}

typedef TU = Tuple2<{ content : String, name : String }, { content : String, name : String }>;
