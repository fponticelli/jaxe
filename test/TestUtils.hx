import utest.Assert;

using thx.Arrays;
import jaxe.core.Utils;

class TestUtils {
	public function new() {}

	public function testMatchOne() [
    { expected : -1, test : "" },
    { expected : -1, test : "abc" },
    { expected :  0, test : "}" },
    { expected :  1, test : " }garbage" },
    { expected :  6, test : "{{{}}}}garbage" },
    { expected :  3, test : "'{'}" },
    { expected :  3, test : "'}'}garbage" },
    { expected :  3, test : '"{"}' },
    { expected :  3, test : '"}"}garbage' },
    { expected :  5, test : '"\\"}"}' },
    { expected :  5, test : "'\\'}'}garbage" },
  ].map(function(t) {
    var m = Utils.match(t.test, "{", "}");
    Assert.equals(t.expected, m, 'expected ${t.test} to match at ${t.expected} but it matches at $m');
  });
}
