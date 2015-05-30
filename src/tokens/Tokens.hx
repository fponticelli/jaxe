package tokens;

using thx.Arrays;

class Tokens<T> {
  var tokens : Array<T>;
  public function new(tokens : Array<T>)
    this.tokens = tokens;

  public function advance() : T {
    if(tokens.isEmpty()) throw new OutOfBoundaries();
    return tokens.shift();
  }

  public function canAdvance()
    return !tokens.isEmpty();

  public function defer(token : T) : Void
    tokens.unshift(token);

  public function lookahead(index : Int) : T {
    if(index >= tokens.length) throw new OutOfBoundaries();
    return tokens[index];
  }

  public function peek() : T {
    if(tokens.isEmpty()) throw new OutOfBoundaries();
    return tokens.first();
  }
}
