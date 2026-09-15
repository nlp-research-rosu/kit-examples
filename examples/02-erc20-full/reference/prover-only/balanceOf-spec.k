// balanceOf(address _owner)
//
// EIP-20: "Returns the account balance of another account with address
// _owner."
//
// The implementation returns balances[_owner] and modifies nothing.
//
// Storage layout (solc 0.4.x):
//   balances[A] is at keccak(#buf(32,A) ++ #buf(32,1))
//   which is #hashedLocation("Solidity", 1, A).

requires "verification.k"

module BALANCEOF-SPEC
    imports VERIFICATION

    // Success: returns balances[_owner]; storage and log unchanged.
    claim [balanceOf.success]:
      <k> #execute => #halt ... </k>
      <mode>     NORMAL   </mode>
      <schedule> ISTANBUL </schedule>
      <useGas>   false    </useGas>
      <ethereum>
        <evm>
          <output>          _ => #buf(32, BAL_OWNER) </output>
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
            <callData>   #abiCallData("balanceOf", #address(OWNER_ID)) </callData>
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
       andBool #rangeAddress(OWNER_ID)
       andBool BAL_OWNER ==Int #lookup(ACCT_STORAGE, #hashedLocation("Solidity", 1, OWNER_ID))

    // Revert: non-payable check.
    claim [balanceOf.revert.payable]:
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
            <callData>   #abiCallData("balanceOf", #address(OWNER_ID)) </callData>
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
       andBool #rangeAddress(OWNER_ID)
       andBool #rangeUInt(256, CALL_VALUE)
       andBool CALL_VALUE =/=Int 0

endmodule
