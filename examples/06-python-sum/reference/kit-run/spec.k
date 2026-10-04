requires "verification.k"
module SPEC
 imports VERIFICATION
 claim [nonpositive]:
 <k> #dispatch => #normalExit </k>
 <memory>
   <objects> (((C |-> #PyObject(#idCode, false, #PyCodeObject(
 2, 0, 0, 2, 67108867, targetRunCode(),
 ListItem(DocId) ListItem(#idSmallInt(-1)), .List,
 ListItem(NNameId) ListItem(SumNameId), ListItem(38) ListItem(38),
 FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
   <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
   <nextInstruction> 1 => 30 </nextInstruction>
   <currentFrame>
     <fExecutable> C:Int </fExecutable>
     <instructionPointer> IP:Int => 29 </instructionPointer>
     <localsplus> (ListItem(#PyObjectPointer(NId:Int))
                    ListItem(#PyObjectPointer(SId:Int)) .List => ?Locals:List) </localsplus>
     <stack> .List </stack>
     ...
   </currentFrame>
   <previousFrames> .List </previousFrames>
   ...
 </tstate></threads>...</interpreter></interpreters>
 requires C >=Int 4096 andBool Next >=Int 4096
  andBool C <Int Next andBool NId <Int Next andBool SId <Int Next
  andBool NId =/=Int C andBool SId =/=Int C
  andBool (isSmallIntId(NId) orBool NId >=Int 4096)
  andBool (isSmallIntId(SId) orBool SId >=Int 4096)
  andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int))
  andBool objectAt(SId, REST) ==K #PyObject(#idInt, SImm:Bool, #PyLongObject(S:Int))
  andBool notBool (C in_keys(REST))
  andBool heapMax(REST) <Int Next
  andBool N <=Int 0
 ensures pairResult(?FinalNext -Int 1, ?FinalObjects, N, 2 *Int S)
 

 claim [loop]:
 <k> #dispatch => #normalExit </k>
 <memory>
   <objects> (((C |-> #PyObject(#idCode, false, #PyCodeObject(
 2, 0, 0, 2, 67108867, targetRunCode(),
 ListItem(DocId) ListItem(#idSmallInt(-1)), .List,
 ListItem(NNameId) ListItem(SumNameId), ListItem(38) ListItem(38),
 FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
   <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
   <nextInstruction> 1 => 30 </nextInstruction>
   <currentFrame>
     <fExecutable> C:Int </fExecutable>
     <instructionPointer> IP:Int => 29 </instructionPointer>
     <localsplus> (ListItem(#PyObjectPointer(NId:Int))
                    ListItem(#PyObjectPointer(SId:Int)) .List => ?Locals:List) </localsplus>
     <stack> .List </stack>
     ...
   </currentFrame>
   <previousFrames> .List </previousFrames>
   ...
 </tstate></threads>...</interpreter></interpreters>
 requires C >=Int 4096 andBool Next >=Int 4096
  andBool C <Int Next andBool NId <Int Next andBool SId <Int Next
  andBool NId =/=Int C andBool SId =/=Int C
  andBool (isSmallIntId(NId) orBool NId >=Int 4096)
  andBool (isSmallIntId(SId) orBool SId >=Int 4096)
  andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int))
  andBool objectAt(SId, REST) ==K #PyObject(#idInt, SImm:Bool, #PyLongObject(S:Int))
  andBool notBool (C in_keys(REST))
  andBool heapMax(REST) <Int Next
  andBool N >=Int 0
 ensures pairResult(?FinalNext -Int 1, ?FinalObjects, 0, 2 *Int S +Int N *Int (N +Int 1))
 [circularity]

 claim [entry-positive]:
 <k> #dispatch => #normalExit </k>
 <memory>
   <objects> (((C |-> #PyObject(#idCode, false, #PyCodeObject(
 2, 0, 0, 2, 67108867, targetRunCode(),
 ListItem(DocId) ListItem(#idSmallInt(-1)), .List,
 ListItem(NNameId) ListItem(SumNameId), ListItem(38) ListItem(38),
 FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
   <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
   <nextInstruction> 0 => 30 </nextInstruction>
   <currentFrame>
     <fExecutable> C:Int </fExecutable>
     <instructionPointer> IP:Int => 29 </instructionPointer>
     <localsplus> (ListItem(#PyObjectPointer(NId:Int))
                    ListItem(#PyObjectPointer(SId:Int)) .List => ?Locals:List) </localsplus>
     <stack> .List </stack>
     ...
   </currentFrame>
   <previousFrames> .List </previousFrames>
   ...
 </tstate></threads>...</interpreter></interpreters>
 requires C >=Int 4096 andBool Next >=Int 4096
  andBool C <Int Next andBool NId <Int Next andBool SId <Int Next
  andBool NId =/=Int C andBool SId =/=Int C
  andBool (isSmallIntId(NId) orBool NId >=Int 4096)
  andBool (isSmallIntId(SId) orBool SId >=Int 4096)
  andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int))
  andBool objectAt(SId, REST) ==K #PyObject(#idInt, SImm:Bool, #PyLongObject(S:Int))
  andBool notBool (C in_keys(REST))
  andBool heapMax(REST) <Int Next
  andBool N >=Int 0
 ensures pairResult(?FinalNext -Int 1, ?FinalObjects, 0, 2 *Int S +Int N *Int (N +Int 1))
 [depends(loop)]

 claim [entry-negative]:
 <k> #dispatch => #normalExit </k>
 <memory>
   <objects> (((C |-> #PyObject(#idCode, false, #PyCodeObject(
 2, 0, 0, 2, 67108867, targetRunCode(),
 ListItem(DocId) ListItem(#idSmallInt(-1)), .List,
 ListItem(NNameId) ListItem(SumNameId), ListItem(38) ListItem(38),
 FilenameId, FunctionNameId, QualnameId, 5, LinetableId, .List))) REST:Map) => ?FinalObjects:Map) </objects>
   <nextId> Next:Int => ?FinalNext:Int </nextId>
 </memory>
 <interpreters><interpreter><threads><tstate>
   <nextInstruction> 0 => 30 </nextInstruction>
   <currentFrame>
     <fExecutable> C:Int </fExecutable>
     <instructionPointer> IP:Int => 29 </instructionPointer>
     <localsplus> (ListItem(#PyObjectPointer(NId:Int))
                    ListItem(#PyObjectPointer(SId:Int)) .List => ?Locals:List) </localsplus>
     <stack> .List </stack>
     ...
   </currentFrame>
   <previousFrames> .List </previousFrames>
   ...
 </tstate></threads>...</interpreter></interpreters>
 requires C >=Int 4096 andBool Next >=Int 4096
  andBool C <Int Next andBool NId <Int Next andBool SId <Int Next
  andBool NId =/=Int C andBool SId =/=Int C
  andBool (isSmallIntId(NId) orBool NId >=Int 4096)
  andBool (isSmallIntId(SId) orBool SId >=Int 4096)
  andBool objectAt(NId, REST) ==K #PyObject(#idInt, NImm:Bool, #PyLongObject(N:Int))
  andBool objectAt(SId, REST) ==K #PyObject(#idInt, SImm:Bool, #PyLongObject(S:Int))
  andBool notBool (C in_keys(REST))
  andBool heapMax(REST) <Int Next
  andBool N <Int 0
 ensures pairResult(?FinalNext -Int 1, ?FinalObjects, N, 2 *Int S)
 [depends(nonpositive)]

endmodule
