import utest.Assert;
import utest.Runner;
import utest.ui.Report;

class TestAll {
  static function main() {
    var runner = new Runner();

    Report.create(runner);
    runner.run();
  }
}
