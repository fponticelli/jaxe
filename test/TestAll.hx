import utest.Runner;

class TestAll {
	static function main() {
		var runner = new Runner();
		utest.ui.Report.create(runner);
		runner.run();
	}
}
