// transferFrom(address _from, address _to, uint256 _value)
//
// EIP-20: "Transfers _value amount of tokens from address _from to
// address _to, and MUST fire the Transfer event. The function SHOULD
// throw unless the _from account has deliberately authorized the sender.
// Transfers of 0 values MUST be treated as normal transfers."
//
// The implementation guards the transfer with
//     balances[from] >= value && allowed[from][msg.sender] >= value && value > 0
// and RETURNS FALSE (does not throw) when the guard fails.  On success it
// moves the balance, decrements the allowance, fires Transfer, returns
// true.  Zero-value transfers are rejected (deviation from EIP-20), and
// `balances[to] += value` is unchecked and wraps modulo 2^256
// (see [transferFrom.success.overflow]).
//
// Hashed-location distinctness preconditions encode collision-freedom of
// keccak256 for the distinct preimages involved; see out/VERIFICATION.md.

requires "verification.k"

module TRANSFERFROM-SPEC
    imports VERIFICATION

    // Success, from =/= to, no overflow: balances move, allowance decremented,
    // Transfer logged, returns true.  msg.sender may or may not equal from.
    claim [transferFrom.success]:
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
            <callData>   #abiCallData("transferFrom", #address(FROM_ID), #address(TO_ID), #uint256(VALUE)) </callData>
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
            <log>              PRIOR_LOG => PRIOR_LOG ListItem(#abiEventLog(ACCT_ID, "Transfer", #indexed(#address(FROM_ID)), #indexed(#address(TO_ID)), #uint256(VALUE))) </log>
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
              <storage> ACCT_STORAGE => ACCT_STORAGE [ LOC_BAL_FROM <- BAL_FROM -Int VALUE ]
                                                     [ LOC_BAL_TO   <- BAL_TO   +Int VALUE ]
                                                     [ LOC_ALLOW    <- ALLOW    -Int VALUE ] </storage>
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
       andBool #rangeAddress(FROM_ID)
       andBool #rangeAddress(TO_ID)
       andBool #rangeUInt(256, VALUE)
       andBool FROM_ID =/=Int TO_ID
       andBool LOC_BAL_FROM ==Int #hashedLocation("Solidity", 1, FROM_ID)
       andBool LOC_BAL_TO   ==Int #hashedLocation("Solidity", 1, TO_ID)
       andBool LOC_ALLOW    ==Int #hashedLocation("Solidity", 2, FROM_ID CALLER_ID)
       andBool LOC_BAL_FROM =/=Int LOC_BAL_TO
       andBool LOC_ALLOW    =/=Int LOC_BAL_FROM
       andBool LOC_ALLOW    =/=Int LOC_BAL_TO
       andBool BAL_FROM ==Int #lookup(ACCT_STORAGE, LOC_BAL_FROM)
       andBool BAL_TO   ==Int #lookup(ACCT_STORAGE, LOC_BAL_TO)
       andBool ALLOW    ==Int #lookup(ACCT_STORAGE, LOC_ALLOW)
       andBool 0 <Int VALUE
       andBool VALUE <=Int BAL_FROM
       andBool VALUE <=Int ALLOW
       andBool BAL_TO +Int VALUE <Int pow256

    // Success, self-transfer (from == to): balances[from] net unchanged,
    // allowance still decremented, Transfer logged, returns true.
    claim [transferFrom.success.self]:
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
            <callData>   #abiCallData("transferFrom", #address(FROM_ID), #address(FROM_ID), #uint256(VALUE)) </callData>
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
            <log>              PRIOR_LOG => PRIOR_LOG ListItem(#abiEventLog(ACCT_ID, "Transfer", #indexed(#address(FROM_ID)), #indexed(#address(FROM_ID)), #uint256(VALUE))) </log>
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
              <storage> ACCT_STORAGE => ACCT_STORAGE [ LOC_BAL_FROM <- BAL_FROM ]
                                                     [ LOC_ALLOW    <- ALLOW -Int VALUE ] </storage>
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
       andBool #rangeAddress(FROM_ID)
       andBool #rangeUInt(256, VALUE)
       andBool LOC_BAL_FROM ==Int #hashedLocation("Solidity", 1, FROM_ID)
       andBool LOC_ALLOW    ==Int #hashedLocation("Solidity", 2, FROM_ID CALLER_ID)
       andBool LOC_ALLOW    =/=Int LOC_BAL_FROM
       andBool BAL_FROM ==Int #lookup(ACCT_STORAGE, LOC_BAL_FROM)
       andBool ALLOW    ==Int #lookup(ACCT_STORAGE, LOC_ALLOW)
       andBool 0 <Int VALUE
       andBool VALUE <=Int BAL_FROM
       andBool VALUE <=Int ALLOW

    // Arithmetic edge case: recipient balance overflows and WRAPS modulo 2^256,
    // while the call still succeeds — faithful to the unchecked `+=`.
    claim [transferFrom.success.overflow]:
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
            <callData>   #abiCallData("transferFrom", #address(FROM_ID), #address(TO_ID), #uint256(VALUE)) </callData>
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
            <log>              PRIOR_LOG => PRIOR_LOG ListItem(#abiEventLog(ACCT_ID, "Transfer", #indexed(#address(FROM_ID)), #indexed(#address(TO_ID)), #uint256(VALUE))) </log>
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
              <storage> ACCT_STORAGE => ACCT_STORAGE [ LOC_BAL_FROM <- BAL_FROM -Int VALUE ]
                                                     [ LOC_BAL_TO   <- BAL_TO +Int VALUE -Int pow256 ]
                                                     [ LOC_ALLOW    <- ALLOW  -Int VALUE ] </storage>
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
       andBool #rangeAddress(FROM_ID)
       andBool #rangeAddress(TO_ID)
       andBool #rangeUInt(256, VALUE)
       andBool FROM_ID =/=Int TO_ID
       andBool LOC_BAL_FROM ==Int #hashedLocation("Solidity", 1, FROM_ID)
       andBool LOC_BAL_TO   ==Int #hashedLocation("Solidity", 1, TO_ID)
       andBool LOC_ALLOW    ==Int #hashedLocation("Solidity", 2, FROM_ID CALLER_ID)
       andBool LOC_BAL_FROM =/=Int LOC_BAL_TO
       andBool LOC_ALLOW    =/=Int LOC_BAL_FROM
       andBool LOC_ALLOW    =/=Int LOC_BAL_TO
       andBool BAL_FROM ==Int #lookup(ACCT_STORAGE, LOC_BAL_FROM)
       andBool BAL_TO   ==Int #lookup(ACCT_STORAGE, LOC_BAL_TO)
       andBool ALLOW    ==Int #lookup(ACCT_STORAGE, LOC_ALLOW)
       andBool 0 <Int VALUE
       andBool VALUE <=Int BAL_FROM
       andBool VALUE <=Int ALLOW
       andBool pow256 <=Int BAL_TO +Int VALUE

    // Failure: insufficient balance OR insufficient allowance OR zero value.
    // Returns false with EVMC_SUCCESS (does NOT throw — deviation from the
    // EIP-20 SHOULD-throw), storage and log unchanged.
    claim [transferFrom.failure]:
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
            <callData>   #abiCallData("transferFrom", #address(FROM_ID), #address(TO_ID), #uint256(VALUE)) </callData>
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
       andBool #rangeAddress(FROM_ID)
       andBool #rangeAddress(TO_ID)
       andBool #rangeUInt(256, VALUE)
       andBool BAL_FROM ==Int #lookup(ACCT_STORAGE, #hashedLocation("Solidity", 1, FROM_ID))
       andBool ALLOW    ==Int #lookup(ACCT_STORAGE, #hashedLocation("Solidity", 2, FROM_ID CALLER_ID))
       andBool ( BAL_FROM <Int VALUE orBool ALLOW <Int VALUE orBool VALUE ==Int 0 )

    // Revert: non-payable check.
    claim [transferFrom.revert.payable]:
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
            <callData>   #abiCallData("transferFrom", #address(FROM_ID), #address(TO_ID), #uint256(VALUE)) </callData>
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
       andBool #rangeAddress(FROM_ID)
       andBool #rangeAddress(TO_ID)
       andBool #rangeUInt(256, VALUE)
       andBool #rangeUInt(256, CALL_VALUE)
       andBool CALL_VALUE =/=Int 0

endmodule
