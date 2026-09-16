requires "verification.k"

module TRANSFER-SPEC
    imports VERIFICATION

  claim [transfer-success]:
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
            <storage> ACCT_STORAGE => ACCT_STORAGE [ #hashedLocation("Solidity", 1, CALLER_ID) <- BAL_FROM -Int VALUE ] [ #hashedLocation("Solidity", 1, TO) <- BAL_TO +Int VALUE ] </storage>
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

  claim [transfer-self]:
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
            <storage> ACCT_STORAGE => ACCT_STORAGE [ #hashedLocation("Solidity", 1, CALLER_ID) <- BAL_FROM ] </storage>
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
     andBool CALLER_ID ==Int TO
     andBool VALUE >Int 0
     andBool BAL_FROM >=Int VALUE
     andBool BAL_FROM ==Int #lookup(ACCT_STORAGE, #hashedLocation("Solidity", 1, CALLER_ID))

  claim [transfer-insufficient]:
    <k> (#execute => #halt) ~> _ </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <ethereum>
      <evm>
        <output> _ => #buf(32, 0) </output>
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
          <log> LOGS </log>
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
            <storage> ACCT_STORAGE </storage>
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
     andBool BAL_FROM <Int VALUE
     andBool BAL_FROM ==Int #lookup(ACCT_STORAGE, #hashedLocation("Solidity", 1, CALLER_ID))

  claim [transfer-not-payable]:
    <k> (#execute => #halt) ~> _ </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <ethereum>
      <evm>
        <output> _ => .Bytes </output>
        <statusCode> _ => EVMC_REVERT </statusCode>
        <callState>
          <program> StandardTokenRuntime </program>
          <jumpDests> #computeValidJumpDests(StandardTokenRuntime) </jumpDests>
          <id> ACCTID </id>
          <caller> CALLER_ID </caller>
          <callData> #abiCallData("transfer", #address(TO), #uint256(VALUE)) </callData>
          <callValue> CALL_VALUE </callValue>
          <wordStack> .WordStack => ?_ </wordStack>
          <localMem> .Bytes => ?_ </localMem>
          <pc> 0 => ?_ </pc>
          <gas> #gas(_VGAS) => ?_ </gas>
          <memoryUsed> 0 => ?_ </memoryUsed>
          <static> false </static>
          ...
        </callState>
        <substate>
          <log> LOGS </log>
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
            <storage> ACCT_STORAGE </storage>
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
     andBool #rangeUInt(256, CALL_VALUE)
     andBool CALL_VALUE >Int 0

  claim [transfer-overflow]:
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
            <storage> ACCT_STORAGE => ACCT_STORAGE [ #hashedLocation("Solidity", 1, CALLER_ID) <- BAL_FROM -Int VALUE ] [ #hashedLocation("Solidity", 1, TO) <- chop ( BAL_TO +Int VALUE ) ] </storage>
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
     andBool BAL_TO +Int VALUE >=Int pow256
     andBool BAL_FROM ==Int #lookup(ACCT_STORAGE, #hashedLocation("Solidity", 1, CALLER_ID))
     andBool BAL_TO   ==Int #lookup(ACCT_STORAGE, #hashedLocation("Solidity", 1, TO))

endmodule
