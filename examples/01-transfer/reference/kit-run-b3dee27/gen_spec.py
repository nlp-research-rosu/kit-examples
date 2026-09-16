#!/usr/bin/env python3
# Generates spec.k with 5 transfer claims sharing one KEVM runtime-bytecode
# config skeleton (modelled on tests/specs/benchmarks/storagevar00-spec.k).

def claim(name, comment, calldata, callvalue_cell, output_rhs, status_rhs,
          storage_cell, log_cell, requires):
    return f'''  // {comment}
  claim [{name}]:
    <k> (#execute => #halt) ~> _ </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <ethereum>
      <evm>
        <output> _ => {output_rhs} </output>
        <statusCode> _ => {status_rhs} </statusCode>
        <callStack> _ </callStack>
        <interimStates> _ </interimStates>
        <touchedAccounts> _ => ?_ </touchedAccounts>
        <callState>
          <program> StandardTokenCode </program>
          <jumpDests> #computeValidJumpDests(StandardTokenCode) </jumpDests>
          <id> ACCTID </id>
          <codeAddr> ACCTID </codeAddr>
          <caller> MSG_SENDER </caller>
          <callData> {calldata} </callData>
          <callValue> {callvalue_cell} </callValue>
          <wordStack> .WordStack => ?_ </wordStack>
          <localMem> .Bytes => ?_ </localMem>
          <pc> 0 => ?_ </pc>
          <gas> #gas(_VGAS) => ?_ </gas>
          <memoryUsed> 0 => ?_ </memoryUsed>
          <callGas> _ => ?_ </callGas>
          <static> false </static>
          <callDepth> CALLDEPTH </callDepth>
        </callState>
        <versionedHashes> _ </versionedHashes>
        <substate>
          <selfDestruct> _ </selfDestruct>
          {log_cell}
          <refund> _ => ?_ </refund>
          <accessedAccounts> _ => ?_ </accessedAccounts>
          <accessedStorage> _ => ?_ </accessedStorage>
          <createdAccounts> _ => ?_ </createdAccounts>
        </substate>
        <gasPrice> _ </gasPrice>
        <origin> _ </origin>
        <blockhashes> _ </blockhashes>
        ...
      </evm>
      <network>
        <chainID> _ </chainID>
        <accounts>
          <account>
            <acctID> ACCTID </acctID>
            <balance> ACCTBAL </balance>
            <code> StandardTokenCode </code>
            {storage_cell}
            <origStorage> _ </origStorage>
            <nonce> ACCTNONCE </nonce>
            <transientStorage> _ </transientStorage>
          </account>
          ...
        </accounts>
        <txOrder> _ </txOrder>
        <txPending> _ </txPending>
        <messages> _ </messages>
        ...
      </network>
    </ethereum>
    requires #rangeAddress(ACCTID)
     andBool #rangeAddress(MSG_SENDER)
     andBool #rangeUInt(256, ACCTBAL)
     andBool #rangeNonce(ACCTNONCE)
     andBool #range(0 <= CALLDEPTH < 1024)
{requires}

'''

FROM = '#hashedLocation("Solidity", 1, MSG_SENDER)'
TO   = '#hashedLocation("Solidity", 1, TO)'

claims = []

# ---- Claim 1: success, distinct recipient, no overflow ----
claims.append(claim(
    name='transfer-success',
    comment='Claim 1 — Success (to != sender, no recipient overflow): sender balance '
            'decreases by value, recipient increases by value, returns true, emits Transfer.',
    calldata='#abiCallData("transfer", #address(TO), #uint256(VALUE))',
    callvalue_cell='0',
    output_rhs='#buf(32, 1)',
    status_rhs='EVMC_SUCCESS',
    storage_cell=(f'<storage> ({FROM} |-> (BAL_FROM => BAL_FROM -Int VALUE))\n'
                  f'                      ({TO}   |-> (BAL_TO   => BAL_TO   +Int VALUE)) _STORAGE </storage>'),
    log_cell='<log> LOGS => LOGS ListItem({ ACCTID | ListItem(TransferTopic0) ListItem(MSG_SENDER) ListItem(TO) | #buf(32, VALUE) }) </log>',
    requires=(
        '     andBool #rangeAddress(TO)\n'
        '     andBool #rangeUInt(256, VALUE)\n'
        '     andBool #rangeUInt(256, BAL_FROM)\n'
        '     andBool #rangeUInt(256, BAL_TO)\n'
        '     andBool MSG_SENDER =/=Int TO\n'
        f'     andBool {FROM} =/=Int {TO}   // distinct storage slots (keccak collision-resistance; see SCOPE.md)\n'
        '     andBool VALUE >Int 0\n'
        '     andBool BAL_FROM >=Int VALUE\n'
        '     andBool BAL_TO +Int VALUE <Int pow256'),
))

