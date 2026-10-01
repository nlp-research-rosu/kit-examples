requires "semantics.k"

module ABS-SUBJECT
  imports KPYC-SEMANTICS

  // Exact contents of /app/program.kpyc.  Keeping the subject image in a
  // separate module makes the proof's connection to the supplied bytecode
  // explicit without modifying or uploading the bundled semantics.
  syntax KPyc ::= absSubjectProgram() [function, total]
  rule absSubjectProgram() => #Kpyc(b"3.14.6",b"2b0e0d0a",b"2",#MarshalCode(#CoArgcount(0),#CoPosonlyargcount(0),#CoKwonlyargcount(0),#CoStacksize(1),#CoFlags(0),#CoCode(#MarshalDef(0,#CoCodeValue(RESUME(0), LOAD_CONST(0), MAKE_FUNCTION(0), STORE_NAME(0), LOAD_CONST(1), RETURN_VALUE(0), .CoCodeValueItems))),#CoConsts(#MarshalTuple(#MarshalCode(#CoArgcount(2),#CoPosonlyargcount(0),#CoKwonlyargcount(0),#CoStacksize(2),#CoFlags(67108867),#CoCode(#MarshalDef(1,#CoCodeValue(RESUME(0), LOAD_FAST_BORROW(0), LOAD_SMALL_INT(0), COMPARE_OP(18), CACHE(0), POP_JUMP_IF_FALSE(13), CACHE(0), NOT_TAKEN(0), LOAD_SMALL_INT(0), LOAD_FAST_BORROW(0), BINARY_OP(10), CACHE(0), CACHE(0), CACHE(0), CACHE(0), CACHE(0), STORE_FAST(1), LOAD_FAST_BORROW_LOAD_FAST_BORROW(1), BUILD_TUPLE(2), RETURN_VALUE(0), LOAD_FAST(0), STORE_FAST(1), LOAD_FAST_BORROW_LOAD_FAST_BORROW(1), BUILD_TUPLE(2), RETURN_VALUE(0), .CoCodeValueItems))),#CoConsts(#MarshalTuple(#MarshalStr(b"Take integer state bindings; return final (a, res)."), .MarshalTupleItems)),#CoNames(#MarshalDef(2,#MarshalTuple(.MarshalTupleItems))),#CoLocalsplusnames(#MarshalTuple(#MarshalDef(3,#MarshalInternedStr(b"a")), #MarshalDef(4,#MarshalInternedStr(b"res")), .MarshalTupleItems)),#CoLocalspluskinds(#MarshalBytes(b"&&")),#CoFilename(#MarshalDef(5,#MarshalInternedStr(b"program/program.py"))),#CoName(#MarshalDef(6,#MarshalInternedStr(b"run"))),#CoQualname(#MarshalRef(6)),#CoFirstlineno(1),#CoLinetable(#MarshalBytes(b"\x80\x00\xe0\x07\x08\x881\x84u\xd8\x0e\x0f\x90!\x8de\x88\x03\xf0\x06\x00\x0c\x0d\x886\x80M\xf0\x03\x00\x0f\x10\x88\x03\xd8\x0b\x0c\x886\x80M")),#CoExceptiontable(#MarshalDef(7,#CoExceptiontableValue(.CoExceptiontableValueItems)))), #MarshalNone(), .MarshalTupleItems)),#CoNames(#MarshalTuple(#MarshalRef(6), .MarshalTupleItems)),#CoLocalsplusnames(#MarshalRef(2)),#CoLocalspluskinds(#MarshalRef(7)),#CoFilename(#MarshalRef(5)),#CoName(#MarshalDef(8,#MarshalInternedStr(b"<module>"))),#CoQualname(#MarshalRef(8)),#CoFirstlineno(1),#CoLinetable(#MarshalBytes(b"\xf0\x03\x01\x01\x01\xf4\x02\x06\x01\x12")),#CoExceptiontable(#MarshalRef(7))))

  syntax MarshalCode ::= absSubjectCode(KPyc) [function]
  rule absSubjectCode(#Kpyc(_, _, _, CODE)) => CODE

  syntax BootPlan ::= absHarnessBootPlan() [function]
  rule absHarnessBootPlan() => bootLoad(absSubjectCode(absSubjectProgram()), .Map, 4096)

  syntax Int ::= absHarnessModuleCodeId(BootPlan) [function]
  syntax Int ::= absHarnessGlobalsId(BootPlan) [function]
  syntax Int ::= absHarnessBuiltinsId(BootPlan) [function]
  syntax Map ::= absHarnessObjects(BootPlan) [function]
  syntax Int ::= absHarnessNextId(BootPlan) [function]
  rule absHarnessModuleCodeId(#bootPlan(C, _, _, _, _)) => C
  rule absHarnessGlobalsId(#bootPlan(_, G, _, _, _)) => G
  rule absHarnessBuiltinsId(#bootPlan(_, _, B, _, _)) => B
  rule absHarnessObjects(#bootPlan(_, _, _, OBJS, _)) => OBJS
  rule absHarnessNextId(#bootPlan(_, _, _, _, N)) => N

  syntax Int ::= absHarnessRunCodeId() [function]
  rule absHarnessRunCodeId()
    => {coConsts(codeOf(absHarnessModuleCodeId(absHarnessBootPlan()),
                       absHarnessObjects(absHarnessBootPlan())))[0]}:>Int

  syntax Int ::= absHarnessAId() [function]
  syntax Int ::= absHarnessResId() [function]
  rule absHarnessAId() => absHarnessNextId(absHarnessBootPlan())
  rule absHarnessResId() => absHarnessNextId(absHarnessBootPlan()) +Int 1

  syntax Map ::= absHarnessInputObjects(Int, Int) [function]
  rule absHarnessInputObjects(A, RES)
    => (absHarnessObjects(absHarnessBootPlan())
          [absHarnessAId() <- #PyObject(#idInt, false, #PyLongObject(A))])
          [absHarnessResId() <- #PyObject(#idInt, false, #PyLongObject(RES))]

  syntax Int ::= absHarnessInitialNextId() [function]
  rule absHarnessInitialNextId() => absHarnessNextId(absHarnessBootPlan()) +Int 2
endmodule
