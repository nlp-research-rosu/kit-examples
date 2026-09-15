// Function dispatcher / fallback behavior.
//
// The contract has no fallback function, so solc 0.4.x emits a dispatcher
// that reverts when:
//   (a) calldata is shorter than 4 bytes, or
//   (b) the 4-byte selector matches none of the five external functions:
//         approve(address,uint256)                 0x095ea7b3 = 157198259
//         transferFrom(address,address,uint256)    0x23b872dd = 599290589
//         balanceOf(address)                       0x70a08231 = 1889567281
//         transfer(address,uint256)                0xa9059cbb = 2835717307
//         allowance(address,address)               0xdd62ed3e = 3714247998
// In both cases nothing is written and no event is logged.

requires "verification.k"

module DISPATCH-SPEC
    imports VERIFICATION

    // Calldata shorter than 4 bytes: revert.
    claim [dispatch.revert.short-calldata]:
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
            <callData>   CD         </callData>
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
       andBool #rangeUInt(256, CALL_VALUE)
       andBool lengthBytes(CD) <Int 4

    // Unknown 4-byte selector: revert.  The claim takes exactly 4 bytes of
    // calldata carrying a symbolic selector distinct from all five known ones.
    claim [dispatch.revert.unknown-selector]:
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
            <callData>   #buf(4, SELECTOR) </callData>
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
       andBool #rangeUInt(256, CALL_VALUE)
       andBool #rangeUInt(32, SELECTOR)
       andBool SELECTOR =/=Int 157198259   // approve(address,uint256)
       andBool SELECTOR =/=Int 599290589   // transferFrom(address,address,uint256)
       andBool SELECTOR =/=Int 1889567281  // balanceOf(address)
       andBool SELECTOR =/=Int 2835717307  // transfer(address,uint256)
       andBool SELECTOR =/=Int 3714247998  // allowance(address,address)

endmodule
