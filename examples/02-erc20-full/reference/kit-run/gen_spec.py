#!/usr/bin/env python3
"""Generate verification.k and spec.k for the StandardToken ERC20 bytecode proof.

Claims are KEVM reachability claims over the runtime bytecode, covering every
externally callable function (success / failure / revert / arithmetic edge) and
the dispatcher (short calldata, unknown selector). See SCOPE.md.
"""
import os

HERE = os.path.dirname(os.path.abspath(__file__))
BYTES = open(os.path.join(HERE, "contract/StandardToken.inlined.bytes")).read().strip()
OUTDIR = os.path.join(HERE, ".kprover/sessions/787a58a8-8dc5-4b9e-93ed-40e49f22bedf/inputs")

SELECTORS = {
    "approve":      0x095ea7b3,
    "transferFrom": 0x23b872dd,
    "balanceOf":    0x70a08231,
    "transfer":     0xa9059cbb,
    "allowance":    0xdd62ed3e,
}

# ---------------------------------------------------------------------------
# verification.k
# ---------------------------------------------------------------------------
verification = r'''requires "edsl.md"
requires "lemmas/lemmas.k"

// Definitional layer: the runtime bytecode under test and this contract's
// Solidity storage-slot layout (totalSupply@0, balances@1, allowed@2).
module VERIFICATION-SUMMARIES
    imports EDSL
    imports EVM-ABI

    syntax Bytes ::= "#StandardTokenCode" [function]
 // ------------------------------------------------
    rule #StandardTokenCode => #parseByteStack("%BYTES%")

    // balances[a]      lives at slot 1
    // allowed[a][b]    lives at slot 2
    syntax Int ::= "#bal" "(" Int ")"       [function]
                 | "#alw" "(" Int "," Int ")" [function]
 // ----------------------------------------------------
    rule #bal(A)    => #hashedLocation("Solidity", 1, A)
    rule #alw(A, B) => #hashedLocation("Solidity", 2, A B)
endmodule

// ------------------------------------------------------------------
// Keccak collision-freedom assumptions (trust ledger, see SCOPE.md).
// These encode the standard cryptographic assumption that keccak-256 is
// injective and its symbolic image never coincides with a concrete word.
// They are assumptions, NOT theorems of the EVM semantics. Kept in a
// dedicated [symbolic] module so VERIFICATION itself stays non-symbolic
// (it is the kompile main module).
// ------------------------------------------------------------------
module ERC20-KECCAK-LEMMAS [symbolic]
    imports EVM
    imports EDSL

    rule [keccak-inj]:
      keccak(A) ==Int keccak(B) => A ==K B [simplification]
    rule [keccak-inj-ml]:
      { keccak(A) #Equals keccak(B) } => { true #Equals A ==K B } [simplification]

    rule [keccak-conc-eq-false]:
      keccak(_A)  ==Int _B => false [symbolic(_A), concrete(_B), simplification(30), comm]
    rule [keccak-conc-neq-true]:
      keccak(_A) =/=Int _B => true  [symbolic(_A), concrete(_B), simplification(30), comm]
    rule [keccak-conc-eq-false-ml-lr]:
      { keccak(A) #Equals B } => { true #Equals keccak(A) ==Int B } [symbolic(A), concrete(B), simplification]
    rule [keccak-conc-eq-false-ml-rl]:
      { B #Equals keccak(A) } => { true #Equals keccak(A) ==Int B } [symbolic(A), concrete(B), simplification]
endmodule

module VERIFICATION
    imports VERIFICATION-SUMMARIES
    imports EDSL
    imports LEMMAS
    imports ERC20-KECCAK-LEMMAS
endmodule
'''.replace("%BYTES%", BYTES)

