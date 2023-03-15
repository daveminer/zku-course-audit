pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

template CheckRoot(n) { // compute the root of a MerkleTree of n Levels
    signal input leaves[2**n];
    signal output root;

    //[assignment] insert your code here to calculate the Merkle root from 2^n leaves
    component p[2**n];
    signal tree[2**n];

    if (n == 0) {
        root <== leaves[0];
    } else if (n == 1) {
        p[0] = Poseidon(2);
        p.inputs[0] <== leaves[0];
        p.inputs[1] <== leaves[1];
        root <== p.out;
    } else {
        var pcount = 0; // postincrement counter
        for(var i = 0; i < 2**(n-1); i++){
            //log(i, "I");
            //log(pcount, "PCOUNT");
            p[pcount] = Poseidon(2);
            // 0,1;2,3;4,5;etc
            p[pcount].inputs[0] <== leaves[2*i];
            p[pcount].inputs[1] <== leaves[2*i+1];
            // insert into the appropriate level with 2**(n-1) as the base
            tree[2**(n-1) + i] <== p[pcount].out;
            pcount++;
        }

        // Connecte the leaves across levels, leaf-to-root.
        for(var i = 2**(n-1) - 1; i > 0 ; i--) {
            p[pcount] = Poseidon(2);
            p[pcount].inputs[0] <== leaves[2*i];
            p[pcount].inputs[1] <== leaves[2*i+1];
            tree[i] <== p[pcount].out;
            pcount++;
        }

        root <== tree[1];
    }
}

template IfFilter() {
    signal input condition; //0 or 1
    signal input true;
    signal input false;
    signal output out; //equal true input if condition equal to 1 or false input if equal to 0

    signal middle;
    middle <== (1 - condition) * false;
    out <== (condition * true) + middle;
}

template MerkleTreeInclusionProof(n) {
    signal input leaf;
    signal input path_elements[n];
    signal input path_index[n]; // path index are 0's and 1's indicating whether the current element is on the left or right
    signal output root;

    //[assignment] insert your code here to compute the root from a leaf and elements along the path
    component p[n];
    component ifs[2*n];
    signal join[n + 1];

    join[0] <== leaf;

    for(var i = 0; i < n; i++){
        p[i] = Poseidon(2);

        ifs[2*i] = IfFilter();
        ifs[2*i].condition <== path_index[i];
        ifs[2*i].true <== path_elements[i];
        ifs[2*i].false <== join[i];
        p[i].inputs[0] <== ifs[2*i].out;

        ifs[2*i+1] = IfFilter();
        ifs[2*i+1].condition <== path_index[i];
        ifs[2*i+1].true <== join[i];
        ifs[2*i+1].false <== path_elements[i];
        p[i].inputs[1] <== ifs[2*i+1].out;

        join[i+1] <== p[i].out;
    }

    root <== join[n];
}
