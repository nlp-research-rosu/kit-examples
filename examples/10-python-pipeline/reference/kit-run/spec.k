requires "verification.k"
module SPEC
 imports VERIFICATION
 claim [loop]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 6, 0, 0, 6, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(NName) ListItem(TName) ListItem(IName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 31 => 69 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 68 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(NId:Int)) ListItem(#PyObjectPointer(TId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool NId <Int Next andBool NId =/=Int CodeId andBool (isSmallIntId(NId) orBool NId >=Int 4096) andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int)) andBool TId <Int Next andBool TId =/=Int CodeId andBool (isSmallIntId(TId) orBool TId >=Int 4096) andBool objectAt(TId, REST) ==K #PyObject(#idInt, TImm:Bool, #PyLongObject(T:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool N >=Int 0 andBool I >=Int 0 andBool I <=Int N andBool Res ==Int I *Int T
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, N, T, N, N *Int T +Int A)
 [circularity]

 claim [entry-nonnegative-product-positive-n]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 6, 0, 0, 6, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(NName) ListItem(TName) ListItem(IName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 0 => 69 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 68 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(NId:Int)) ListItem(#PyObjectPointer(TId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool NId <Int Next andBool NId =/=Int CodeId andBool (isSmallIntId(NId) orBool NId >=Int 4096) andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int)) andBool TId <Int Next andBool TId =/=Int CodeId andBool (isSmallIntId(TId) orBool TId >=Int 4096) andBool objectAt(TId, REST) ==K #PyObject(#idInt, TImm:Bool, #PyLongObject(T:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool A *Int B >=Int 0 andBool N >Int 0
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, N, A *Int B, N, N *Int (A *Int B) +Int A)
 [depends(loop)]

 claim [entry-nonnegative-product-nonpositive-n]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 6, 0, 0, 6, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(NName) ListItem(TName) ListItem(IName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 0 => 69 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 68 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(NId:Int)) ListItem(#PyObjectPointer(TId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool NId <Int Next andBool NId =/=Int CodeId andBool (isSmallIntId(NId) orBool NId >=Int 4096) andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int)) andBool TId <Int Next andBool TId =/=Int CodeId andBool (isSmallIntId(TId) orBool TId >=Int 4096) andBool objectAt(TId, REST) ==K #PyObject(#idInt, TImm:Bool, #PyLongObject(T:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool A *Int B >=Int 0 andBool N <=Int 0
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, N, A *Int B, 0, A)
 

 claim [entry-negative-product-positive-n]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 6, 0, 0, 6, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(NName) ListItem(TName) ListItem(IName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 0 => 69 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 68 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(NId:Int)) ListItem(#PyObjectPointer(TId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool NId <Int Next andBool NId =/=Int CodeId andBool (isSmallIntId(NId) orBool NId >=Int 4096) andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int)) andBool TId <Int Next andBool TId =/=Int CodeId andBool (isSmallIntId(TId) orBool TId >=Int 4096) andBool objectAt(TId, REST) ==K #PyObject(#idInt, TImm:Bool, #PyLongObject(T:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool A *Int B <Int 0 andBool N >Int 0
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, N, 0 -Int (A *Int B), N, N *Int (0 -Int (A *Int B)) +Int A)
 [depends(loop)]

 claim [entry-negative-product-nonpositive-n]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 6, 0, 0, 6, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(NName) ListItem(TName) ListItem(IName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 0 => 69 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 68 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(NId:Int)) ListItem(#PyObjectPointer(TId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool NId <Int Next andBool NId =/=Int CodeId andBool (isSmallIntId(NId) orBool NId >=Int 4096) andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int)) andBool TId <Int Next andBool TId =/=Int CodeId andBool (isSmallIntId(TId) orBool TId >=Int 4096) andBool objectAt(TId, REST) ==K #PyObject(#idInt, TImm:Bool, #PyLongObject(T:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool A *Int B <Int 0 andBool N <=Int 0
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, N, 0 -Int (A *Int B), 0, A)
 

endmodule
