requires "semantics.k"
requires "program-helper.k"

module VERIFICATION-SUMMARIES
  imports INT

  // The mathematical meaning of the assignment in run.
  syntax Int ::= arithMix(Int, Int) [function, total]
  rule arithMix(A, B) => A *Int B +Int A -Int B
endmodule

module VERIFICATION
  imports VERIFICATION-SUMMARIES
  imports PROGRAM-HELPER
  imports KPYC-SEMANTICS
  imports BOOL

  // Candidate-specific call harness. The otherwise-unused preconfig cell
  // supplies symbolic Python integer arguments and records the real return.
  syntax Control ::= #runInputs(Int, Int, Int) [symbol(#runInputs)]
                   | #runActive(Int, Int, Int, MemoryAddress, MemoryAddress) [symbol(#runActive)]
                   | #runResult(Int, Int, Int) [symbol(#runResult)]
  syntax Continuation ::= "#captureRun" [symbol(#captureRun)]

  rule <k> #normalExit => #callPython(F, ListItem(#PyObjectPointer(N))
                                            ListItem(#PyObjectPointer(N +Int 1))
                                            ListItem(#PyObjectPointer(N +Int 2)),
                                     .List, 0, #captureRun) ~> #dispatch </k>
       <preconfig> #runInputs(A, B, R0) => #runActive(A, B, R0, N, N +Int 1) </preconfig>
       <fGlobals> G </fGlobals>
       <objects> Objs
              => (N          |-> #PyObject(#idInt, false, #PyLongObject(A)))
                 (N +Int 1   |-> #PyObject(#idInt, false, #PyLongObject(B)))
                 (N +Int 2   |-> #PyObject(#idInt, false, #PyLongObject(R0)))
                 Objs
       </objects>
       <nextId> N => N +Int 3 </nextId>
    requires dictGetItem(objectAt(G, Objs), String2Bytes("run")) ==K found(F)

  // Observe the exact returned tuple. Fixed semantics represents the third
  // integer either by a cached static id or by a freshly allocated int.
  rule <k> (#cReturn(#captureRun, V) ~> #dispatch) => #normalExit </k>
       <preconfig> #runActive(A, B, _, X, Y) => #runResult(A, B, Z -Int 21) </preconfig>
       <objects> (V |-> #PyObject(TT, false,
                                  #PyTupleObject(ListItem(X:Int)
                                                 ListItem(Y:Int)
                                                 ListItem(Z:Int))))
                 Objs
       </objects>
    requires TT ==Int #idTuple
     andBool isSmallIntId(Z)

  rule <k> (#cReturn(#captureRun, V) ~> #dispatch) => #normalExit </k>
       <preconfig> #runActive(A, B, _, X, Y) => #runResult(A, B, R) </preconfig>
       <objects> (V |-> #PyObject(TT, false,
                                  #PyTupleObject(ListItem(X:Int)
                                                 ListItem(Y:Int)
                                                 ListItem(Z:Int))))
                 (Z |-> #PyObject(TZ, false, #PyLongObject(R)))
                 Objs
       </objects>
    requires TT ==Int #idTuple
     andBool TZ ==Int #idInt
endmodule
