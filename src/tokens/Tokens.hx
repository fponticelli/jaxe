package tokens;

class Tokens<T> {
  var tokens : Array<T>;
  public function new(tokens : Array<T>) {
    this.tokens = tokens;
  }

  public function lookahead(index : Int) : T {
    if(index >= tokens.length) throw new OutOfBoundaries();
    return tokens[index];
  }

  public function peek() : T {
    if(0 == tokens.length) throw new OutOfBoundaries();
    return tokens[0];
  }

  public function advance() : T {
    if(0 == tokens.length) throw new OutOfBoundaries();
    return tokens.shift();
  }

  public function defer(token : T) : Void {
    tokens.unshift(token);
  }
}
