from qsharptest import QSharpTest

runner = QSharpTest(namespace='bats.Tests')


def test_e01():
    runner.run('TestSubtractor')

