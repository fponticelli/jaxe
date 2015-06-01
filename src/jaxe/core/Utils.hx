package jaxe.core;

class Utils {
  public static function match(subject : String, open : String, close : String) {
    var count = 1,
        inSingleQuotes = false,
        inDoubleQuotes = false,
        i = 0,
        leno = open.length,
        lenc = close.length,
        length = subject.length,
        t;

    trace('match $subject');
    while(i < length) {
      trace('$i: $count');
      t = subject.substring(i, i+2);
      if(
        (inDoubleQuotes && t == '\\"') ||
        (inSingleQuotes && t == "\\'")
      ) {
        trace("escaped");
        i += 2;
        continue;
      }

      t = subject.substring(i, i+1);
      if(t == '"' && inDoubleQuotes) {
        trace("close double quotes");
        inDoubleQuotes = false;
        i++;
        continue;
      }

      if(t == "'" && inSingleQuotes) {
        trace("close single quotes");
        inSingleQuotes = false;
        i++;
        continue;
      }

      if(t == '"' && !inSingleQuotes) {
        trace("inDoubleQuotes");
        inDoubleQuotes = true;
        i++;
        continue;
      }

      if(t == "'" && !inDoubleQuotes) {
        trace("inSingleQuotes");
        inSingleQuotes = true;
        i++;
        continue;
      }

      if(inDoubleQuotes || inSingleQuotes) {
        trace("in quotes, skip");
        i++;
        continue;
      }

      t = subject.substring(i, i+leno);
      if(t == open) {
        count++;
        trace('increment to $count');
        i += leno;
        continue;
      }

      t = subject.substring(i, i+lenc);
      if(t == close) {
        count--;
        trace('decrement to $count');
        if(count == 0)
          return i;
        i += lenc;
        continue;
      }
      trace("next please");
      i++;
    }
    return -1;
  }
}