# ---------------------------------------------------------------------------
# spec.k
# ---------------------------------------------------------------------------
# The shared configuration skeleton. Per-claim fields are substituted in.
CLAIM_TMPL = r'''
    claim [%LABEL%]:
      <kevm>
        <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
        <mode> NORMAL </mode>
        <schedule> SHANGHAI </schedule>
        <useGas> false </useGas>
        <ethereum>
          <evm>
            <output> _ => %OUTPUT% </output>
            <statusCode> _ => %STATUS% </statusCode>
            <callStack> .List </callStack>
            <callState>
              <program> #StandardTokenCode </program>
              <jumpDests> #computeValidJumpDests(#StandardTokenCode) </jumpDests>
              <id> ACCT_ID </id>
              <codeAddr> ACCT_ID </codeAddr>
              <caller> CALLER_ID </caller>
              <callData> %CALLDATA% </callData>
              <callValue> %CALLVALUE% </callValue>
              <wordStack> .WordStack => ?_ </wordStack>
              <localMem> .Bytes => ?_ </localMem>
              <pc> 0 => ?_ </pc>
              <gas> _ => ?_ </gas>
              <memoryUsed> 0 => ?_ </memoryUsed>
              <static> false </static>
              <callDepth> CALL_DEPTH </callDepth>
              ...
            </callState>
            <substate>
              <log> %LOGS% </log>
              <refund> 0 => ?_ </refund>
              ...
            </substate>
            ...
          </evm>
          <network>
            <accounts>
              <account>
                <acctID> ACCT_ID </acctID>
                <code> #StandardTokenCode </code>
                <storage> %STORAGE% </storage>
                <origStorage> _ </origStorage>
                ...
              </account>
              ...
            </accounts>
            ...
          </network>
        </ethereum>
        ...
      </kevm>
      requires %REQUIRES%
'''

# Common precondition fragments.
ACCT = "#rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024"

def transfer_log(frm, to, val):
    return ('LOGS => LOGS ListItem(#abiEventLog(ACCT_ID, "Transfer", '
            '#indexed(#address(%s)), #indexed(#address(%s)), #uint256(%s)))' % (frm, to, val))

def approval_log(owner, spender, val):
    return ('LOGS => LOGS ListItem(#abiEventLog(ACCT_ID, "Approval", '
            '#indexed(#address(%s)), #indexed(#address(%s)), #uint256(%s)))' % (owner, spender, val))

claims = []

# ---------------- approve ----------------
claims.append(dict(
    LABEL="approve-success",
    CALLDATA='#abiCallData("approve", #address(SPENDER), #uint256(VALUE))',
    CALLVALUE="0",
    STATUS="EVMC_SUCCESS",
    OUTPUT="#buf(32, 1)",
    LOGS=approval_log("CALLER_ID", "SPENDER", "VALUE"),
    STORAGE="(#alw(CALLER_ID, SPENDER) |-> OLD_ALW) REST => (#alw(CALLER_ID, SPENDER) |-> VALUE) REST",
    REQUIRES=ACCT + " andBool #rangeAddress(SPENDER) andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, OLD_ALW)",
))
claims.append(dict(
    LABEL="approve-revert-value",
    CALLDATA='#abiCallData("approve", #address(SPENDER), #uint256(VALUE))',
    CALLVALUE="VCALL_VALUE",
    STATUS="EVMC_REVERT",
    OUTPUT=".Bytes",
    LOGS="LOGS",
    STORAGE="REST",
    REQUIRES=ACCT + " andBool #rangeAddress(SPENDER) andBool #rangeUInt(256, VALUE) andBool VCALL_VALUE >Int 0 andBool #rangeUInt(256, VCALL_VALUE)",
))

