import utest.Assert;

using thx.Arrays;
import jaxe.core.Lexer;
import jaxe.core.Token;
import BaseLexer.*;

class TestLexer extends BaseLexer {
	public function testDoctypes() {
		[
			{ _0 : "doctype html", _1 : [HtmlDoctype], _2 : here() },
			{ _0 : "doctype xml", _1 : [XmlDoctype], _2 : here() },
			{ _0 : "doctype transitional", _1 : [XhtmlTransitionalDoctype], _2 : here() },
			{ _0 : "doctype strict", _1 : [XhtmlStrictDoctype], _2 : here() },
			{ _0 : "doctype frameset", _1 : [XhtmlFramesetDoctype], _2 : here() },
			{ _0 : "doctype 1.1", _1 : [Xhtml11Doctype], _2 : here() },
			{ _0 : "doctype basic", _1 : [BasicDoctype], _2 : here() },
			{ _0 : "doctype mobile", _1 : [MobileDoctype], _2 : here() },
			{ _0 : "doctype html PUBLIC \"-//W3C//DTD XHTML Basic 1.1//EN\"", _1 : [CustomDoctype("html PUBLIC \"-//W3C//DTD XHTML Basic 1.1//EN\"")], _2 : here() },
			{ _0 : "some random text", _1 : [], _2 : here() },
		].pluck(assertLexer(Lexer.doctype, _._1, _._0, _._2));
	}
/*
	public function testBasic() {
		var tests = [
			{ test : "text", expected : [TString("text", null)], pos : here() },
			{ test : "$name", expected : [TExpression("name", null)], pos : here() },
			{ test : "the name is $name", expected : [TString("the name is ", null), TExpression("name", null)], pos : here() },
			{ test : "a$b c", expected : [TString("a", null), TExpression("b", null), TString(" c", null)], pos : here() },
			{ test : "a${b}c", expected : [TString("a", null), TExpression("b", null), TString("c", null)], pos : here() },
		];
		for(test in tests)
			assertLexer(null, test.expected, test.test, test.pos);
	}
*/
}
