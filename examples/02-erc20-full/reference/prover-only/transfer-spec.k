// transfer(address _to, uint256 _value)
//
// EIP-20: "Transfers _value amount of tokens to address _to, and MUST
// fire the Transfer event. The function SHOULD throw if the message
// caller's account balance does not have enough tokens to spend.
// Transfers of 0 values MUST be treated as normal transfers and fire
// the Transfer event."
//
// The implementation guards the transfer with
//     balances[msg.sender] >= value && value > 0
// and RETURNS FALSE (does not throw) when the guard fails.  It also
// rejects zero-value transfers (returns false, no event) — a documented
// deviation from EIP-20.  The addition `balances[to] += value` is
// unchecked and wraps modulo 2^256 (see [transfer.success.overflow]).
//
// Hashed-location distinctness preconditions (e.g. LOC_BAL_CALLER =/=Int
// LOC_BAL_TO) encode collision-freedom of keccak256 for the distinct
// preimages involved; see out/VERIFICATION.md for the soundness note.

requires "verification.k"

module TRANSFER-SPEC
    imports VERIFICATION

    // Success, distinct accounts, no overflow: balances move, Transfer logged, returns true.
    claim [transfer.success]:
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
            <callData>   #abiCallData("transfer", #address(TO_ID), #uint256(VALUE)) </callData>
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
            <log>              PRIOR_LOG => PRIOR_LOG ListItem(#abiEventLog(ACCT_ID, "Transfer", #indexed(#address(CALLER_ID)), #indexed(#address(TO_ID)), #uint256(VALUE))) </log>
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
              <storage> ACCT_STORAGE => ACCT_STORAGE [ LOC_BAL_CALLER <- BAL_CALLER -Int VALUE ]
                                                     [ LOC_BAL_TO     <- BAL_TO     +Int VALUE ] </storage>
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
       andBool #rangeAddress(TO_ID)
       andBool #rangeUInt(256, VALUE)
       andBool CALLER_ID =/=Int TO_ID
       andBool LOC_BAL_CALLER ==Int #hashedLocation("Solidity", 1, CALLER_ID)
       andBool LOC_BAL_TO     ==Int #hashedLocation("Solidity", 1, TO_ID)
       andBool LOC_BAL_CALLER =/=Int LOC_BAL_TO
       andBool BAL_CALLER ==Int #lookup(ACCT_STORAGE, LOC_BAL_CALLER)
       andBool BAL_TO     ==Int #lookup(ACCT_STORAGE, LOC_BAL_TO)
       andBool 0 <Int VALUE
       andBool VALUE <=Int BAL_CALLER
       andBool BAL_TO +Int VALUE <Int pow256

    // Success, self-transfer (to == msg.sender): balance unchanged, Transfer logged, returns true.
    claim [transfer.success.self]:
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
            <callData>   #abiCallData("transfer", #address(CALLER_ID), #uint256(VALUE)) </callData>
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
            <log>              PRIOR_LOG => PRIOR_LOG ListItem(#abiEventLog(ACCT_ID, "Transfer", #indexed(#address(CALLER_ID)), #indexed(#address(CALLER_ID)), #uint256(VALUE))) </log>
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
              <storage> ACCT_STORAGE => ACCT_STORAGE [ LOC_BAL_CALLER <- BAL_CALLER ] </storage>
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
       andBool #rangeUInt(256, VALUE)
       andBool LOC_BAL_CALLER ==Int #hashedLocation("Solidity", 1, CALLER_ID)
       andBool BAL_CALLER ==Int #lookup(ACCT_STORAGE, LOC_BAL_CALLER)
       andBool 0 <Int VALUE
       andBool VALUE <=Int BAL_CALLER

    // Arithmetic edge case: recipient balance overflows and WRAPS modulo 2^256.
    // The call still succeeds and fires Transfer — a deviation from any
    // reasonable token semantics, faithful to the unchecked `+=` in the code.
    claim [transfer.success.overflow]:
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
            <callData>   #abiCallData("transfer", #address(TO_ID), #uint256(VALUE)) </callData>
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
            <log>              PRIOR_LOG => PRIOR_LOG ListItem(#abiEventLog(ACCT_ID, "Transfer", #indexed(#address(CALLER_ID)), #indexed(#address(TO_ID)), #uint256(VALUE))) </log>
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
              <storage> ACCT_STORAGE => ACCT_STORAGE [ LOC_BAL_CALLER <- BAL_CALLER -Int VALUE ]
                                                     [ LOC_BAL_TO     <- BAL_TO +Int VALUE -Int pow256 ] </storage>
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
       andBool #rangeAddress(TO_ID)
       andBool #rangeUInt(256, VALUE)
       andBool CALLER_ID =/=Int TO_ID
       andBool LOC_BAL_CALLER ==Int #hashedLocation("Solidity", 1, CALLER_ID)
       andBool LOC_BAL_TO     ==Int #hashedLocation("Solidity", 1, TO_ID)
       andBool LOC_BAL_CALLER =/=Int LOC_BAL_TO
       andBool BAL_CALLER ==Int #lookup(ACCT_STORAGE, LOC_BAL_CALLER)
       andBool BAL_TO     ==Int #lookup(ACCT_STORAGE, LOC_BAL_TO)
       andBool 0 <Int VALUE
       andBool VALUE <=Int BAL_CALLER
       andBool pow256 <=Int BAL_TO +Int VALUE

    // Failure: insufficient balance OR zero value.  Returns false with
    // EVMC_SUCCESS (does NOT throw — deviation from EIP-20 SHOULD-throw),
    // storage and log unchanged.
    claim [transfer.failure]:
      <k> #execute => #halt ... </k>
      <mode>     NORMAL   </mode>
      <schedule> ISTANBUL </schedule>
      <useGas>   false    </useGas>
      <ethereum>
        <evm>
          <output>          _ => #buf(32, 0)   </output>
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
            <callData>   #abiCallData("transfer", #address(TO_ID), #uint256(VALUE)) </callData>
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
       andBool #rangeAddress(TO_ID)
       andBool #rangeUInt(256, VALUE)
       andBool BAL_CALLER ==Int #lookup(ACCT_STORAGE, #hashedLocation("Solidity", 1, CALLER_ID))
       andBool ( BAL_CALLER <Int VALUE orBool VALUE ==Int 0 )

    // Revert: non-payable check.
    claim [transfer.revert.payable]:
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
            <callData>   #abiCallData("transfer", #address(TO_ID), #uint256(VALUE)) </callData>
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
       andBool #rangeAddress(TO_ID)
       andBool #rangeUInt(256, VALUE)
       andBool #rangeUInt(256, CALL_VALUE)
       andBool CALL_VALUE =/=Int 0

endmodule
