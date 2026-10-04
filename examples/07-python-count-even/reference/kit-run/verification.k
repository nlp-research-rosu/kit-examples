requires "semantics.k"
requires "program-helper.k"
module VERIFICATION-SUMMARIES
 imports PROGRAM-HELPER
 syntax Int ::= heapMax(Map) [function, total]
 rule heapMax((I:Int |-> _:KItem) M:Map) => maxInt(I, heapMax(M)) [concrete]
 rule heapMax(_) => 4095 [owise, concrete]
 syntax Bool ::= tripleResult(MemoryAddress, Map, Int, Int, Int) [function]
 syntax Bool ::= triplePayload(Payload, Map, Int, Int, Int) [function]
 rule tripleResult(R, M, N, I, TwiceCount)
   => triplePayload(payloadOf(objectAt(R, M)), M, N, I, TwiceCount)
 rule triplePayload(#PyTupleObject(ListItem(A:Int) ListItem(B:Int) ListItem(C:Int)), M, N, I, TwiceCount)
   => isIntObject(A, M) andBool isIntObject(B, M) andBool isIntObject(C, M)
      andBool intValue(A, M) ==Int N andBool intValue(B, M) ==Int I
      andBool 2 *Int intValue(C, M) ==Int TwiceCount
endmodule
module VERIFICATION
 imports VERIFICATION-SUMMARIES
 imports MAP-SYMBOLIC
 rule objectAt(I, (J:Int |-> _:PyObject) M:Map) => objectAt(I, M)
   requires I =/=Int J [simplification]
 rule heapMax((I:Int |-> _:KItem) M:Map) => maxInt(I, heapMax(M)) [simplification]
 rule I:Int in_keys(M:Map) => false requires I >Int heapMax(M) [simplification]
endmodule
