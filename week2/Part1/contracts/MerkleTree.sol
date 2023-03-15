//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {PoseidonT3} from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract

contract MerkleTree is Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root
    uint256 public constant LEVEL = 3;
    uint256 public constant LEAVES = 2 ** LEVEL;
    uint256 public constant SIZE = 2 * LEAVES - 1;

    constructor() {
        // [assignment] initialize a Merkle tree of 8 with blank leaves
        hashes = new uint256[](SIZE);
        for (uint256 i = 0; i < SIZE - 1; i += 2) {
            hashes[i / 2 + LEAVES] = PoseidonT3.poseidon(
                [hashes[i], hashes[i + 1]]
            );
        }
        root = hashes[SIZE - 1];
    }

    function insertLeaf(uint256 hashedLeaf) public returns (uint256) {
        // [assignment] insert a hashed leaf into the Merkle tree
        require(index < LEAVES, "The Merkle tree is full.");
        uint256 current = index;
        hashes[current] = hashedLeaf;
        index += 1;
        for (uint256 i = 0; i < LEVEL; i++) {
            if (current % 2 == 0) {
                hashes[current / 2 + LEAVES] = PoseidonT3.poseidon(
                    [hashes[current], hashes[current + 1]]
                );
            } else {
                hashes[current / 2 + LEAVES] = PoseidonT3.poseidon(
                    [hashes[current - 1], hashes[current]]
                );
            }
            current = current / 2 + LEAVES;
        }
        root = hashes[SIZE - 1];
        return root;
    }

    function verify(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[1] memory input
    ) public view returns (bool) {
        // [assignment] verify an inclusion proof and check that the proof root matches current root
        bool proved = super.verifyProof(a, b, c, input);
        if (proved) {
            return input[0] == root;
        } else {
            return false;
        }
    }
}
