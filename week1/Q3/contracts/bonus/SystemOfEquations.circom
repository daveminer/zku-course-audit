pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
//include "../../node_modules/circomlib-matrix/circuits/matElemMul.circom";
//include "../../node_modules/circomlib-matrix/circuits/matElemSum.circom"; // hint: you can use more than one templates in circomlib-matrix to help you

// x=15, y=17, z=19.
// x + y + z = 51
// x + 2y + 3z = 106
// 2x - y + z = 32

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    //signal terms[n];
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // Multiply the constants by the coefficients
    //component mul = matElemMul(1,n);
    // Solve the system
    //component sum = matElemSum(1,n);

    //log("A[i] is:", A[0][0]);

    // [bonus] insert your code here
    // for (var i=0; i<n; i++) {
    //     log("A[i] is:", A[i]);
    //     // 1 x 3
    //     mul.a = A[i];
    //     mul.b = b[i];

    //     // 1 x 3
    //     sum.a = mul.out;

    //     x[i] === sum.out;
    // }

    // TODO: count total
}

component main {public [A, b]} = SystemOfEquations(3);
