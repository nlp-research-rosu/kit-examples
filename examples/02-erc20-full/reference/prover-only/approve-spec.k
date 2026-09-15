// approve(address _spender, uint256 _value)
//
// EIP-20: "Allows _spender to withdraw from your account multiple times,
// up to the _value amount. If this function is called again it overwrites
// the current allowance with _value. ... MUST trigger the Approval event
// on any successful call."
//
// The implementation stores `allowed[msg.sender][_spender] = _value`
// unconditionally (any value, including 0, and independently of the
// current allowance), fires Approval, and returns true.
//
// Storage layout (solc 0.4.x):
//   allowed[O][S] is at keccak(#buf(32,S) ++ #buf(32, keccak(#buf(32,O) ++ #buf(32,2))))
//   which is #hashedLocation("Solidity", 2, O S).

requires "verification.k"

module APPROVE-SPEC
    imports VERIFICATION

    // Success: any (spender, value); allowance slot overwritten; Approval logged; returns true.
    claim [approve.success]:
      <k> #execute => #halt ... </k>
      <mode>     NORMAL   </mode>
      <schedule> ISTANBUL </schedule>
      <useGas>   false    </useGas>
      <ethereum>
        <evm>
          <output>          _ => #buf(32, 1)   </output>
          <statusCode>      _ => EVMC_SUCCESS  </statusCode>
          <callStack>       _                  </callStack>
          <interimStates>   _                  </interimStates>
          <touchedAccounts> _ => ?_            </touchedAccounts>
          <callState>
            <program>    Token_bin_runtime                          </program>
            <jumpDests>  #computeValidJumpDests(Token_bin_runtime)  </jumpDests>
            <id>         ACCT_ID    </id>
            <codeAddr>   ACCT_ID    </codeAddr>
            <caller>     CALLER_ID  </caller>
            <callData>   #abiCallData("approve", #address(SPENDER_ID), #uint256(VALUE)) </callData>
            <callValue>  0          </callValue>
            <wordStack>  .WordStack => ?_ </wordStack>
            <localMem>   .Bytes     => ?_ </localMem>
            <pc>         0          => ?_ </pc>
            <gas>        _          => ?_ </gas>
            <memoryUsed> 0          => ?_ </memoryUsed>
            <callGas>    _          => ?_ </callGas>
            <static>     false      </static>
            <callDepth>  _          </callDepth>
          </callState>
          <versionedHashes> _ </versionedHashes>
          <substate>
            <selfDestruct>     _ </selfDestruct>
            <log>              PRIOR_LOG => PRIOR_LOG ListItem(#abiEventLog(ACCT_ID, "Approval", #indexed(#address(CALLER_ID)), #indexed(#address(SPENDER_ID)), #uint256(VALUE))) </log>
            <refund>           _ => ?_ </refund>
            <accessedAccounts> _ => ?_ </accessedAccounts>
            <accessedStorage>  _ => ?_ </accessedStorage>
            <createdAccounts>  _ => ?_ </createdAccounts>
          </substate>
          ...
        </evm>
        <network>
          <accounts>
            <account>
              <acctID>  ACCT_ID           </acctID>
              <balance> _                 </balance>
              <code>    Token_bin_runtime </code>
              <storage> ACCT_STORAGE => ACCT_STORAGE [ LOC_ALLOW <- VALUE ] </storage>
              <origStorage> _             </origStorage>
              <nonce>       _             </nonce>
              <transientStorage> _        </transientStorage>
            </account>
            ...
          </accounts>
          ...
        </network>
      </ethereum>
      requires #rangeAddress(ACCT_ID)
       andBool #rangeAddress(CALLER_ID)
       andBool #rangeAddress(SPENDER_ID)
       andBool #rangeUInt(256, VALUE)
       andBool LOC_ALLOW ==Int #hashedLocation("Solidity", 2, CALLER_ID SPENDER_ID)

    // Revert: the function is non-payable; any call with nonzero value reverts
    // before reaching the function body, leaving storage untouched.
    claim [approve.revert.payable]:
      <k> #execute => #halt ... </k>
      <mode>     NORMAL   </mode>
      <schedule> ISTANBUL </schedule>
      <useGas>   false    </useGas>
      <ethereum>
        <evm>
          <output>          _ => .Bytes       </output>
          <statusCode>      _ => EVMC_REVERT  </statusCode>
          <callStack>       _                 </callStack>
          <interimStates>   _                 </interimStates>
          <touchedAccounts> _ => ?_           </touchedAccounts>
          <callState>
            <program>    Token_bin_runtime                          </program>
            <jumpDests>  #computeValidJumpDests(Token_bin_runtime)  </jumpDests>
            <id>         ACCT_ID    </id>
            <codeAddr>   ACCT_ID    </codeAddr>
            <caller>     CALLER_ID  </caller>
            <callData>   #abiCallData("approve", #address(SPENDER_ID), #uint256(VALUE)) </callData>
            <callValue>  CALL_VALUE </callValue>
            <wordStack>  .WordStack => ?_ </wordStack>
            <localMem>   .Bytes     => ?_ </localMem>
            <pc>         0          => ?_ </pc>
            <gas>        _          => ?_ </gas>
            <memoryUsed> 0          => ?_ </memoryUsed>
            <callGas>    _          => ?_ </callGas>
            <static>     false      </static>
            <callDepth>  _          </callDepth>
          </callState>
          <versionedHashes> _ </versionedHashes>
          <substate>
            <selfDestruct>     _       </selfDestruct>
            <log>              _       </log>
            <refund>           _ => ?_ </refund>
            <accessedAccounts> _ => ?_ </accessedAccounts>
            <accessedStorage>  _ => ?_ </accessedStorage>
            <createdAccounts>  _ => ?_ </createdAccounts>
          </substate>
          ...
        </evm>
        <network>
          <accounts>
            <account>
              <acctID>  ACCT_ID           </acctID>
              <balance> _                 </balance>
              <code>    Token_bin_runtime </code>
              <storage> ACCT_STORAGE      </storage>
              <origStorage> _             </origStorage>
              <nonce>       _             </nonce>
              <transientStorage> _        </transientStorage>
            </account>
            ...
          </accounts>
          ...
        </network>
      </ethereum>
      requires #rangeAddress(ACCT_ID)
       andBool #rangeAddress(CALLER_ID)
       andBool #rangeAddress(SPENDER_ID)
       andBool #rangeUInt(256, VALUE)
       andBool #rangeUInt(256, CALL_VALUE)
       andBool CALL_VALUE =/=Int 0

endmodule
