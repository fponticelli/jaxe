package jaxe.core;

@:access(jaxe.core.Lexer)
class Parser {
  var input : String;
  var source : String;
  var lexer : Lexer;
  public function new(content : String, source : String) {
    lexer = new Lexer(content, string);
  }

  public function parse() {
    
  }
}
