const { expect, assert } = require('chai')
const { ethers } = require('hardhat')
const { groth16, plonk } = require('snarkjs')

const wasm_tester = require('circom_tester').wasm

const F1Field = require('ffjavascript').F1Field
const Scalar = require('ffjavascript').Scalar

// "Pairing-friendly" BN254 prime.
exports.p = Scalar.fromString(
  '21888242871839275222246405745257275088548364400416034343698204186575808495617'
)
const Fr = new F1Field(exports.p)

describe('HelloWorld', function () {
  this.timeout(100000000)
  let Verifier
  let verifier

  beforeEach(async function () {
    // Locate and deploy the verfier contract.
    Verifier = await ethers.getContractFactory('HelloWorldVerifier')
    verifier = await Verifier.deploy()
    await verifier.deployed()
  })

  it('Circuit should multiply two numbers correctly', async function () {
    // Load the contract into the wasm tester.
    const circuit = await wasm_tester('contracts/circuits/HelloWorld.circom')

    // Define the inputs.
    const INPUT = {
      a: 2,
      b: 3,
    }

    // Produce the witness.
    const witness = await circuit.calculateWitness(INPUT, true)

    // Verify the witness output is valid.
    assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)))
    assert(Fr.eq(Fr.e(witness[1]), Fr.e(6)))
  })

  it('Should return true for correct proof', async function () {
    //[assignment] Add comments to explain what each line is doing
    // Run Groth16 on the given inputs, verifier contract and circuit.
    const { proof, publicSignals } = await groth16.fullProve(
      { a: '2', b: '3' },
      'contracts/circuits/HelloWorld/HelloWorld_js/HelloWorld.wasm',
      'contracts/circuits/HelloWorld/circuit_final.zkey'
    )

    // Convert the proof into a smart contract.
    const calldata = await groth16.exportSolidityCallData(proof, publicSignals)

    // Remove braces and split args out of the payload string.
    const argv = calldata
      .replace(/["[\]\s]/g, '')
      .split(',')
      .map((x) => BigInt(x).toString())

    // Reshape the args into input form for verification.
    const a = [argv[0], argv[1]]
    const b = [
      [argv[2], argv[3]],
      [argv[4], argv[5]],
    ]
    const c = [argv[6], argv[7]]
    const Input = argv.slice(8)

    expect(await verifier.verifyProof(a, b, c, Input)).to.be.true
  })

  it('Should return false for invalid proof', async function () {
    let a = [0, 0]
    let b = [
      [0, 0],
      [0, 0],
    ]
    let c = [0, 0]
    let d = [0]
    expect(await verifier.verifyProof(a, b, c, d)).to.be.false
  })
})

describe('Multiplier3 with Groth16', function () {
  this.timeout(100000000)
  let Verifier
  let verifier

  beforeEach(async function () {
    //[assignment] insert your script here
    Verifier = await ethers.getContractFactory('Multiplier3Verifier')
    verifier = await Verifier.deploy()
    await verifier.deployed()
  })

  it('Circuit should multiply three numbers correctly', async function () {
    //[assignment] insert your script here
    const circuit = await wasm_tester('contracts/circuits/Multiplier3.circom')

    const INPUT = {
      a: 2,
      b: 3,
      c: 4,
    }

    const witness = await circuit.calculateWitness(INPUT, true)

    assert(Fr.eq(Fr.e(witness[0]), Fr.e(1)))
    assert(Fr.eq(Fr.e(witness[1]), Fr.e(24)))
  })

  it('Should return true for correct proof', async function () {
    //[assignment] insert your script here
    const { proof, publicSignals } = await groth16.fullProve(
      { a: '2', b: '3', c: '4' },
      'contracts/circuits/Multiplier3/Multiplier3_js/Multiplier3.wasm',
      'contracts/circuits/Multiplier3/circuit_final.zkey'
    )

    const calldata = await groth16.exportSolidityCallData(proof, publicSignals)

    const argv = calldata
      .replace(/["[\]\s]/g, '')
      .split(',')
      .map((x) => BigInt(x).toString())

    const a = [argv[0], argv[1]]
    const b = [
      [argv[2], argv[3]],
      [argv[4], argv[5]],
    ]
    const c = [argv[6], argv[7]]
    const Input = argv.slice(8)

    expect(await verifier.verifyProof(a, b, c, Input)).to.be.true
  })

  it('Should return false for invalid proof', async function () {
    //[assignment] insert your script here
    let a = [0, 0]
    let b = [
      [0, 0],
      [0, 0],
    ]
    let c = [0, 0]
    let d = [0]
    expect(await verifier.verifyProof(a, b, c, d)).to.be.false
  })
})

describe('Multiplier3 with PLONK', function () {
  beforeEach(async function () {
    //[assignment] insert your script here
    Verifier = await ethers.getContractFactory('PlonkVerifier')
    verifier = await Verifier.deploy()
    await verifier.deployed()
  })

  it('Should return true for correct proof', async function () {
    //[assignment] insert your script here
    const { proof, publicSignals } = await plonk.fullProve(
      { a: '2', b: '3', c: '4' },
      'contracts/circuits/Multiplier3_plonk/Multiplier3_js/Multiplier3.wasm',
      'contracts/circuits/Multiplier3_plonk/circuit_final.zkey'
    )

    const calldata = await plonk.exportSolidityCallData(proof, publicSignals)
    const argv = calldata.replace(/["[\]\s]/g, '').split(',')

    expect(await verifier.verifyProof(argv[0], publicSignals)).to.be.true
  })

  it('Should return false for invalid proof', async function () {
    //[assignment] insert your script here
    let a = [0]
    let b = [0]

    expect(await verifier.verifyProof(a, b)).to.be.false
  })
})
