requires "semantics.k"
requires "program-helper.k"
module VERIFICATION-SUMMARIES
 imports PROGRAM-HELPER
 syntax Int ::= heapMax(Map) [function, total]
 rule heapMax((I:Int |-> _:KItem) M:Map) => maxInt(I, heapMax(M)) [concrete]
 rule heapMax(_) => 4095 [owise, concrete]
 syntax Bool ::= tupleResult(MemoryAddress, Map, Int, Int, Int, Int, Int, Int) [function]
 syntax Bool ::= tuplePayload(Payload, Map, Int, Int, Int, Int, Int, Int) [function]
 rule tupleResult(R, M, V0, V1, V2, V3, V4, V5) => tuplePayload(payloadOf(objectAt(R, M)), M, V0, V1, V2, V3, V4, V5)
 rule tuplePayload(#PyTupleObject(ListItem(R0:Int) ListItem(R1:Int) ListItem(R2:Int) ListItem(R3:Int) ListItem(R4:Int) ListItem(R5:Int)), M, V0, V1, V2, V3, V4, V5) => isIntObject(R0, M) andBool intValue(R0, M) ==Int V0 andBool isIntObject(R1, M) andBool intValue(R1, M) ==Int V1 andBool isIntObject(R2, M) andBool intValue(R2, M) ==Int V2 andBool isIntObject(R3, M) andBool intValue(R3, M) ==Int V3 andBool isIntObject(R4, M) andBool intValue(R4, M) ==Int V4 andBool isIntObject(R5, M) andBool intValue(R5, M) ==Int V5
endmodule
module VERIFICATION
 imports VERIFICATION-SUMMARIES
 imports MAP-SYMBOLIC
 rule objectAt(I, (J:Int |-> _:PyObject) M:Map) => objectAt(I, M)
   requires I =/=Int J [simplification]
 rule heapMax((I:Int |-> _:KItem) M:Map) => maxInt(I, heapMax(M)) [simplification]
 rule I:Int in_keys(M:Map) => false requires I >Int heapMax(M) [simplification]
endmodule
