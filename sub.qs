namespace bats {

    open Microsoft.Quantum.Diagnostics;
    open ui;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Unstable.Arithmetic;    
    operation subtractor(a : Int[], b : Int[]): Int{
        let n = Length(a);
        use a_q = Qubit[n];
        use b_q = Qubit[n];
        use carry = Qubit[n+1];
        use sum = Qubit[n+1];

        Message($"MSB {a} LSB");
        
    

        // read from right to left with right as LSB from a
        for i in 0..n-1 {
            // get proper reverse index starting with LSB
            let index = n - i - 1;
            if (a[index] == 1) {
                X(a_q[i]);
            }
            // if (b[index] == 0) {
            //     X(b_q[i]);
            // }
        }
        //complement b
        let n = Length(b);
        mutable b_complement =  [0, size = n];
        for i in 0..n-1 {
        set b_complement w/= i <- 1 - b[i];
        }
        //add 1 to b_complement 
        
        mutable carry_bcomp = 1;
        mutable carry_bcomp = 1;
        for i in Length(b_complement)-1..-1..0 {
        let sum = b_complement[i] + carry_bcomp;
        set b_complement w/= i <- sum % 2;
        set carry_bcomp = sum / 2;
        }
        
        // encode into qubits
        // read from right to left with right as LSB from a
        //Encoding B
        for i in 0..n-1 {
            // get proper reverse index starting with LSB
            let index = n - i - 1;
            if (b_complement[index] == 1) {
                X(b_q[i]);
            }
        }
        for i in 0..n-1{
            let a_val = M(a_q[i]);            
            let b_val = M(b_q[i]);
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
        }
        // convert a and b to int
        let a_int = BinaryArrayToInt(a);
        let b_int = BinaryArrayToInt(b);
        Message($"{sum} sum here should be {a_int} + {b_int} = {a_int + b_int}");

        for i in 0..n-1 {
            let carry_val = M(carry[i]);
            Message($"carry[{i}] = {carry_val}");
        }        
        let carry_val = M(carry[n-1]);

        let res = MeasureInteger((sum));
        Message($"Sum: {res}");
        DumpMachine();
        ResetAll(a_q);
        ResetAll(b_q);
        ResetAll(carry);
        ResetAll(sum);
        return res;
    }

    operation BinarrInt(binaryArray : Int[]) : Int {
        mutable result = 0;
        let n = Length(binaryArray);
        for i in 0..n-1 {
            set result += binaryArray[i] * 2^(n - 1 - i);
        }
        return result;
        
    }
    
}