# ---------------- transfer ----------------
claims.append(dict(
    LABEL="transfer-success",
    CALLDATA='#abiCallData("transfer", #address(TO), #uint256(VALUE))',
    CALLVALUE="0",
    STATUS="EVMC_SUCCESS",
    OUTPUT="#buf(32, 1)",
    LOGS=transfer_log("CALLER_ID", "TO", "VALUE"),
    STORAGE="(#bal(CALLER_ID) |-> BAL_FROM) (#bal(TO) |-> BAL_TO) REST => (#bal(CALLER_ID) |-> (BAL_FROM -Int VALUE)) (#bal(TO) |-> (BAL_TO +Int VALUE)) REST",
    REQUIRES=ACCT + " andBool #rangeAddress(TO) andBool CALLER_ID =/=Int TO"
             " andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM) andBool #rangeUInt(256, BAL_TO)"
             " andBool BAL_FROM >=Int VALUE andBool VALUE >Int 0 andBool BAL_TO +Int VALUE <Int pow256",
))
claims.append(dict(
    LABEL="transfer-success-self",
    CALLDATA='#abiCallData("transfer", #address(CALLER_ID), #uint256(VALUE))',
    CALLVALUE="0",
    STATUS="EVMC_SUCCESS",
    OUTPUT="#buf(32, 1)",
    LOGS=transfer_log("CALLER_ID", "CALLER_ID", "VALUE"),
    STORAGE="(#bal(CALLER_ID) |-> BAL_FROM) REST => (#bal(CALLER_ID) |-> BAL_FROM) REST",
    REQUIRES=ACCT + " andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM)"
             " andBool BAL_FROM >=Int VALUE andBool VALUE >Int 0",
))
claims.append(dict(
    LABEL="transfer-overflow",
    CALLDATA='#abiCallData("transfer", #address(TO), #uint256(VALUE))',
    CALLVALUE="0",
    STATUS="EVMC_SUCCESS",
    OUTPUT="#buf(32, 1)",
    LOGS=transfer_log("CALLER_ID", "TO", "VALUE"),
    STORAGE="(#bal(CALLER_ID) |-> BAL_FROM) (#bal(TO) |-> BAL_TO) REST => (#bal(CALLER_ID) |-> (BAL_FROM -Int VALUE)) (#bal(TO) |-> (BAL_TO +Int VALUE -Int pow256)) REST",
    REQUIRES=ACCT + " andBool #rangeAddress(TO) andBool CALLER_ID =/=Int TO"
             " andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM) andBool #rangeUInt(256, BAL_TO)"
             " andBool BAL_FROM >=Int VALUE andBool VALUE >Int 0 andBool BAL_TO +Int VALUE >=Int pow256",
))
claims.append(dict(
    LABEL="transfer-fail",
    CALLDATA='#abiCallData("transfer", #address(TO), #uint256(VALUE))',
    CALLVALUE="0",
    STATUS="EVMC_SUCCESS",
    OUTPUT="#buf(32, 0)",
    LOGS="LOGS",
    STORAGE="(#bal(CALLER_ID) |-> BAL_FROM) REST",
    REQUIRES=ACCT + " andBool #rangeAddress(TO)"
             " andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM)"
             " andBool notBool (BAL_FROM >=Int VALUE andBool VALUE >Int 0)",
))
claims.append(dict(
    LABEL="transfer-revert-value",
    CALLDATA='#abiCallData("transfer", #address(TO), #uint256(VALUE))',
    CALLVALUE="VCALL_VALUE",
    STATUS="EVMC_REVERT",
    OUTPUT=".Bytes",
    LOGS="LOGS",
    STORAGE="REST",
    REQUIRES=ACCT + " andBool #rangeAddress(TO) andBool #rangeUInt(256, VALUE)"
             " andBool VCALL_VALUE >Int 0 andBool #rangeUInt(256, VCALL_VALUE)",
))

