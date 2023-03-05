pragma circom 2.0.0;

// [assignment] Modify the circuit below to perform a multiplication of three signals

template Multiplier3 () {

   // Declaration of signals.
   signal input a;
   signal input b;
   signal input c;
   signal ab;
   signal output d;

   // Part 2, #3
   // Modify Multiplier3.circom to perform a multiplication of
   // hree input signals under the restrictions of circom.
   ab <-- a * b;

   // Constraints.
   d <== ab * c;
}

component main = Multiplier3();
