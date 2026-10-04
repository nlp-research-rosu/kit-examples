requires "semantics.k"

module PROGRAM-HELPER
  imports KPYC-SEMANTICS

  // The exact decoded instruction map of the program-defined run function.
  syntax Map ::= targetRunCode() [function, total]
  rule targetRunCode() =>
      (0  |-> RESUME(0))
      (1  |-> LOAD_FAST_BORROW(0))
      (2  |-> LOAD_SMALL_INT(0))
      (3  |-> COMPARE_OP(58))
      (4  |-> CACHE(0))
      (5  |-> POP_JUMP_IF_TRUE(20))
      (6  |-> CACHE(0))
      (7  |-> NOT_TAKEN(0))
      (8  |-> LOAD_FAST_BORROW_LOAD_FAST_BORROW(16))
      (9  |-> BINARY_OP(0))
      (10 |-> CACHE(0)) (11 |-> CACHE(0)) (12 |-> CACHE(0))
      (13 |-> CACHE(0)) (14 |-> CACHE(0))
      (15 |-> STORE_FAST(1))
      (16 |-> LOAD_FAST_BORROW(0))
      (17 |-> LOAD_CONST(1))
      (18 |-> BINARY_OP(0))
      (19 |-> CACHE(0)) (20 |-> CACHE(0)) (21 |-> CACHE(0))
      (22 |-> CACHE(0)) (23 |-> CACHE(0))
      (24 |-> STORE_FAST(0))
      (25 |-> JUMP_BACKWARD(26))
      (26 |-> CACHE(0))
      (27 |-> LOAD_FAST_BORROW_LOAD_FAST_BORROW(1))
      (28 |-> BUILD_TUPLE(2))
      (29 |-> RETURN_VALUE(0))
endmodule