# ---------------- transferFrom ----------------
claims.append(dict(
    LABEL="transferFrom-success",
    CALLDATA='#abiCallData("transferFrom", #address(FROM), #address(TO), #uint256(VALUE))',
    CALLVALUE="0",
    STATUS="EVMC_SUCCESS",
    OUTPUT="#buf(32, 1)",
    LOGS=transfer_log("FROM", "TO", "VALUE"),
    STORAGE="(#bal(FROM) |-> BAL_FROM) (#bal(TO) |-> BAL_TO) (#alw(FROM, CALLER_ID) |-> ALLOW) REST"
            " => (#bal(FROM) |-> (BAL_FROM -Int VALUE)) (#bal(TO) |-> (BAL_TO +Int VALUE)) (#alw(FROM, CALLER_ID) |-> (ALLOW -Int VALUE)) REST",
    REQUIRES=ACCT + " andBool #rangeAddress(FROM) andBool #rangeAddress(TO) andBool FROM =/=Int TO"
             " andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM) andBool #rangeUInt(256, BAL_TO) andBool #rangeUInt(256, ALLOW)"
             " andBool BAL_FROM >=Int VALUE andBool ALLOW >=Int VALUE andBool VALUE >Int 0 andBool BAL_TO +Int VALUE <Int pow256",
))
claims.append(dict(
    LABEL="transferFrom-success-self",
    CALLDATA='#abiCallData("transferFrom", #address(FROM), #address(FROM), #uint256(VALUE))',
    CALLVALUE="0",
    STATUS="EVMC_SUCCESS",
    OUTPUT="#buf(32, 1)",
    LOGS=transfer_log("FROM", "FROM", "VALUE"),
    STORAGE="(#bal(FROM) |-> BAL_FROM) (#alw(FROM, CALLER_ID) |-> ALLOW) REST"
            " => (#bal(FROM) |-> BAL_FROM) (#alw(FROM, CALLER_ID) |-> (ALLOW -Int VALUE)) REST",
    REQUIRES=ACCT + " andBool #rangeAddress(FROM)"
             " andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM) andBool #rangeUInt(256, ALLOW)"
             " andBool BAL_FROM >=Int VALUE andBool ALLOW >=Int VALUE andBool VALUE >Int 0",
))
claims.append(dict(
    LABEL="transferFrom-overflow",
    CALLDATA='#abiCallData("transferFrom", #address(FROM), #address(TO), #uint256(VALUE))',
    CALLVALUE="0",
    STATUS="EVMC_SUCCESS",
    OUTPUT="#buf(32, 1)",
    LOGS=transfer_log("FROM", "TO", "VALUE"),
    STORAGE="(#bal(FROM) |-> BAL_FROM) (#bal(TO) |-> BAL_TO) (#alw(FROM, CALLER_ID) |-> ALLOW) REST"
            " => (#bal(FROM) |-> (BAL_FROM -Int VALUE)) (#bal(TO) |-> (BAL_TO +Int VALUE -Int pow256)) (#alw(FROM, CALLER_ID) |-> (ALLOW -Int VALUE)) REST",
    REQUIRES=ACCT + " andBool #rangeAddress(FROM) andBool #rangeAddress(TO) andBool FROM =/=Int TO"
             " andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM) andBool #rangeUInt(256, BAL_TO) andBool #rangeUInt(256, ALLOW)"
             " andBool BAL_FROM >=Int VALUE andBool ALLOW >=Int VALUE andBool VALUE >Int 0 andBool BAL_TO +Int VALUE >=Int pow256",
))
claims.append(dict(
    LABEL="transferFrom-fail",
    CALLDATA='#abiCallData("transferFrom", #address(FROM), #address(TO), #uint256(VALUE))',
    CALLVALUE="0",
    STATUS="EVMC_SUCCESS",
    OUTPUT="#buf(32, 0)",
    LOGS="LOGS",
    STORAGE="(#bal(FROM) |-> BAL_FROM) (#alw(FROM, CALLER_ID) |-> ALLOW) REST",
    REQUIRES=ACCT + " andBool #rangeAddress(FROM) andBool #rangeAddress(TO)"
             " andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM) andBool #rangeUInt(256, ALLOW)"
             " andBool notBool (BAL_FROM >=Int VALUE andBool ALLOW >=Int VALUE andBool VALUE >Int 0)",
))
claims.append(dict(
    LABEL="transferFrom-revert-value",
    CALLDATA='#abiCallData("transferFrom", #address(FROM), #address(TO), #uint256(VALUE))',
    CALLVALUE="VCALL_VALUE",
    STATUS="EVMC_REVERT",
    OUTPUT=".Bytes",
    LOGS="LOGS",
    STORAGE="REST",
    REQUIRES=ACCT + " andBool #rangeAddress(FROM) andBool #rangeAddress(TO) andBool #rangeUInt(256, VALUE)"
             " andBool VCALL_VALUE >Int 0 andBool #rangeUInt(256, VCALL_VALUE)",
))

