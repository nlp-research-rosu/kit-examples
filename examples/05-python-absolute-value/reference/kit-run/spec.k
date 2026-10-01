requires "verification.k"

module SPEC
  imports VERIFICATION

  claim [run-abs]:
    <kpyc>
      <pyc> absSubjectProgram() </pyc>
      <k> #dispatch => #normalExit </k>
      <memory>
        <objects>
          absHarnessInputObjects(A, RES) => absFinalObjects(A, RES)
        </objects>
        <nextId>
          absHarnessInitialNextId() => absFinalNextId(A)
        </nextId>
      </memory>
      <interpreters>
        <interpreter>
          <interpreterId> 0 </interpreterId>
          <config> .K </config>
          <builtins> absHarnessBuiltinsId(absHarnessBootPlan()) </builtins>
          <sysdict> 0 </sysdict>
          <modules> 0 </modules>
          <commonConsts> commonConstsTable() </commonConsts>
          <recursionLimit> 1000 </recursionLimit>
          <threads>
            <tstate>
              <threadId> 0 </threadId>
              <currentException> 0 </currentException>
              <excInfo> ListItem(0) </excInfo>
              <pyRecursionRemaining> 999 </pyRecursionRemaining>
              <nextInstruction>
                0 => absFinalNextInstruction(A)
              </nextInstruction>
              <currentFrame>
                <fExecutable> absHarnessRunCodeId() </fExecutable>
                <fFuncobj> 0 </fFuncobj>
                <fGlobals> absHarnessGlobalsId(absHarnessBootPlan()) </fGlobals>
                <fBuiltins> absHarnessBuiltinsId(absHarnessBootPlan()) </fBuiltins>
                <fLocals> 0 </fLocals>
                <instructionPointer>
                  0 => absFinalInstructionPointer(A)
                </instructionPointer>
                <returnOffset> 0 </returnOffset>
                <localsplus>
                  ListItem(#PyObjectPointer(absHarnessAId()))
                  ListItem(#PyObjectPointer(absHarnessResId()))
                  => ListItem(#PyObjectPointer(absHarnessAId()))
                     ListItem(#PyObjectPointer(absFinalResultId(A)))
                </localsplus>
                <stack> .List </stack>
              </currentFrame>
              <previousFrames> .List </previousFrames>
            </tstate>
          </threads>
        </interpreter>
      </interpreters>
      ...
    </kpyc>
endmodule
