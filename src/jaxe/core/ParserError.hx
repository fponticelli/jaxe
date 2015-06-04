package jaxe.core;

import thx.Error;

class ParserError extends Error {
  public function new(message : String, ?pos : haxe.PosInfos) {
    super(message, pos);
  }
}
