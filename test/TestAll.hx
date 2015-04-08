import utest.Runner;

class TestAll {
	static function main() {
		var runner = new Runner();

		runner.addCase(new TestDomLexer());

		utest.ui.Report.create(runner);
		runner.run();
	}
}
