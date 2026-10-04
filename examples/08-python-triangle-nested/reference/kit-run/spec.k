requires "verification.k"
module SPEC
 imports VERIFICATION
 claim [inner]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 4, 0, 0, 4, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(NName) ListItem(IName) ListItem(JName) ListItem(CountName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 14 => 56 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 55 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(NId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(JId:Int)) ListItem(#PyObjectPointer(CountId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool NId <Int Next andBool NId =/=Int CodeId andBool (isSmallIntId(NId) orBool NId >=Int 4096) andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool JId <Int Next andBool JId =/=Int CodeId andBool (isSmallIntId(JId) orBool JId >=Int 4096) andBool objectAt(JId, REST) ==K #PyObject(#idInt, JImm:Bool, #PyLongObject(J:Int)) andBool CountId <Int Next andBool CountId =/=Int CodeId andBool (isSmallIntId(CountId) orBool CountId >=Int 4096) andBool objectAt(CountId, REST) ==K #PyObject(#idInt, CountImm:Bool, #PyLongObject(Count:Int)) andBool I >Int 0 andBool J >=Int 0 andBool 2 *Int Count +Int 2 *Int J +Int I *Int (I -Int 1) ==Int N *Int (N +Int 1)
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, N, 0, 0, N *Int (N +Int 1))
 [circularity]

 claim [outer]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 4, 0, 0, 4, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(NName) ListItem(IName) ListItem(JName) ListItem(CountName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 5 => 56 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 55 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(NId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(JId:Int)) ListItem(#PyObjectPointer(CountId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool NId <Int Next andBool NId =/=Int CodeId andBool (isSmallIntId(NId) orBool NId >=Int 4096) andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool JId <Int Next andBool JId =/=Int CodeId andBool (isSmallIntId(JId) orBool JId >=Int 4096) andBool objectAt(JId, REST) ==K #PyObject(#idInt, JImm:Bool, #PyLongObject(J:Int)) andBool CountId <Int Next andBool CountId =/=Int CodeId andBool (isSmallIntId(CountId) orBool CountId >=Int 4096) andBool objectAt(CountId, REST) ==K #PyObject(#idInt, CountImm:Bool, #PyLongObject(Count:Int)) andBool I >Int 0 andBool 2 *Int Count +Int I *Int (I +Int 1) ==Int N *Int (N +Int 1)
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, N, 0, 0, N *Int (N +Int 1))
 [circularity, depends(inner)]

 claim [entry-positive]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 4, 0, 0, 4, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(NName) ListItem(IName) ListItem(JName) ListItem(CountName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 0 => 56 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 55 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(NId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(JId:Int)) ListItem(#PyObjectPointer(CountId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool NId <Int Next andBool NId =/=Int CodeId andBool (isSmallIntId(NId) orBool NId >=Int 4096) andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool JId <Int Next andBool JId =/=Int CodeId andBool (isSmallIntId(JId) orBool JId >=Int 4096) andBool objectAt(JId, REST) ==K #PyObject(#idInt, JImm:Bool, #PyLongObject(J:Int)) andBool CountId <Int Next andBool CountId =/=Int CodeId andBool (isSmallIntId(CountId) orBool CountId >=Int 4096) andBool objectAt(CountId, REST) ==K #PyObject(#idInt, CountImm:Bool, #PyLongObject(Count:Int)) andBool N >Int 0
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, N, 0, 0, N *Int (N +Int 1))
 [depends(outer, inner)]

 claim [entry-nonpositive]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 4, 0, 0, 4, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(NName) ListItem(IName) ListItem(JName) ListItem(CountName),
 ListItem(38) ListItem(38) ListItem(38) ListItem(38), FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 0 => 56 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 55 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(NId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(JId:Int)) ListItem(#PyObjectPointer(CountId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool CodeId <Int Next andBool Next >=Int 4096 andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next andBool NId <Int Next andBool NId =/=Int CodeId andBool (isSmallIntId(NId) orBool NId >=Int 4096) andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int)) andBool IId <Int Next andBool IId =/=Int CodeId andBool (isSmallIntId(IId) orBool IId >=Int 4096) andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int)) andBool JId <Int Next andBool JId =/=Int CodeId andBool (isSmallIntId(JId) orBool JId >=Int 4096) andBool objectAt(JId, REST) ==K #PyObject(#idInt, JImm:Bool, #PyLongObject(J:Int)) andBool CountId <Int Next andBool CountId =/=Int CodeId andBool (isSmallIntId(CountId) orBool CountId >=Int 4096) andBool objectAt(CountId, REST) ==K #PyObject(#idInt, CountImm:Bool, #PyLongObject(Count:Int)) andBool N <=Int 0
 ensures tupleResult(?FinalNext -Int 1, ?FinalObjects, N, N, J, 0)
 

endmodule
