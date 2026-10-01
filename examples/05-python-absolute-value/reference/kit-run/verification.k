requires "semantics.k"
requires "subject.k"

module VERIFICATION-SUMMARIES
  imports ABS-SUBJECT
  imports BOOL

  syntax Int ::= absSpec(Int) [function, total]
  rule absSpec(A) => 0 -Int A requires A <Int 0
  rule absSpec(A) => A        requires notBool (A <Int 0)

  syntax Map ::= absFinalObjects(Int, Int) [function]
  rule absFinalObjects(A, RES)
    => (absHarnessInitialNextId()
          |-> #PyObject(#idTuple, false,
                #PyTupleObject(
                  ListItem(absHarnessAId())
                  ListItem(absHarnessAId()))))
       absHarnessInputObjects(A, RES)
    requires notBool (A <Int 0)
  rule absFinalObjects(A, RES)
    => (absHarnessInitialNextId()
          |-> #PyObject(#idTuple, false,
                #PyTupleObject(
                  ListItem(absHarnessAId())
                  ListItem(#idSmallInt(absSpec(A))))))
       absHarnessInputObjects(A, RES)
    requires A <Int 0 andBool isSmallIntValue(absSpec(A))
  rule absFinalObjects(A, RES)
    => (absHarnessInitialNextId() +Int 1
          |-> #PyObject(#idTuple, false,
                #PyTupleObject(
                  ListItem(absHarnessAId())
                  ListItem(absHarnessInitialNextId()))))
       (absHarnessInitialNextId()
          |-> #PyObject(#idInt, false, #PyLongObject(absSpec(A))))
       absHarnessInputObjects(A, RES)
    requires A <Int 0 andBool notBool isSmallIntValue(absSpec(A))

  syntax Int ::= absFinalTupleId(Int) [function]
  rule absFinalTupleId(A) => absHarnessInitialNextId()
    requires notBool (A <Int 0)
  rule absFinalTupleId(A) => absHarnessInitialNextId()
    requires A <Int 0 andBool isSmallIntValue(absSpec(A))
  rule absFinalTupleId(A) => absHarnessInitialNextId() +Int 1
    requires A <Int 0 andBool notBool isSmallIntValue(absSpec(A))

  syntax Int ::= absFinalNextId(Int) [function]
  rule absFinalNextId(A) => absHarnessInitialNextId() +Int 1
    requires notBool (A <Int 0)
  rule absFinalNextId(A) => absHarnessInitialNextId() +Int 1
    requires A <Int 0 andBool isSmallIntValue(absSpec(A))
  rule absFinalNextId(A) => absHarnessInitialNextId() +Int 2
    requires A <Int 0 andBool notBool isSmallIntValue(absSpec(A))

  syntax Int ::= absFinalResultId(Int) [function]
  rule absFinalResultId(A) => absHarnessAId()
    requires notBool (A <Int 0)
  rule absFinalResultId(A) => #idSmallInt(absSpec(A))
    requires A <Int 0 andBool isSmallIntValue(absSpec(A))
  rule absFinalResultId(A) => absHarnessInitialNextId()
    requires A <Int 0 andBool notBool isSmallIntValue(absSpec(A))

  syntax Int ::= absFinalInstructionPointer(Int) [function]
  rule absFinalInstructionPointer(A) => 24 requires notBool (A <Int 0)
  rule absFinalInstructionPointer(A) => 19 requires A <Int 0

  syntax Int ::= absFinalNextInstruction(Int) [function]
  rule absFinalNextInstruction(A) => 25 requires notBool (A <Int 0)
  rule absFinalNextInstruction(A) => 20 requires A <Int 0
endmodule

module VERIFICATION
  imports KPYC-SEMANTICS
  imports ABS-SUBJECT
  imports VERIFICATION-SUMMARIES
endmodule
