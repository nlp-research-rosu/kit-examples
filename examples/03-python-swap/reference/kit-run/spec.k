requires "verification.k"

module SPEC
  imports VERIFICATION

  claim [swap-entry]:
    <kpyc>
      <pyc> programImage() </pyc>
      <k>
        #boot
        => #cReturn(#verificationReturn(?AID:Int, ?BID:Int, ?RID:Int), ?TUPLE:Int)
           ~> #dispatch
      </k>
      <memory>
        <objects>
          .Map
          => ?FINAL:Map
        </objects>
        <nextId> 4096 => ?NEXT:Int </nextId>
      </memory>
      <runtime>
        <stdout> "" </stdout>
        <stderr> "" </stderr>
        <preconfig> #verificationInputs(A:Int, B:Int, R:Int) => .K </preconfig>
        <inittab> .Map </inittab>
      </runtime>
      <interpreters> .Bag => ?INTERPRETERS:Bag </interpreters>
    </kpyc>
    ensures isSwapResult(A, B, R, ?AID, ?BID, ?RID, ?TUPLE, ?FINAL)
endmodule
