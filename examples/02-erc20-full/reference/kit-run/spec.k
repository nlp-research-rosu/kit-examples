requires "verification.k"

module SPEC
    imports VERIFICATION

    claim [approve-success]:
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
                <storage> (#alw(CALLER_ID, SPENDER) |-> OLD_ALW) REST => (#alw(CALLER_ID, SPENDER) |-> VALUE) REST </storage>
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

    claim [approve-revert-value]:
      <kevm>
        <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
        <mode> NORMAL </mode>
        <schedule> SHANGHAI </schedule>
        <useGas> false </useGas>
        <ethereum>
          <evm>
            <output> _ => .Bytes </output>
            <statusCode> _ => EVMC_REVERT </statusCode>
            <callStack> .List </callStack>
            <callState>
              <program> #StandardTokenCode </program>
              <jumpDests> #computeValidJumpDests(#StandardTokenCode) </jumpDests>
              <id> ACCT_ID </id>
              <codeAddr> ACCT_ID </codeAddr>
              <caller> CALLER_ID </caller>
              <callData> #abiCallData("approve", #address(SPENDER), #uint256(VALUE)) </callData>
              <callValue> VCALL_VALUE </callValue>
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
              <log> LOGS </log>
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
                <storage> REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(SPENDER) andBool #rangeUInt(256, VALUE) andBool VCALL_VALUE >Int 0 andBool #rangeUInt(256, VCALL_VALUE)

    claim [transfer-success]:
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
              <callData> #abiCallData("transfer", #address(TO), #uint256(VALUE)) </callData>
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
              <log> LOGS => LOGS ListItem(#abiEventLog(ACCT_ID, "Transfer", #indexed(#address(CALLER_ID)), #indexed(#address(TO)), #uint256(VALUE))) </log>
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
                <storage> (#bal(CALLER_ID) |-> BAL_FROM) (#bal(TO) |-> BAL_TO) REST => (#bal(CALLER_ID) |-> (BAL_FROM -Int VALUE)) (#bal(TO) |-> (BAL_TO +Int VALUE)) REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(TO) andBool CALLER_ID =/=Int TO andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM) andBool #rangeUInt(256, BAL_TO) andBool BAL_FROM >=Int VALUE andBool VALUE >Int 0 andBool BAL_TO +Int VALUE <Int pow256

    claim [transfer-success-self]:
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
              <callData> #abiCallData("transfer", #address(CALLER_ID), #uint256(VALUE)) </callData>
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
              <log> LOGS => LOGS ListItem(#abiEventLog(ACCT_ID, "Transfer", #indexed(#address(CALLER_ID)), #indexed(#address(CALLER_ID)), #uint256(VALUE))) </log>
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
                <storage> (#bal(CALLER_ID) |-> BAL_FROM) REST => (#bal(CALLER_ID) |-> BAL_FROM) REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM) andBool BAL_FROM >=Int VALUE andBool VALUE >Int 0

    claim [transfer-overflow]:
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
              <callData> #abiCallData("transfer", #address(TO), #uint256(VALUE)) </callData>
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
              <log> LOGS => LOGS ListItem(#abiEventLog(ACCT_ID, "Transfer", #indexed(#address(CALLER_ID)), #indexed(#address(TO)), #uint256(VALUE))) </log>
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
                <storage> (#bal(CALLER_ID) |-> BAL_FROM) (#bal(TO) |-> BAL_TO) REST => (#bal(CALLER_ID) |-> (BAL_FROM -Int VALUE)) (#bal(TO) |-> (BAL_TO +Int VALUE -Int pow256)) REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(TO) andBool CALLER_ID =/=Int TO andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM) andBool #rangeUInt(256, BAL_TO) andBool BAL_FROM >=Int VALUE andBool VALUE >Int 0 andBool BAL_TO +Int VALUE >=Int pow256

    claim [transfer-fail]:
      <kevm>
        <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
        <mode> NORMAL </mode>
        <schedule> SHANGHAI </schedule>
        <useGas> false </useGas>
        <ethereum>
          <evm>
            <output> _ => #buf(32, 0) </output>
            <statusCode> _ => EVMC_SUCCESS </statusCode>
            <callStack> .List </callStack>
            <callState>
              <program> #StandardTokenCode </program>
              <jumpDests> #computeValidJumpDests(#StandardTokenCode) </jumpDests>
              <id> ACCT_ID </id>
              <codeAddr> ACCT_ID </codeAddr>
              <caller> CALLER_ID </caller>
              <callData> #abiCallData("transfer", #address(TO), #uint256(VALUE)) </callData>
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
              <log> LOGS </log>
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
                <storage> (#bal(CALLER_ID) |-> BAL_FROM) REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(TO) andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM) andBool notBool (BAL_FROM >=Int VALUE andBool VALUE >Int 0)

    claim [transfer-revert-value]:
      <kevm>
        <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
        <mode> NORMAL </mode>
        <schedule> SHANGHAI </schedule>
        <useGas> false </useGas>
        <ethereum>
          <evm>
            <output> _ => .Bytes </output>
            <statusCode> _ => EVMC_REVERT </statusCode>
            <callStack> .List </callStack>
            <callState>
              <program> #StandardTokenCode </program>
              <jumpDests> #computeValidJumpDests(#StandardTokenCode) </jumpDests>
              <id> ACCT_ID </id>
              <codeAddr> ACCT_ID </codeAddr>
              <caller> CALLER_ID </caller>
              <callData> #abiCallData("transfer", #address(TO), #uint256(VALUE)) </callData>
              <callValue> VCALL_VALUE </callValue>
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
              <log> LOGS </log>
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
                <storage> REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(TO) andBool #rangeUInt(256, VALUE) andBool VCALL_VALUE >Int 0 andBool #rangeUInt(256, VCALL_VALUE)

    claim [transferFrom-success]:
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
              <callData> #abiCallData("transferFrom", #address(FROM), #address(TO), #uint256(VALUE)) </callData>
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
              <log> LOGS => LOGS ListItem(#abiEventLog(ACCT_ID, "Transfer", #indexed(#address(FROM)), #indexed(#address(TO)), #uint256(VALUE))) </log>
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
                <storage> (#bal(FROM) |-> BAL_FROM) (#bal(TO) |-> BAL_TO) (#alw(FROM, CALLER_ID) |-> ALLOW) REST => (#bal(FROM) |-> (BAL_FROM -Int VALUE)) (#bal(TO) |-> (BAL_TO +Int VALUE)) (#alw(FROM, CALLER_ID) |-> (ALLOW -Int VALUE)) REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(FROM) andBool #rangeAddress(TO) andBool FROM =/=Int TO andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM) andBool #rangeUInt(256, BAL_TO) andBool #rangeUInt(256, ALLOW) andBool BAL_FROM >=Int VALUE andBool ALLOW >=Int VALUE andBool VALUE >Int 0 andBool BAL_TO +Int VALUE <Int pow256

    claim [transferFrom-success-self]:
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
              <callData> #abiCallData("transferFrom", #address(FROM), #address(FROM), #uint256(VALUE)) </callData>
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
              <log> LOGS => LOGS ListItem(#abiEventLog(ACCT_ID, "Transfer", #indexed(#address(FROM)), #indexed(#address(FROM)), #uint256(VALUE))) </log>
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
                <storage> (#bal(FROM) |-> BAL_FROM) (#alw(FROM, CALLER_ID) |-> ALLOW) REST => (#bal(FROM) |-> BAL_FROM) (#alw(FROM, CALLER_ID) |-> (ALLOW -Int VALUE)) REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(FROM) andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM) andBool #rangeUInt(256, ALLOW) andBool BAL_FROM >=Int VALUE andBool ALLOW >=Int VALUE andBool VALUE >Int 0

    claim [transferFrom-overflow]:
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
              <callData> #abiCallData("transferFrom", #address(FROM), #address(TO), #uint256(VALUE)) </callData>
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
              <log> LOGS => LOGS ListItem(#abiEventLog(ACCT_ID, "Transfer", #indexed(#address(FROM)), #indexed(#address(TO)), #uint256(VALUE))) </log>
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
                <storage> (#bal(FROM) |-> BAL_FROM) (#bal(TO) |-> BAL_TO) (#alw(FROM, CALLER_ID) |-> ALLOW) REST => (#bal(FROM) |-> (BAL_FROM -Int VALUE)) (#bal(TO) |-> (BAL_TO +Int VALUE -Int pow256)) (#alw(FROM, CALLER_ID) |-> (ALLOW -Int VALUE)) REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(FROM) andBool #rangeAddress(TO) andBool FROM =/=Int TO andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM) andBool #rangeUInt(256, BAL_TO) andBool #rangeUInt(256, ALLOW) andBool BAL_FROM >=Int VALUE andBool ALLOW >=Int VALUE andBool VALUE >Int 0 andBool BAL_TO +Int VALUE >=Int pow256

    claim [transferFrom-fail]:
      <kevm>
        <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
        <mode> NORMAL </mode>
        <schedule> SHANGHAI </schedule>
        <useGas> false </useGas>
        <ethereum>
          <evm>
            <output> _ => #buf(32, 0) </output>
            <statusCode> _ => EVMC_SUCCESS </statusCode>
            <callStack> .List </callStack>
            <callState>
              <program> #StandardTokenCode </program>
              <jumpDests> #computeValidJumpDests(#StandardTokenCode) </jumpDests>
              <id> ACCT_ID </id>
              <codeAddr> ACCT_ID </codeAddr>
              <caller> CALLER_ID </caller>
              <callData> #abiCallData("transferFrom", #address(FROM), #address(TO), #uint256(VALUE)) </callData>
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
              <log> LOGS </log>
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
                <storage> (#bal(FROM) |-> BAL_FROM) (#alw(FROM, CALLER_ID) |-> ALLOW) REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(FROM) andBool #rangeAddress(TO) andBool #rangeUInt(256, VALUE) andBool #rangeUInt(256, BAL_FROM) andBool #rangeUInt(256, ALLOW) andBool notBool (BAL_FROM >=Int VALUE andBool ALLOW >=Int VALUE andBool VALUE >Int 0)

    claim [transferFrom-revert-value]:
      <kevm>
        <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
        <mode> NORMAL </mode>
        <schedule> SHANGHAI </schedule>
        <useGas> false </useGas>
        <ethereum>
          <evm>
            <output> _ => .Bytes </output>
            <statusCode> _ => EVMC_REVERT </statusCode>
            <callStack> .List </callStack>
            <callState>
              <program> #StandardTokenCode </program>
              <jumpDests> #computeValidJumpDests(#StandardTokenCode) </jumpDests>
              <id> ACCT_ID </id>
              <codeAddr> ACCT_ID </codeAddr>
              <caller> CALLER_ID </caller>
              <callData> #abiCallData("transferFrom", #address(FROM), #address(TO), #uint256(VALUE)) </callData>
              <callValue> VCALL_VALUE </callValue>
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
              <log> LOGS </log>
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
                <storage> REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(FROM) andBool #rangeAddress(TO) andBool #rangeUInt(256, VALUE) andBool VCALL_VALUE >Int 0 andBool #rangeUInt(256, VCALL_VALUE)

    claim [balanceOf-success]:
      <kevm>
        <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
        <mode> NORMAL </mode>
        <schedule> SHANGHAI </schedule>
        <useGas> false </useGas>
        <ethereum>
          <evm>
            <output> _ => #buf(32, BAL) </output>
            <statusCode> _ => EVMC_SUCCESS </statusCode>
            <callStack> .List </callStack>
            <callState>
              <program> #StandardTokenCode </program>
              <jumpDests> #computeValidJumpDests(#StandardTokenCode) </jumpDests>
              <id> ACCT_ID </id>
              <codeAddr> ACCT_ID </codeAddr>
              <caller> CALLER_ID </caller>
              <callData> #abiCallData("balanceOf", #address(OWNER)) </callData>
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
              <log> LOGS </log>
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
                <storage> (#bal(OWNER) |-> BAL) REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(OWNER) andBool #rangeUInt(256, BAL)

    claim [balanceOf-revert-value]:
      <kevm>
        <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
        <mode> NORMAL </mode>
        <schedule> SHANGHAI </schedule>
        <useGas> false </useGas>
        <ethereum>
          <evm>
            <output> _ => .Bytes </output>
            <statusCode> _ => EVMC_REVERT </statusCode>
            <callStack> .List </callStack>
            <callState>
              <program> #StandardTokenCode </program>
              <jumpDests> #computeValidJumpDests(#StandardTokenCode) </jumpDests>
              <id> ACCT_ID </id>
              <codeAddr> ACCT_ID </codeAddr>
              <caller> CALLER_ID </caller>
              <callData> #abiCallData("balanceOf", #address(OWNER)) </callData>
              <callValue> VCALL_VALUE </callValue>
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
              <log> LOGS </log>
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
                <storage> REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(OWNER) andBool VCALL_VALUE >Int 0 andBool #rangeUInt(256, VCALL_VALUE)

    claim [allowance-success]:
      <kevm>
        <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
        <mode> NORMAL </mode>
        <schedule> SHANGHAI </schedule>
        <useGas> false </useGas>
        <ethereum>
          <evm>
            <output> _ => #buf(32, ALLOW) </output>
            <statusCode> _ => EVMC_SUCCESS </statusCode>
            <callStack> .List </callStack>
            <callState>
              <program> #StandardTokenCode </program>
              <jumpDests> #computeValidJumpDests(#StandardTokenCode) </jumpDests>
              <id> ACCT_ID </id>
              <codeAddr> ACCT_ID </codeAddr>
              <caller> CALLER_ID </caller>
              <callData> #abiCallData("allowance", #address(OWNER), #address(SPENDER)) </callData>
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
              <log> LOGS </log>
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
                <storage> (#alw(OWNER, SPENDER) |-> ALLOW) REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(OWNER) andBool #rangeAddress(SPENDER) andBool #rangeUInt(256, ALLOW)

    claim [allowance-revert-value]:
      <kevm>
        <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
        <mode> NORMAL </mode>
        <schedule> SHANGHAI </schedule>
        <useGas> false </useGas>
        <ethereum>
          <evm>
            <output> _ => .Bytes </output>
            <statusCode> _ => EVMC_REVERT </statusCode>
            <callStack> .List </callStack>
            <callState>
              <program> #StandardTokenCode </program>
              <jumpDests> #computeValidJumpDests(#StandardTokenCode) </jumpDests>
              <id> ACCT_ID </id>
              <codeAddr> ACCT_ID </codeAddr>
              <caller> CALLER_ID </caller>
              <callData> #abiCallData("allowance", #address(OWNER), #address(SPENDER)) </callData>
              <callValue> VCALL_VALUE </callValue>
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
              <log> LOGS </log>
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
                <storage> REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeAddress(OWNER) andBool #rangeAddress(SPENDER) andBool VCALL_VALUE >Int 0 andBool #rangeUInt(256, VCALL_VALUE)

    claim [dispatch-short-calldata]:
      <kevm>
        <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
        <mode> NORMAL </mode>
        <schedule> SHANGHAI </schedule>
        <useGas> false </useGas>
        <ethereum>
          <evm>
            <output> _ => .Bytes </output>
            <statusCode> _ => EVMC_REVERT </statusCode>
            <callStack> .List </callStack>
            <callState>
              <program> #StandardTokenCode </program>
              <jumpDests> #computeValidJumpDests(#StandardTokenCode) </jumpDests>
              <id> ACCT_ID </id>
              <codeAddr> ACCT_ID </codeAddr>
              <caller> CALLER_ID </caller>
              <callData> CD </callData>
              <callValue> VCALL_VALUE </callValue>
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
              <log> LOGS </log>
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
                <storage> REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeUInt(256, VCALL_VALUE) andBool lengthBytes(CD) <Int 4

    claim [dispatch-unknown-selector]:
      <kevm>
        <k> #execute ~> CONTINUATION => #halt ~> CONTINUATION </k>
        <mode> NORMAL </mode>
        <schedule> SHANGHAI </schedule>
        <useGas> false </useGas>
        <ethereum>
          <evm>
            <output> _ => .Bytes </output>
            <statusCode> _ => EVMC_REVERT </statusCode>
            <callStack> .List </callStack>
            <callState>
              <program> #StandardTokenCode </program>
              <jumpDests> #computeValidJumpDests(#StandardTokenCode) </jumpDests>
              <id> ACCT_ID </id>
              <codeAddr> ACCT_ID </codeAddr>
              <caller> CALLER_ID </caller>
              <callData> #buf(4, SEL) </callData>
              <callValue> VCALL_VALUE </callValue>
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
              <log> LOGS </log>
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
                <storage> REST </storage>
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
      requires #rangeAddress(ACCT_ID) andBool ACCT_ID =/=Int 0 andBool #rangeAddress(CALLER_ID) andBool CALL_DEPTH <=Int 1024 andBool #rangeUInt(256, VCALL_VALUE) andBool 0 <=Int SEL andBool SEL <Int 4294967296 andBool SEL =/=Int 157198259 andBool SEL =/=Int 599290589 andBool SEL =/=Int 1889567281 andBool SEL =/=Int 2835717307 andBool SEL =/=Int 3714247998

endmodule