# ---------------- balanceOf ----------------
claims.append(dict(
    LABEL="balanceOf-success",
    CALLDATA='#abiCallData("balanceOf", #address(OWNER))',
    CALLVALUE="0",
    STATUS="EVMC_SUCCESS",
    OUTPUT="#buf(32, BAL)",
    LOGS="LOGS",
    STORAGE="(#bal(OWNER) |-> BAL) REST",
    REQUIRES=ACCT + " andBool #rangeAddress(OWNER) andBool #rangeUInt(256, BAL)",
))
claims.append(dict(
    LABEL="balanceOf-revert-value",
    CALLDATA='#abiCallData("balanceOf", #address(OWNER))',
    CALLVALUE="VCALL_VALUE",
    STATUS="EVMC_REVERT",
    OUTPUT=".Bytes",
    LOGS="LOGS",
    STORAGE="REST",
    REQUIRES=ACCT + " andBool #rangeAddress(OWNER)"
             " andBool VCALL_VALUE >Int 0 andBool #rangeUInt(256, VCALL_VALUE)",
))

# ---------------- allowance ----------------
claims.append(dict(
    LABEL="allowance-success",
    CALLDATA='#abiCallData("allowance", #address(OWNER), #address(SPENDER))',
    CALLVALUE="0",
    STATUS="EVMC_SUCCESS",
    OUTPUT="#buf(32, ALLOW)",
    LOGS="LOGS",
    STORAGE="(#alw(OWNER, SPENDER) |-> ALLOW) REST",
    REQUIRES=ACCT + " andBool #rangeAddress(OWNER) andBool #rangeAddress(SPENDER) andBool #rangeUInt(256, ALLOW)",
))
claims.append(dict(
    LABEL="allowance-revert-value",
    CALLDATA='#abiCallData("allowance", #address(OWNER), #address(SPENDER))',
    CALLVALUE="VCALL_VALUE",
    STATUS="EVMC_REVERT",
    OUTPUT=".Bytes",
    LOGS="LOGS",
    STORAGE="REST",
    REQUIRES=ACCT + " andBool #rangeAddress(OWNER) andBool #rangeAddress(SPENDER)"
             " andBool VCALL_VALUE >Int 0 andBool #rangeUInt(256, VCALL_VALUE)",
))

# ---------------- dispatcher ----------------
claims.append(dict(
    LABEL="dispatch-short-calldata",
    CALLDATA="CD",
    CALLVALUE="VCALL_VALUE",
    STATUS="EVMC_REVERT",
    OUTPUT=".Bytes",
    LOGS="LOGS",
    STORAGE="REST",
    REQUIRES=ACCT + " andBool #rangeUInt(256, VCALL_VALUE) andBool lengthBytes(CD) <Int 4",
))
unknown_sel_neq = " andBool ".join("SEL =/=Int %d" % s for s in SELECTORS.values())
claims.append(dict(
    LABEL="dispatch-unknown-selector",
    CALLDATA="#buf(4, SEL)",
    CALLVALUE="VCALL_VALUE",
    STATUS="EVMC_REVERT",
    OUTPUT=".Bytes",
    LOGS="LOGS",
    STORAGE="REST",
    REQUIRES=ACCT + " andBool #rangeUInt(256, VCALL_VALUE) andBool 0 <=Int SEL andBool SEL <Int 4294967296 andBool "
             + unknown_sel_neq,
))

body = "".join(
    CLAIM_TMPL
    .replace("%LABEL%", c["LABEL"])
    .replace("%CALLDATA%", c["CALLDATA"])
    .replace("%CALLVALUE%", c["CALLVALUE"])
    .replace("%STATUS%", c["STATUS"])
    .replace("%OUTPUT%", c["OUTPUT"])
    .replace("%LOGS%", c["LOGS"])
    .replace("%STORAGE%", c["STORAGE"])
    .replace("%REQUIRES%", c["REQUIRES"])
    for c in claims
)

spec = 'requires "verification.k"\n\nmodule SPEC\n    imports VERIFICATION\n' + body + "\nendmodule\n"

os.makedirs(OUTDIR, exist_ok=True)
open(os.path.join(OUTDIR, "verification.k"), "w").write(verification)
open(os.path.join(OUTDIR, "spec.k"), "w").write(spec)
print("wrote", len(claims), "claims to", OUTDIR)
for c in claims:
    print("  -", c["LABEL"])
