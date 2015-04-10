import utest.Runner;

class TestAll {
	static function main() {
		var runner = new Runner();

		runner.addCase(new TestLexer());
		runner.addCase(new TestParser());

		utest.ui.Report.create(runner);
		runner.run();
	}
}
