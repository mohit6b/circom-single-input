pragma circom 2.0.0;

template SingleInput() {
    signal input a;
    // signal input b;
    signal output c;
    c <== a*a;
 }

 component main = SingleInput();