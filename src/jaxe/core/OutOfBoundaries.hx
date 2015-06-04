package jaxe.core;

class OutOfBoundaries extends thx.Error {
  public function new()
    super("Cannot read past the end of a token stream");
}
