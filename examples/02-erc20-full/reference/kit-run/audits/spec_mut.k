requires "verification.k"

// Non-vacuity probe (audit-authored). Copy of [approve-success] with a
// deliberately FALSE postcondition: the approve() function sets
// allowed[caller][spender] = VALUE, but this mutation asserts the final
// stored value is (VALUE +Int 1). This is false for every satisfiable input
// (e.g. VALUE = 0). A discriminating proof must return notProved with a
// residual showing the unmet storage equality.
module SPEC_MUT
    imports VERIFICATION

    claim [approve-success-mut]:
      <kevm>
        <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
        <mode> NORMAL </mode>
        <schedule> SHANGHAI </schedule>
        <useGas> false </useGas>
        <ethereum>
          <evm>
            <output> _ => #buf(32, 1) </output>
            <statusCode> _ => EVMC_SUCCESS </statusCode>
            <callStack> .List </callStack>
            <callState>
              <program> #StandardTokenCode </program>
              <jumpDests> #computeValidJumpDests(#StandardTokenCode) </jumpDests>
              <id> ACCT_ID </id>
              <codeAddr> ACCT_ID </codeAddr>
              <caller> CALLER_ID </caller>
              <callData> #abiCallData("approve", #address(SPENDER), #uint256(VALUE)) </callData>
              <callValue> 0 </callValue>
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
              <log> LOGS => LOGS ListItem(#abiEventLog(ACCT_ID, "Approval", #indexed(#address(CALLER_ID)), #indexed(#address(SPENDER)), #uint256(VALUE))) </log>
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
                <storage> (#alw(CALLER_ID, SPENDER) |-> OLD_ALW) REST => (#alw(CALLER_ID, SPENDER) |-> (VALUE +Int 1)) REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(SPENDER) andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, OLD_ALW)

endmodule
