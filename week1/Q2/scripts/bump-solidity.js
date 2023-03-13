const fs = require('fs')

const solidityRegex = /pragma solidity \^\d+\.\d+\.\d+/
const verifierRegex = /contract Verifier/

// [assignment] add your own scripts below to modify the other verifier contracts you will build during the assignment

const bumpSolidityVersion = (file) => {
  let content = fs.readFileSync(`./contracts/${file}.sol`, {
    encoding: 'utf-8',
  })
  let bumped = content.replace(solidityRegex, 'pragma solidity ^0.8.0')
  bumped = bumped.replace(verifierRegex, `contract ${file}`)

  fs.writeFileSync(`./contracts/${file}.sol`, bumped)
}

bumpSolidityVersion('HelloWorldVerifier')
bumpSolidityVersion('Multiplier3Verifier')
