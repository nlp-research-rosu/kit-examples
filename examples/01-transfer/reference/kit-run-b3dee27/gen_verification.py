#!/usr/bin/env python3
# Generates verification.k with the runtime bytecode embedded as a macro.
code = open('/home/dmn/kit-example/examples/01-transfer/contract/StandardToken.inlined.bytes').read().strip()
assert code.startswith('0x')

out = f'''requires "edsl.md"
requires "lemmas/lemmas.k"

// ---------------------------------------------------------------------------
// VERIFICATION-SUMMARIES : the theorem's definitional layer.
// transfer() is straight-line bytecode (no loop), so there is no recursive
// loop-summary function. This module fixes the two program-specific constants
// the claims name: the runtime bytecode and the Transfer event topic.
// ---------------------------------------------------------------------------
module VERIFICATION-SUMMARIES
    imports EVM

    // Runtime bytecode of StandardToken (contract/StandardToken.inlined.bytes).
    syntax Bytes ::= "StandardTokenCode" [macro]
 // ---------------------------------------------
    rule StandardTokenCode => #parseByteStack("{code}")

    // keccak256("Transfer(address,address,uint256)") -- topic0 of the event,
    // confirmed as the PUSH32 constant at pc 0x72e in the bytecode.
    syntax Int ::= "TransferTopic0" [macro]
 // ---------------------------------------
    rule TransferTopic0 => 100389287136786176327247604509743168900146139575972864366142685224231313322991
endmodule

// ---------------------------------------------------------------------------
// VERIFICATION : semantics + generic EVM helpers + simplification lemmas,
// plus proof extensions added by the proving stage.
// ---------------------------------------------------------------------------
module VERIFICATION
    imports VERIFICATION-SUMMARIES
    imports EDSL
    imports LEMMAS

    // ---- Proof extensions (added during proving-spec) ----
    // (none yet)
endmodule
'''
open('/home/dmn/kit-example/examples/01-transfer/.kprover/sessions/16dec4d8-3461-45d9-8112-23f9a0ec6c5b/inputs/verification.k','w').write(out)
print("wrote verification.k, code length chars:", len(code))
