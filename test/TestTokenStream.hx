import utest.Assert;
import utest.Runner;
import utest.ui.Report;

import jaxe.core.*;

class TestTokenStream {
  public function new() {}

  public function testTokens() {
    var stream = new TokenStream(['a', 'b', 'c', 'd']);
    Assert.raises(function() stream.lookahead(9), OutOfBoundaries);

    Assert.isTrue(stream.canAdvance());

    Assert.equals('a', stream.peek());
    Assert.equals('a', stream.lookahead(0));
    Assert.equals('b', stream.lookahead(1));

    Assert.equals('a', stream.advance());
    Assert.equals('b', stream.peek());
    Assert.equals('b', stream.lookahead(0));
    Assert.equals('c', stream.lookahead(1));

    stream.defer('z');
    Assert.equals('z', stream.peek());
    Assert.equals('z', stream.lookahead(0));
    Assert.equals('b', stream.lookahead(1));
    Assert.equals('z', stream.advance());
    Assert.equals('b', stream.advance());
    Assert.equals('c', stream.advance());
    Assert.equals('d', stream.advance());

    Assert.isFalse(stream.canAdvance());
    Assert.raises(function() stream.peek(), OutOfBoundaries);
    Assert.raises(function() stream.lookahead(0), OutOfBoundaries);
    Assert.raises(function() stream.lookahead(1), OutOfBoundaries);
    Assert.raises(function() stream.advance(), OutOfBoundaries);
  }
}
