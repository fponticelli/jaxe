package tokens;

class Tokens<T> {
  var tokens : Array<T>;
  public function new(tokens : Array<T>) {
    this.tokens = tokens;
  }

  public function lookahead(index : Int) : T {
    if(index >= tokens.length) throw new OutOfBoundaries();
    return null;
  }

  public function peek() : T {
    if(0 == tokens.length) throw new OutOfBoundaries();
    return null;
  }

  public function advance() : T {
    if(0 == tokens.length) throw new OutOfBoundaries();
    return null;
  }

  public function defer(token : T) : Void {

  }
}
