## Part 1 Hashes and Merkle Tree

#### Q1. Based on the resources we provide you as well as any additional research you have done, compare the four hashes and provide explanations in four different aspects: gas cost, capacity, proof generation efficiency, and proof size. It's ok if you cannot find reference for all four aspects, just do the best you can.

| Gas Cost (hash 2 values) | Capacity | Proof Generation Efficiency | Proof Size

SHA256 | 23179 | |
MiMC | 59480 | 1,073,741,824 | 1 | | ~ 0.1 - 0.5kb
Poseidon | 49858 | 1,073,741,824 | 2-3 |
Pedersen

## Part 2 Tornado Cash

#### Q1. How is Tornado Cash Nova different from Tornado Cash Classic? What are the key upgrades/improvements and what changes in the technical design make these possible?

Nova allows for shielded transfers and transfers/withdrawals of arbitrary amounts. It also offers upgradeable contracts. These are made possible by the L2 bridge/messaging design.

#### Q2. What is the role of the relayers in the Tornado Cash protocols? Why are relayers needed?

Relayers allow users to process withdrawals without needing to pre-fund their accounts. This feature helps with privacy.

## Part 3 Semaphore

#### Q1. What is Semaphore? Explain in 4-8 sentences how it works.

Semaphore is an anonymous identity system on the Ethereum network. It uses a smart contract to hold state and ZK rollups to authorize users in an anonymous way. This system allows these users to endorse and store arbitrary strings. Many use cases, like anonymous login, are enabled with this ability.

#### Q2. How does Semaphore prevent double signing (or double withdrawal in the case of mixers)? Explain the mechanism in 4-8 sentences.

Semaphore prevents double signing by using an 'external nullifier' pattern. The smart contract accepts only on signal per user per external nullifier. Subsequent attempts to signal will not be accepted. This allows the smart contract to control the maximum frequency of signals available to users.

#### Q3. A lot of applications have already been built based on derivations from Semaphore, such as for voting (e.g. AnonyVote), survey or opinion (e.g. Ninja Survey, zkAsk), and authentication (e.g. InterRep, Continuum, zkPayroll). Can you suggest two more ideas for ZK applications that can be built upon Semaphore?

...
