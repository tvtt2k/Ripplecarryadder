namespace ui {

    open Microsoft.Quantum.Diagnostics;
    open MITRE.QSD.L08;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Unstable.Arithmetic;
    
    operation Adder(a : Int[], b : Int[]) : Int {
        // TODO
        let n = Length(a);
        use a_q = Qubit[n];
        use b_q = Qubit[n];
        use carry = Qubit[n+1];
        use sum = Qubit[n+1];

        Message($"a is {a}");
        Message($"b is {b}");
        
        // encode into qubits
        // read from right to left with right as LSB from a
        for i in 0..n-1 {
            // get proper reverse index starting with LSB
            let index = n - i - 1;
            if (a[index] == 1) {
                X(a_q[i]);
            }
            if (b[index] == 1) {
                X(b_q[i]);
            }

        }
        for i in 0..n-1{
            let a_val = M(a_q[i]);            
            let b_val = M(b_q[i]);
            Message($"a_q[{i}] = {a_val}");
            Message($"b_q[{i}] = {b_val}");
        }

        CNOT(b_q[0], sum[0]);
        CNOT(a_q[0], sum[0]);
        CCNOT(a_q[0], b_q[0], carry[0]);


        for i in 1..n-1 {
            CNOT(b_q[i], sum[i]);
            CNOT(a_q[i], sum[i]);
            CCNOT(a_q[i], b_q[i], carry[i]);
            CCNOT(carry[i-1], sum[i], carry[i]);
            CNOT(carry[i-1], sum[i]);
        }
        CNOT(carry[n-1], carry[n]);

        //check carry
        for i in 0..n-1 {
            let carry_val = M(carry[i]);
            Message($"carry[{i}] = {carry_val}");
        }
        // convert a and b to int
        let a_int = BinaryArrayToInt(a);
        let b_int = BinaryArrayToInt(b);
        Message($"{sum} sum here should be {a_int} + {b_int} = {a_int + b_int}");
        
        // Add carry to sum in the form of 2^carry[n+1]
 
        // if(M(carry[n]) == One){
        //     X(carry[n]);
        //     let val1 = MeasureInteger(carry);
        //     let val2 = MeasureInteger(sum);
        //     let final = val1 + val2;
        //     ResetAll(carry);
        //     ResetAll(sum);
        //     return final;
        // }
        // I only want to measure the last qubit of carry 
        // let lastCarryMeasurement = M(carry[Length(carry) - 1]);
        // let h1 = MeasureInteger(carry);
        // let lastCarry = lastCarryMeasurement == One ? 1 | 0;
        // let res = MeasureInteger((sum));
        // if(lastCarry==1){
        //     let final = res + h1;
        //     return final;
        // }
        let res = MeasureInteger((sum));
        Message($"Sum: {res}");
        DumpMachine();
        ResetAll(a_q);
        ResetAll(b_q);
        ResetAll(carry);
        ResetAll(sum);
        return res;
    }

    operation BinaryArrayToInt(binaryArray : Int[]) : Int {
        mutable result = 0;
        let n = Length(binaryArray);
        for i in 0..n-1 {
            set result += binaryArray[i] * 2^(n - 1 - i);
        }
        return result;
    }

}