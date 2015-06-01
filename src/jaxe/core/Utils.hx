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

    while(i < length) {
      t = subject.substring(i, i+2);
      if(
        (inDoubleQuotes && t == '\\"') ||
        (inSingleQuotes && t == "\\'")
      ) {
        i += 2;
        continue;
      }

      t = subject.substring(i, i+1);
      if(t == '"' && inDoubleQuotes) {
        inDoubleQuotes = false;
        i++;
        continue;
      }

      if(t == "'" && inSingleQuotes) {
        inSingleQuotes = false;
        i++;
        continue;
      }

      if(t == '"' && !inSingleQuotes) {
        inDoubleQuotes = true;
        i++;
        continue;
      }

      if(t == "'" && !inDoubleQuotes) {
        inSingleQuotes = true;
        i++;
        continue;
      }

      if(inDoubleQuotes || inSingleQuotes) {
        i++;
        continue;
      }

      t = subject.substring(i, i+leno);
      if(t == open) {
        count++;
        i += leno;
        continue;
      }

      t = subject.substring(i, i+lenc);
      if(t == close) {
        count--;
        if(count == 0)
          return i;
        i += lenc;
        continue;
      }
      i++;
    }
    return -1;
  }
}
