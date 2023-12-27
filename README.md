# circom-single-input
POC for circom circuit with single input and simple constraints

Steps to generate zero knowledge proof and verify using circom. 

It includes Groth16 proof system with MPC and Trusted Execution Environment

Compile the circuit with the following command:
```
circom SingleInput.circom --r1cs --wasm --sym --c
```

Change directory to generate the witness
```
cd SingleInput_js
```

Computing the witness with WebAssembly
```
node generate_witness.js SingleInput.wasm ../input.json ../witness.wtns
cd ..
```


Proving and Verification Key Generation section start
Phase 1 - Powers of Tau
Start a new "powers of tau" ceremony
```
snarkjs powersoftau new bn128 12 pot12_0000.ptau -verification
```

Contribute to the ceremony
```
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="SingleInput Phase1 1st Contribution" -v
```

Phase 2
Generate the proving and verification keys with all phase 2 contributions

```
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -verification

snarkjs groth16 setup SingleInput.r1cs pot12_final.ptau SingleInput_0000.zkey

snarkjs zkey contribute SingleInput_0000.zkey SingleInput_0001.zkey --name="SingleInput 1st Contributor-Mohit" -v

snarkjs zkey export verificationkey SingleInput_0001.zkey singleinput_verification_key.json
```

Generate a proof
```
snarkjs groth16 prove SingleInput_0001.zkey witness.wtns proof.json public.json
```

Verify a proof
```
snarkjs groth16 verify singleinput_verification_key.json public.json proof.json
```

Verify from a smart contract
```
snarkjs zkey export solidityverifier SingleInput_0001.zkey SingleInputVerifier.sol
```
