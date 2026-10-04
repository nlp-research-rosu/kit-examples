requires "semantics.k"
requires "program-helper.k"
module VERIFICATION-SUMMARIES
 imports PROGRAM-HELPER
 // Maximum Int key, with floor 4095. Other key sorts contribute no address.
 syntax Int ::= heapMax(Map) [function, total]
 rule heapMax((I:Int |-> _:KItem) M:Map)
   => maxInt(I, heapMax(M)) [concrete]
 rule heapMax(_) => 4095 [owise, concrete]
 syntax Bool ::= pairResult(MemoryAddress, Map, Int, Int) [function]
 syntax Bool ::= pairPayload(Payload, Map, Int, Int) [function]
 rule pairResult(R, M, N, TwiceS)
   => pairPayload(payloadOf(objectAt(R, M)), M, N, TwiceS)
 rule pairPayload(#PyTupleObject(ListItem(A:Int) ListItem(B:Int)), M, N, TwiceS)
   => isIntObject(A, M) andBool isIntObject(B, M)
      andBool intValue(A, M) ==Int N
      andBool 2 *Int intValue(B, M) ==Int TwiceS
endmodule
module VERIFICATION
 imports VERIFICATION-SUMMARIES
 imports MAP-SYMBOLIC
 // Reads through disjoint structural map entries preserve their value.
 rule objectAt(I, (J:Int |-> _:PyObject) M:Map) => objectAt(I, M)
   requires I =/=Int J [simplification]
 // Structural maximum is preserved when a fresh Int-key entry is added.
 rule heapMax((I:Int |-> _:KItem) M:Map) => maxInt(I, heapMax(M))
   [simplification]
 rule I:Int in_keys(M:Map) => false
   requires I >Int heapMax(M) [simplification]
 // Ring identity: 2S+2N+N^2-N = 2S+N^2+N, for all integers.
 rule (2 *Int (S:Int +Int N:Int)) +Int ((N +Int -1) *Int N)
   => (2 *Int S) +Int (N *Int (N +Int 1)) [simplification]
endmodule
