from qsharptest import QSharpTest

runner = QSharpTest(namespace='veg')


def test_e01():
    runner.run('Adder_test_1')

