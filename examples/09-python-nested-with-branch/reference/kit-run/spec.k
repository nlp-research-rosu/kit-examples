requires "verification.k"
module SPEC
 imports VERIFICATION
 claim [inner-a]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 5, 0, 0, 5, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(IName) ListItem(JName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 20 => 65 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 64 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(JId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool JId <Int Next andBool JId =/=Int CodeId andBool (isSmallIntId(JId) orBool JId >=Int 4096) andBool objectAt(JId, REST) ==K #PyObject(#idInt, JImm:Bool, #PyLongObject(J:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool A >Int 0 andBool A <=Int B andBool I >Int 0 andBool I <=Int B andBool J >=Int 0 andBool 2 *Int Res +Int 2 *Int J +Int I *Int (I -Int 1) ==Int A *Int (A +Int 1)
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, 0, 0, A *Int (A +Int 1))
 [circularity]

 claim [outer-within-a]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 5, 0, 0, 5, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(IName) ListItem(JName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 5 => 65 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 64 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(JId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool JId <Int Next andBool JId =/=Int CodeId andBool (isSmallIntId(JId) orBool JId >=Int 4096) andBool objectAt(JId, REST) ==K #PyObject(#idInt, JImm:Bool, #PyLongObject(J:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool A >Int 0 andBool A <=Int B andBool I >Int 0 andBool I <=Int B andBool 2 *Int Res +Int I *Int (I +Int 1) ==Int A *Int (A +Int 1)
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, 0, 0, A *Int (A +Int 1))
 [circularity, depends(inner-a)]

 claim [inner-b]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 5, 0, 0, 5, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(IName) ListItem(JName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 20 => 65 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 64 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(JId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool JId <Int Next andBool JId =/=Int CodeId andBool (isSmallIntId(JId) orBool JId >=Int 4096) andBool objectAt(JId, REST) ==K #PyObject(#idInt, JImm:Bool, #PyLongObject(J:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool A >Int B andBool B >Int 0 andBool I >Int 0 andBool I <=Int B andBool J >=Int 0 andBool 2 *Int Res +Int 2 *Int J +Int I *Int (I -Int 1) ==Int B *Int (B +Int 1)
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, 0, 0, B *Int (B +Int 1))
 [circularity]

 claim [outer-within-b]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 5, 0, 0, 5, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(IName) ListItem(JName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 5 => 65 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 64 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(JId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool JId <Int Next andBool JId =/=Int CodeId andBool (isSmallIntId(JId) orBool JId >=Int 4096) andBool objectAt(JId, REST) ==K #PyObject(#idInt, JImm:Bool, #PyLongObject(J:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool A >Int B andBool B >Int 0 andBool I >Int 0 andBool I <=Int B andBool 2 *Int Res +Int I *Int (I +Int 1) ==Int B *Int (B +Int 1)
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, 0, 0, B *Int (B +Int 1))
 [circularity, depends(inner-b)]

 claim [outer-above]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 5, 0, 0, 5, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(IName) ListItem(JName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 5 => 65 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 64 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(JId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool JId <Int Next andBool JId =/=Int CodeId andBool (isSmallIntId(JId) orBool JId >=Int 4096) andBool objectAt(JId, REST) ==K #PyObject(#idInt, JImm:Bool, #PyLongObject(J:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool A >Int B andBool B >Int 0 andBool I >Int B andBool Res ==Int 0
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, 0, 0, B *Int (B +Int 1))
 [circularity, depends(inner-b, outer-within-b)]

 claim [outer-disabled]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 5, 0, 0, 5, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(IName) ListItem(JName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 5 => 65 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 64 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(JId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool JId <Int Next andBool JId =/=Int CodeId andBool (isSmallIntId(JId) orBool JId >=Int 4096) andBool objectAt(JId, REST) ==K #PyObject(#idInt, JImm:Bool, #PyLongObject(J:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool I >=Int 0 andBool B <=Int 0 andBool Res ==Int 0
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, 0, J, 0)
 [circularity]

 claim [entry-nonpositive-a]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 5, 0, 0, 5, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(IName) ListItem(JName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 0 => 65 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 64 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(JId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool JId <Int Next andBool JId =/=Int CodeId andBool (isSmallIntId(JId) orBool JId >=Int 4096) andBool objectAt(JId, REST) ==K #PyObject(#idInt, JImm:Bool, #PyLongObject(J:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool A <=Int 0
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, A, J, 0)
 

 claim [entry-disabled]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 5, 0, 0, 5, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(IName) ListItem(JName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 0 => 65 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 64 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(JId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool JId <Int Next andBool JId =/=Int CodeId andBool (isSmallIntId(JId) orBool JId >=Int 4096) andBool objectAt(JId, REST) ==K #PyObject(#idInt, JImm:Bool, #PyLongObject(J:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool A >Int 0 andBool B <=Int 0
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, 0, J, 0)
 [depends(outer-disabled)]

 claim [entry-within]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 5, 0, 0, 5, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(IName) ListItem(JName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 0 => 65 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 64 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(JId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool JId <Int Next andBool JId =/=Int CodeId andBool (isSmallIntId(JId) orBool JId >=Int 4096) andBool objectAt(JId, REST) ==K #PyObject(#idInt, JImm:Bool, #PyLongObject(J:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool A >Int 0 andBool A <=Int B
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, 0, 0, A *Int (A +Int 1))
 [depends(inner-a, outer-within-a)]

 claim [entry-above]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 5, 0, 0, 5, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(AName) ListItem(BName) ListItem(IName) ListItem(JName) ListItem(ResName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 0 => 65 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 64 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(AId:Int)) ListItem(#PyObjectPointer(BId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(JId:Int)) ListItem(#PyObjectPointer(ResId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool AId <Int Next andBool AId =/=Int CodeId andBool (isSmallIntId(AId) orBool AId >=Int 4096) andBool objectAt(AId, REST) ==K #PyObject(#idInt, AImm:Bool, #PyLongObject(A:Int)) andBool BId <Int Next andBool BId =/=Int CodeId andBool (isSmallIntId(BId) orBool BId >=Int 4096) andBool objectAt(BId, REST) ==K #PyObject(#idInt, BImm:Bool, #PyLongObject(B:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool JId <Int Next andBool JId =/=Int CodeId andBool (isSmallIntId(JId) orBool JId >=Int 4096) andBool objectAt(JId, REST) ==K #PyObject(#idInt, JImm:Bool, #PyLongObject(J:Int)) andBool ResId <Int Next andBool ResId =/=Int CodeId andBool (isSmallIntId(ResId) orBool ResId >=Int 4096) andBool objectAt(ResId, REST) ==K #PyObject(#idInt, ResImm:Bool, #PyLongObject(Res:Int)) andBool A >Int B andBool B >Int 0
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, A, B, 0, 0, B *Int (B +Int 1))
 [depends(inner-b, outer-within-b, outer-above)]

endmodule
