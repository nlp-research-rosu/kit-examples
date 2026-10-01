requires "program.k"

module VERIFICATION-SUMMARIES
  imports PROGRAM

  // A total observational predicate for the returned heap shape. It does
  // not execute or replace program code: it is true exactly when the three
  // input objects retain their integer values and the returned object is a
  // tuple containing the original B object followed by the original A object
  // twice. The owise equation makes every non-matching heap false.
  syntax Bool ::= isSwapResult(Int, Int, Int, Int, Int, Int, Int, Map) [function, total]
  rule isSwapResult(A, B, R, AID, BID, RID, TUPLE,
         (AID |-> #PyObject(1026, false, #PyLongObject(A)))
         (BID |-> #PyObject(1026, false, #PyLongObject(B)))
         (RID |-> #PyObject(1026, false, #PyLongObject(R)))
         (TUPLE |-> #PyObject(1033, false,
                       #PyTupleObject(ListItem(BID) ListItem(AID) ListItem(AID))))
         _)
    => true
  rule isSwapResult(_, _, _, _, _, _, _, _) => false [owise]
endmodule

module VERIFICATION
  imports VERIFICATION-SUMMARIES

  // Candidate-specific caller boundary. The first constructor holds the
  // three mathematical input values until module initialization completes;
  // the second remembers their allocated object identities across the call.
  syntax KItem ::= #verificationInputs(Int, Int, Int) [symbol(#verificationInputs)]
  syntax Continuation ::= #verificationReturn(MemoryAddress, MemoryAddress, MemoryAddress) [symbol(#verificationReturn)]

  // After the supplied module has executed and bound `run`, allocate three
  // integer arguments and invoke that exact binding through the fixed
  // #callPython -> initializeLocals -> #pushFrame machinery.
  rule <k> #normalExit
         => #callPython(
              globalRef(Objs, G, b"run"),
              ListItem(#PyObjectPointer(N))
              ListItem(#PyObjectPointer(N +Int 1))
              ListItem(#PyObjectPointer(N +Int 2)),
              .List,
              0,
              #verificationReturn(N, N +Int 1, N +Int 2))
            ~> #dispatch
       </k>
       <preconfig> #verificationInputs(A, B, R) => .K </preconfig>
       <fGlobals> G </fGlobals>
       <objects>
         Objs
         => (N |-> #PyObject(#idInt, false, #PyLongObject(A)))
            ((N +Int 1) |-> #PyObject(#idInt, false, #PyLongObject(B)))
            ((N +Int 2) |-> #PyObject(#idInt, false, #PyLongObject(R)))
            Objs
       </objects>
       <nextId> N => N +Int 3 </nextId>
    requires globalRef(Objs, G, b"run") =/=Int 0
endmodule
