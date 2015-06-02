import utest.Assert;

using thx.Arrays;
import jaxe.core.Token;
import jaxe.core.Tokens;

class TestLexerSerializer {
	public function new() {}

	public function testComments() [
		TComment,
		TCommentInline("my comment"),
	].map(assertRoundTrip);

	public function testContents() [
		TExpression("var a = 1;"),
		TExpressionStart,
		TExpressionEnd,
		TFilter("fname"),
		TPipelessStart,
		TPipelessEnd,
		TTag("tagname", true),
		TText("some"),
		TTextHtml("<br/>"),
	].map(assertRoundTrip);

  public function testDoctypes() [
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

  public function testUtils() [
    TOutdent,
		TIndent(3),
		TNewline,
    TEos
  ].map(assertRoundTrip);

  static function assertRoundTrip(ttoken : TToken) {
    var token = { token : ttoken, pos : {line : 1, source : "test"} },
        ob = Tokens.toObject(token),
        ntoken = Tokens.fromObject(ob);
    Assert.same(token, ntoken);
  }
}
