requires "verification.k"

// A5 NON-VACUITY MUTATION (audit-authored). Identical to SPEC.transfer-success
// except the sender-balance postcondition is off by one:
//   correct:  balances[sender] => BAL_FROM -Int VALUE
//   mutated:  balances[sender] => BAL_FROM -Int VALUE +Int 1   <-- deliberately false
// The precondition domain is satisfiable (e.g. BAL_FROM=VALUE=1, distinct addresses),
// and the true execution stores BAL_FROM -Int VALUE, so this claim MUST NOT close.
module MUTATION
  imports VERIFICATION

  claim [transfer-success-MUTATED]:
    <k> (#execute => #halt) ~> _ </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <ethereum>
      <evm>
        <output> _ => #buf(32, 1) </output>
        <statusCode> _ => EVMC_SUCCESS </statusCode>
        <callStack> _ </callStack>
        <interimStates> _ </interimStates>
        <touchedAccounts> _ => ?_ </touchedAccounts>
        <callState>
          <program> StandardTokenCode </program>
          <jumpDests> #computeValidJumpDests(StandardTokenCode) </jumpDests>
          <id> ACCTID </id>
          <codeAddr> ACCTID </codeAddr>
          <caller> MSG_SENDER </caller>
          <callData> #abiCallData("transfer", #address(TO), #uint256(VALUE)) </callData>
          <callValue> 0 </callValue>
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
          <log> LOGS => LOGS ListItem({ ACCTID | ListItem(TransferTopic0) ListItem(MSG_SENDER) ListItem(TO) | #buf(32, VALUE) }) </log>
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
            <storage> (#hashedLocation("Solidity", 1, MSG_SENDER) |-> (BAL_FROM => BAL_FROM -Int VALUE +Int 1))
                      (#hashedLocation("Solidity", 1, TO)   |-> (BAL_TO   => BAL_TO   +Int VALUE)) _STORAGE </storage>
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
     andBool #rangeAddress(TO)
     andBool #rangeUInt(256, VALUE)
     andBool #rangeUInt(256, BAL_FROM)
     andBool #rangeUInt(256, BAL_TO)
     andBool MSG_SENDER =/=Int TO
     andBool #hashedLocation("Solidity", 1, MSG_SENDER) =/=Int #hashedLocation("Solidity", 1, TO)
     andBool VALUE >Int 0
     andBool BAL_FROM >=Int VALUE
     andBool BAL_TO +Int VALUE <Int pow256
endmodule
