requires "verification.k"
module SPEC
 imports VERIFICATION
 claim [loop]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 3, 0, 0, 3, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(NNameId) ListItem(INameId) ListItem(CountNameId),
 ListItem(38) ListItem(38) ListItem(38),
 FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 5 => 51 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 50 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(NId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(CountId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool Next >=Int 4096
  andBool CodeId <Int Next andBool NId <Int Next andBool IId <Int Next andBool CountId <Int Next
  andBool NId =/=Int CodeId andBool IId =/=Int CodeId andBool CountId =/=Int CodeId
  andBool (isSmallIntId(NId) orBool NId >=Int 4096)
  andBool (isSmallIntId(IId) orBool IId >=Int 4096)
  andBool (isSmallIntId(CountId) orBool CountId >=Int 4096)
  andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int))
  andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int))
  andBool objectAt(CountId, REST) ==K #PyObject(#idInt, CountImm:Bool, #PyLongObject(Count:Int))
  andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next
  andBool N >=Int 0 andBool I >=Int 0 andBool I <=Int N andBool 2 *Int Count ==Int I +Int (I modInt 2)
 ensures tripleResult(?FinalNext -Int 1, ?FinalObjects, N, N, N +Int (N modInt 2))
 [circularity]

 claim [entry-nonnegative]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 3, 0, 0, 3, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(NNameId) ListItem(INameId) ListItem(CountNameId),
 ListItem(38) ListItem(38) ListItem(38),
 FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 0 => 51 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 50 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(NId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(CountId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool Next >=Int 4096
  andBool CodeId <Int Next andBool NId <Int Next andBool IId <Int Next andBool CountId <Int Next
  andBool NId =/=Int CodeId andBool IId =/=Int CodeId andBool CountId =/=Int CodeId
  andBool (isSmallIntId(NId) orBool NId >=Int 4096)
  andBool (isSmallIntId(IId) orBool IId >=Int 4096)
  andBool (isSmallIntId(CountId) orBool CountId >=Int 4096)
  andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int))
  andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int))
  andBool objectAt(CountId, REST) ==K #PyObject(#idInt, CountImm:Bool, #PyLongObject(Count:Int))
  andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next
  andBool N >=Int 0
 ensures tripleResult(?FinalNext -Int 1, ?FinalObjects, N, N, N +Int (N modInt 2))
 [depends(loop)]

 claim [entry-negative]:
 <k> #dispatch => #normalExit </k>
 <memory>
 <objects> (((CodeId |-> #PyObject(#idCode, false, #PyCodeObject(
 3, 0, 0, 3, 67108867, targetRunCode(),
 ListItem(DocId), .List, ListItem(NNameId) ListItem(INameId) ListItem(CountNameId),
 ListItem(38) ListItem(38) ListItem(38),
 FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
 <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
 <nextInstruction> 0 => 51 </nextInstruction>
 <currentFrame>
 <fExecutable> CodeId:Int </fExecutable>
 <instructionPointer> IP:Int => 50 </instructionPointer>
 <localsplus> (ListItem(#PyObjectPointer(NId:Int)) ListItem(#PyObjectPointer(IId:Int)) ListItem(#PyObjectPointer(CountId:Int)) .List => ?Locals:List) </localsplus>
 <stack> .List </stack>
 ...
 </currentFrame>
 <previousFrames> .List </previousFrames>
 ...
 </tstate></threads>...</interpreter></interpreters>
 requires CodeId >=Int 4096 andBool Next >=Int 4096
  andBool CodeId <Int Next andBool NId <Int Next andBool IId <Int Next andBool CountId <Int Next
  andBool NId =/=Int CodeId andBool IId =/=Int CodeId andBool CountId =/=Int CodeId
  andBool (isSmallIntId(NId) orBool NId >=Int 4096)
  andBool (isSmallIntId(IId) orBool IId >=Int 4096)
  andBool (isSmallIntId(CountId) orBool CountId >=Int 4096)
  andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int))
  andBool objectAt(IId, REST) ==K #PyObject(#idInt, IImm:Bool, #PyLongObject(I:Int))
  andBool objectAt(CountId, REST) ==K #PyObject(#idInt, CountImm:Bool, #PyLongObject(Count:Int))
  andBool notBool (CodeId in_keys(REST)) andBool heapMax(REST) <Int Next
  andBool N <Int 0
 ensures tripleResult(?FinalNext -Int 1, ?FinalObjects, N, 0, 0)
 

endmodule
