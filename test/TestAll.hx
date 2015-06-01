import utest.Runner;

class TestAll {
	static function main() {
		var runner = new Runner();

		runner.addCase(new TestLexer());
		runner.addCase(new TestLexerSerializer());
		runner.addCase(new TestUtils());

		utest.ui.Report.create(runner);
		runner.run();
	}
}
