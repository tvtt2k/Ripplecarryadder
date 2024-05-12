namespace bats.Tests {
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open bats;

    
    operation TestSubtractor() : Unit {
        // Test case: 3 - 1 = 2
         // 1 in binary
        let a = [0, 1, 0]; // 3 in binary
        let b = [0, 0, 1];//1
        let expected = 1;
        let result = subtractor(a, b);
        Message($"Expected: {expected}, Result: {result}");
        Fact(result == expected, "Not equal to expected value");
  
    }
}