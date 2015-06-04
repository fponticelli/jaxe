package tokens;

using thx.Arrays;

class Tokens<T> {
  var tokens : Array<T>;
  public function new(tokens : Array<T>)
    this.tokens = tokens;

  /*
  Returns the next item in the stream and advances the stream by one item.
  */
  public function advance() : T {
    if(tokens.isEmpty()) throw new OutOfBoundaries();
    return tokens.shift();
  }

  /*
  Returns true if the stream contains tokens.
  */
  public function canAdvance()
    return !tokens.isEmpty();

  /*
  Put a token on the start of the stream (useful if you need to back track after calling advance.
  */
  public function defer(token : T) : Void
    tokens.unshift(token);

  /*
  Return the item at `index` position from the start of the stream, but don't advance the stream. `stream.lookahead(0)` is equivalent to `stream.peek()`.
  */
  public function lookahead(index : Int) : T {
    if(index >= tokens.length) throw new OutOfBoundaries();
    return tokens[index];
  }

  /*
  Gets and returns the next item in the stream without advancing the stream's position.
  */
  public function peek() : T {
    if(tokens.isEmpty()) throw new OutOfBoundaries();
    return tokens.first();
  }
}
