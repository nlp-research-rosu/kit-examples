requires "verification.k"

// A5 non-vacuity mutation (author: proof auditor).
// Distinct module MUTANT in a distinct file. This is transfer-success with ONE
// deliberate false change: the recipient slot is asserted to increase by
// VALUE +Int 1 instead of VALUE. False for every satisfiable input, e.g.
//   ACCTID=CALLER_ID=1, TO=2, VALUE=1, BAL_FROM=1, BAL_TO=0, ACCT_STORAGE empty.
// The real bytecode writes BAL_TO +Int VALUE to balances[TO]; asserting
// BAL_TO +Int VALUE +Int 1 must leave a stuck claim with an unmet equality.
module MUTANT
    imports VERIFICATION

  claim [transfer-success-mut]:
    <k> (#execute => #halt) ~> _ </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <ethereum>
      <evm>
        <output> _ => #buf(32, 1) </output>
        <statusCode> _ => EVMC_SUCCESS </statusCode>
        <callState>
          <program> StandardTokenRuntime </program>
          <jumpDests> #computeValidJumpDests(StandardTokenRuntime) </jumpDests>
          <id> ACCTID </id>
          <caller> CALLER_ID </caller>
          <callData> #abiCallData("transfer", #address(TO), #uint256(VALUE)) </callData>
          <callValue> 0 </callValue>
          <wordStack> .WordStack => ?_ </wordStack>
          <localMem> .Bytes => ?_ </localMem>
          <pc> 0 => ?_ </pc>
          <gas> #gas(_VGAS) => ?_ </gas>
          <memoryUsed> 0 => ?_ </memoryUsed>
          <static> false </static>
          ...
        </callState>
        <substate>
          <log> LOGS => LOGS ListItem(#abiEventLog(ACCTID, "Transfer", #indexed(#address(CALLER_ID)), #indexed(#address(TO)), #uint256(VALUE))) </log>
          <refund> _ => ?_ </refund>
          ...
        </substate>
        ...
      </evm>
      <network>
        <accounts>
          <account>
            <acctID> ACCTID </acctID>
            <code> StandardTokenRuntime </code>
            <storage> ACCT_STORAGE => ACCT_STORAGE [ #hashedLocation("Solidity", 1, CALLER_ID) <- BAL_FROM -Int VALUE ] [ #hashedLocation("Solidity", 1, TO) <- BAL_TO +Int VALUE +Int 1 ] </storage>
            <origStorage> _ => ?_ </origStorage>
            ...
          </account>
          ...
        </accounts>
        ...
      </network>
    </ethereum>
   requires #rangeAddress(ACCTID)
     andBool #rangeAddress(CALLER_ID)
     andBool #rangeAddress(TO)
     andBool #rangeUInt(256, VALUE)
     andBool CALLER_ID =/=Int TO
     andBool #hashedLocation("Solidity", 1, CALLER_ID) =/=Int #hashedLocation("Solidity", 1, TO)
     andBool VALUE >Int 0
     andBool BAL_FROM >=Int VALUE
     andBool BAL_TO +Int VALUE <Int pow256
     andBool BAL_FROM ==Int #lookup(ACCT_STORAGE, #hashedLocation("Solidity", 1, CALLER_ID))
     andBool BAL_TO   ==Int #lookup(ACCT_STORAGE, #hashedLocation("Solidity", 1, TO))

endmodule
