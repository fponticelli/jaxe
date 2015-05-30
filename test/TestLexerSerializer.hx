import utest.Assert;

using thx.Arrays;
import jaxe.core.Lexer;
import jaxe.core.Token;

class TestLexerSerializer {
	public function new() {}

  public function testRoundTrip() {
    // doctypes
    [
      TDoctype(HtmlDoctype),
      TDoctype(XmlDoctype),
      TDoctype(XhtmlTransitionalDoctype),
      TDoctype(XhtmlStrictDoctype),
      TDoctype(XhtmlFramesetDoctype),
      TDoctype(Xhtml11Doctype),
      TDoctype(BasicDoctype),
      TDoctype(MobileDoctype),
      TDoctype(CustomDoctype("html PUBLIC \"-//W3C//DTD XHTML Basic 1.1//EN\"")),
    ].map(assertRoundTrip);
  }

  static function assertRoundTrip(token : Token) {
    var ob = Tokens.toObject(token),
        ntoken = Tokens.fromObject(ob);
    Assert.same(token, ntoken);
  }
}
