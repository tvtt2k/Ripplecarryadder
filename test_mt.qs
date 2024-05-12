  namespace veg{
    open ui;
    open Microsoft.Quantum.Diagnostics;
    open MITRE.QSD.L08;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Unstable.Arithmetic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    operation Adder_test_1() : Unit {
        //let a = [1,1,1,1,1,1]; // Represents the binary number 63 (1 in decimal)
        //let b = [1,1,1,1,1,1]; // Represents the binary number 63 (3 in decimal)
        let a = [0,1,1];
        let b = [0,0,1];
        let expected = 4; // The sum of 1 + 3 is 4

        let result = Adder(a, b);
        // pass if result is equal to expected
        // else fail with a message using fact
        
        Fact(result==expected,
            "Not equal to expected value"
        );
        // Fact(result == expected, 
        }
    } // Add a closing curly brace here
  