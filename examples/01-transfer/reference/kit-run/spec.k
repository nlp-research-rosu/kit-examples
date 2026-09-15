requires "verification.k"

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

  // Claim 1 — Success (to != sender, no recipient overflow): sender balance decreases by value, recipient increases by value, returns true, emits Transfer.
  claim [transfer-success]:
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
            <storage> (#hashedLocation("Solidity", 1, MSG_SENDER) |-> (BAL_FROM => BAL_FROM -Int VALUE))
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
     andBool #hashedLocation("Solidity", 1, MSG_SENDER) =/=Int #hashedLocation("Solidity", 1, TO)   // distinct storage slots (keccak collision-resistance; see SCOPE.md)
     andBool VALUE >Int 0
     andBool BAL_FROM >=Int VALUE
     andBool BAL_TO +Int VALUE <Int pow256

  // Claim 2 — Self-transfer (to == sender): balance unchanged, returns true, emits Transfer.
  claim [transfer-self]:
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
          <callData> #abiCallData("transfer", #address(MSG_SENDER), #uint256(VALUE)) </callData>
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
          <log> LOGS => LOGS ListItem({ ACCTID | ListItem(TransferTopic0) ListItem(MSG_SENDER) ListItem(MSG_SENDER) | #buf(32, VALUE) }) </log>
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
            <storage> (#hashedLocation("Solidity", 1, MSG_SENDER) |-> BAL_FROM) _STORAGE </storage>
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
     andBool #rangeUInt(256, VALUE)
     andBool #rangeUInt(256, BAL_FROM)
     andBool VALUE >Int 0
     andBool BAL_FROM >=Int VALUE

  // Claim 3 — Insufficient balance (balances[sender] < value): returns false, no storage change, no log, normal RETURN (NOT a revert).
  claim [transfer-insufficient]:
    <k> (#execute => #halt) ~> _ </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <ethereum>
      <evm>
        <output> _ => #buf(32, 0) </output>
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
          <log> LOGS </log>
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
            <storage> (#hashedLocation("Solidity", 1, MSG_SENDER) |-> BAL_FROM) _STORAGE </storage>
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
     andBool BAL_FROM <Int VALUE

  // Claim 4 — Not payable: any nonzero call value reverts with empty output; no storage or log change.
  claim [transfer-not-payable]:
    <k> (#execute => #halt) ~> _ </k>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <useGas> true </useGas>
    <ethereum>
      <evm>
        <output> _ => .Bytes </output>
        <statusCode> _ => EVMC_REVERT </statusCode>
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
          <callValue> VAL_SENT </callValue>
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
          <log> LOGS </log>
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
            <storage> _STORAGE </storage>
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
     andBool #rangeUInt(256, VAL_SENT)
     andBool VAL_SENT >Int 0

  // Claim 5 — Recipient overflow (to != sender, balances[to]+value >= 2^256): recipient balance wraps to chop(balances[to]+value); still returns true and emits Transfer.
  claim [transfer-overflow]:
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
            <storage> (#hashedLocation("Solidity", 1, MSG_SENDER) |-> (BAL_FROM => BAL_FROM -Int VALUE))
                      (#hashedLocation("Solidity", 1, TO)   |-> (BAL_TO   => BAL_TO +Int VALUE -Int pow256)) _STORAGE </storage>
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
     andBool #hashedLocation("Solidity", 1, MSG_SENDER) =/=Int #hashedLocation("Solidity", 1, TO)   // distinct storage slots (keccak collision-resistance; see SCOPE.md)
     andBool VALUE >Int 0
     andBool BAL_FROM >=Int VALUE
     andBool BAL_TO +Int VALUE >=Int pow256

endmodule
