// Auxiliary lemmas for the StandardToken ERC20 verification.
//
// Each lemma carries a soundness argument in the comment above it.

module ERC20-LEMMAS [symbolic]
    imports EVM
    imports BUF
    imports INT-SIMPLIFICATION

    // [chop-overflow-add]
    //
    //   chop(X + Y) = (X + Y) mod 2^256.
    //   If 0 <= X < 2^256 and 0 <= Y < 2^256 then 0 <= X + Y < 2^257,
    //   so whenever 2^256 <= X + Y, exactly one subtraction of 2^256
    //   lands the sum back in [0, 2^256).  Hence on this domain
    //   chop(X + Y) = X + Y - 2^256.  This is pure modular arithmetic;
    //   no EVM-specific assumption is involved.
    //
    //   Used by: the balance-overflow edge-case claims for transfer and
    //   transferFrom, to express the wrapped balance in +/- form.
    rule [chop-overflow-add]:
        chop ( X +Int Y ) => X +Int Y -Int pow256
      requires pow256 <=Int X +Int Y
       andBool X <Int pow256 andBool Y <Int pow256
       andBool 0 <=Int X andBool 0 <=Int Y
      [simplification]

endmodule