# ---- Claim 2: self-transfer ----
claims.append(claim(
    name='transfer-self',
    comment='Claim 2 — Self-transfer (to == sender): balance unchanged, returns true, emits Transfer.',
    calldata='#abiCallData("transfer", #address(MSG_SENDER), #uint256(VALUE))',
    callvalue_cell='0',
    output_rhs='#buf(32, 1)',
    status_rhs='EVMC_SUCCESS',
    storage_cell=f'<storage> ({FROM} |-> BAL_FROM) _STORAGE </storage>',
    log_cell='<log> LOGS => LOGS ListItem({ ACCTID | ListItem(TransferTopic0) ListItem(MSG_SENDER) ListItem(MSG_SENDER) | #buf(32, VALUE) }) </log>',
    requires=(
        '     andBool #rangeUInt(256, VALUE)\n'
        '     andBool #rangeUInt(256, BAL_FROM)\n'
        '     andBool VALUE >Int 0\n'
        '     andBool BAL_FROM >=Int VALUE'),
))

# ---- Claim 3: insufficient balance -> return false, no state change, no log ----
claims.append(claim(
    name='transfer-insufficient',
    comment='Claim 3 — Insufficient balance (balances[sender] < value): returns false, '
            'no storage change, no log, normal RETURN (NOT a revert).',
    calldata='#abiCallData("transfer", #address(TO), #uint256(VALUE))',
    callvalue_cell='0',
    output_rhs='#buf(32, 0)',
    status_rhs='EVMC_SUCCESS',
    storage_cell=f'<storage> ({FROM} |-> BAL_FROM) _STORAGE </storage>',
    log_cell='<log> LOGS </log>',
    requires=(
        '     andBool #rangeAddress(TO)\n'
        '     andBool #rangeUInt(256, VALUE)\n'
        '     andBool #rangeUInt(256, BAL_FROM)\n'
        '     andBool BAL_FROM <Int VALUE'),
))

# ---- Claim 4: not payable -> revert on nonzero callvalue ----
claims.append(claim(
    name='transfer-not-payable',
    comment='Claim 4 — Not payable: any nonzero call value reverts with empty output; '
            'no storage or log change.',
    calldata='#abiCallData("transfer", #address(TO), #uint256(VALUE))',
    callvalue_cell='VAL_SENT',
    output_rhs='.Bytes',
    status_rhs='EVMC_REVERT',
    storage_cell='<storage> _STORAGE </storage>',
    log_cell='<log> LOGS </log>',
    requires=(
        '     andBool #rangeAddress(TO)\n'
        '     andBool #rangeUInt(256, VALUE)\n'
        '     andBool #rangeUInt(256, VAL_SENT)\n'
        '     andBool VAL_SENT >Int 0'),
))

# ---- Claim 5: recipient balance overflow (silent wraparound) ----
claims.append(claim(
    name='transfer-overflow',
    comment='Claim 5 — Recipient overflow (to != sender, balances[to]+value >= 2^256): '
            'recipient balance wraps to chop(balances[to]+value); still returns true and emits Transfer.',
    calldata='#abiCallData("transfer", #address(TO), #uint256(VALUE))',
    callvalue_cell='0',
    output_rhs='#buf(32, 1)',
    status_rhs='EVMC_SUCCESS',
    storage_cell=(f'<storage> ({FROM} |-> (BAL_FROM => BAL_FROM -Int VALUE))\n'
                  f'                      ({TO}   |-> (BAL_TO   => BAL_TO +Int VALUE -Int pow256)) _STORAGE </storage>'),
    log_cell='<log> LOGS => LOGS ListItem({ ACCTID | ListItem(TransferTopic0) ListItem(MSG_SENDER) ListItem(TO) | #buf(32, VALUE) }) </log>',
    requires=(
        '     andBool #rangeAddress(TO)\n'
        '     andBool #rangeUInt(256, VALUE)\n'
        '     andBool #rangeUInt(256, BAL_FROM)\n'
        '     andBool #rangeUInt(256, BAL_TO)\n'
        '     andBool MSG_SENDER =/=Int TO\n'
        f'     andBool {FROM} =/=Int {TO}   // distinct storage slots (keccak collision-resistance; see SCOPE.md)\n'
        '     andBool VALUE >Int 0\n'
        '     andBool BAL_FROM >=Int VALUE\n'
        '     andBool BAL_TO +Int VALUE >=Int pow256'),
))

header = '''requires "verification.k"

// ===========================================================================
// spec.k -- Bytecode-level correctness of StandardToken.transfer
//           (contract/StandardToken.inlined.bytes), ERC20 transfer(address,uint256).
//
// Five reachability claims, proved together in one module. Observables are all
// at bytecode level: <storage> (balances mapping, slot 1), <callData>,
// <output>, <statusCode>, and the <log> substate. See SCOPE.md for scope and
// the contract readings, and BYTECODE-ANALYSIS.md for the disassembly evidence.
// ===========================================================================

module SPEC
  imports VERIFICATION

'''

out = header + ''.join(claims) + 'endmodule\n'
open('/home/dmn/kit-example/examples/01-transfer/.kprover/sessions/16dec4d8-3461-45d9-8112-23f9a0ec6c5b/inputs/spec.k','w').write(out)
print("wrote spec.k,", out.count('claim ['), "claims,", len(out), "bytes")
