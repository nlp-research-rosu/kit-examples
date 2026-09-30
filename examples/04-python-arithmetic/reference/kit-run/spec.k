requires "verification.k"

module SPEC
  imports VERIFICATION

  claim [run-sss]:
    <kpyc>
      <pyc> #program </pyc>
      <k> #boot => #normalExit </k>
      <memory>
        <objects> .Map => ?_OBJS:Map </objects>
        <nextId> 4096 => ?NEXT:Int </nextId>
      </memory>
      <runtime>
        <stdout> "" </stdout>
        <stderr> "" </stderr>
        <preconfig> #runInputs(A:Int, B:Int, R0:Int)
                  => #runResult(?RA:Int, ?RB:Int, ?RR:Int) </preconfig>
        <inittab> .Map </inittab>
      </runtime>
      <interpreters> .Bag => ?INTERPRETERS:Bag </interpreters>
    </kpyc>
    requires isSmallIntValue(A *Int B)
      andBool isSmallIntValue(A *Int B +Int A)
      andBool isSmallIntValue(A *Int B +Int A -Int B)
    ensures ?RA ==Int A
      andBool ?RB ==Int B
      andBool ?RR ==Int arithMix(A, B)

  claim [run-ssh]:
    <kpyc>
      <pyc> #program </pyc>
      <k> #boot => #normalExit </k>
      <memory>
        <objects> .Map => ?_OBJS:Map </objects>
        <nextId> 4096 => ?NEXT:Int </nextId>
      </memory>
      <runtime>
        <stdout> "" </stdout>
        <stderr> "" </stderr>
        <preconfig> #runInputs(A:Int, B:Int, R0:Int)
                  => #runResult(?RA:Int, ?RB:Int, ?RR:Int) </preconfig>
        <inittab> .Map </inittab>
      </runtime>
      <interpreters> .Bag => ?INTERPRETERS:Bag </interpreters>
    </kpyc>
    requires isSmallIntValue(A *Int B)
      andBool isSmallIntValue(A *Int B +Int A)
      andBool notBool isSmallIntValue(A *Int B +Int A -Int B)
    ensures ?RA ==Int A
      andBool ?RB ==Int B
      andBool ?RR ==Int arithMix(A, B)

  claim [run-shs]:
    <kpyc>
      <pyc> #program </pyc>
      <k> #boot => #normalExit </k>
      <memory>
        <objects> .Map => ?_OBJS:Map </objects>
        <nextId> 4096 => ?NEXT:Int </nextId>
      </memory>
      <runtime>
        <stdout> "" </stdout>
        <stderr> "" </stderr>
        <preconfig> #runInputs(A:Int, B:Int, R0:Int)
                  => #runResult(?RA:Int, ?RB:Int, ?RR:Int) </preconfig>
        <inittab> .Map </inittab>
      </runtime>
      <interpreters> .Bag => ?INTERPRETERS:Bag </interpreters>
    </kpyc>
    requires isSmallIntValue(A *Int B)
      andBool notBool isSmallIntValue(A *Int B +Int A)
      andBool isSmallIntValue(A *Int B +Int A -Int B)
    ensures ?RA ==Int A
      andBool ?RB ==Int B
      andBool ?RR ==Int arithMix(A, B)

  claim [run-shh]:
    <kpyc>
      <pyc> #program </pyc>
      <k> #boot => #normalExit </k>
      <memory>
        <objects> .Map => ?_OBJS:Map </objects>
        <nextId> 4096 => ?NEXT:Int </nextId>
      </memory>
      <runtime>
        <stdout> "" </stdout>
        <stderr> "" </stderr>
        <preconfig> #runInputs(A:Int, B:Int, R0:Int)
                  => #runResult(?RA:Int, ?RB:Int, ?RR:Int) </preconfig>
        <inittab> .Map </inittab>
      </runtime>
      <interpreters> .Bag => ?INTERPRETERS:Bag </interpreters>
    </kpyc>
    requires isSmallIntValue(A *Int B)
      andBool notBool isSmallIntValue(A *Int B +Int A)
      andBool notBool isSmallIntValue(A *Int B +Int A -Int B)
    ensures ?RA ==Int A
      andBool ?RB ==Int B
      andBool ?RR ==Int arithMix(A, B)

  claim [run-hss]:
    <kpyc>
      <pyc> #program </pyc>
      <k> #boot => #normalExit </k>
      <memory>
        <objects> .Map => ?_OBJS:Map </objects>
        <nextId> 4096 => ?NEXT:Int </nextId>
      </memory>
      <runtime>
        <stdout> "" </stdout>
        <stderr> "" </stderr>
        <preconfig> #runInputs(A:Int, B:Int, R0:Int)
                  => #runResult(?RA:Int, ?RB:Int, ?RR:Int) </preconfig>
        <inittab> .Map </inittab>
      </runtime>
      <interpreters> .Bag => ?INTERPRETERS:Bag </interpreters>
    </kpyc>
    requires notBool isSmallIntValue(A *Int B)
      andBool isSmallIntValue(A *Int B +Int A)
      andBool isSmallIntValue(A *Int B +Int A -Int B)
    ensures ?RA ==Int A
      andBool ?RB ==Int B
      andBool ?RR ==Int arithMix(A, B)

  claim [run-hsh]:
    <kpyc>
      <pyc> #program </pyc>
      <k> #boot => #normalExit </k>
      <memory>
        <objects> .Map => ?_OBJS:Map </objects>
        <nextId> 4096 => ?NEXT:Int </nextId>
      </memory>
      <runtime>
        <stdout> "" </stdout>
        <stderr> "" </stderr>
        <preconfig> #runInputs(A:Int, B:Int, R0:Int)
                  => #runResult(?RA:Int, ?RB:Int, ?RR:Int) </preconfig>
        <inittab> .Map </inittab>
      </runtime>
      <interpreters> .Bag => ?INTERPRETERS:Bag </interpreters>
    </kpyc>
    requires notBool isSmallIntValue(A *Int B)
      andBool isSmallIntValue(A *Int B +Int A)
      andBool notBool isSmallIntValue(A *Int B +Int A -Int B)
    ensures ?RA ==Int A
      andBool ?RB ==Int B
      andBool ?RR ==Int arithMix(A, B)

  claim [run-hhs]:
    <kpyc>
      <pyc> #program </pyc>
      <k> #boot => #normalExit </k>
      <memory>
        <objects> .Map => ?_OBJS:Map </objects>
        <nextId> 4096 => ?NEXT:Int </nextId>
      </memory>
      <runtime>
        <stdout> "" </stdout>
        <stderr> "" </stderr>
        <preconfig> #runInputs(A:Int, B:Int, R0:Int)
                  => #runResult(?RA:Int, ?RB:Int, ?RR:Int) </preconfig>
        <inittab> .Map </inittab>
      </runtime>
      <interpreters> .Bag => ?INTERPRETERS:Bag </interpreters>
    </kpyc>
    requires notBool isSmallIntValue(A *Int B)
      andBool notBool isSmallIntValue(A *Int B +Int A)
      andBool isSmallIntValue(A *Int B +Int A -Int B)
    ensures ?RA ==Int A
      andBool ?RB ==Int B
      andBool ?RR ==Int arithMix(A, B)

  claim [run-hhh]:
    <kpyc>
      <pyc> #program </pyc>
      <k> #boot => #normalExit </k>
      <memory>
        <objects> .Map => ?_OBJS:Map </objects>
        <nextId> 4096 => ?NEXT:Int </nextId>
      </memory>
      <runtime>
        <stdout> "" </stdout>
        <stderr> "" </stderr>
        <preconfig> #runInputs(A:Int, B:Int, R0:Int)
                  => #runResult(?RA:Int, ?RB:Int, ?RR:Int) </preconfig>
        <inittab> .Map </inittab>
      </runtime>
      <interpreters> .Bag => ?INTERPRETERS:Bag </interpreters>
    </kpyc>
    requires notBool isSmallIntValue(A *Int B)
      andBool notBool isSmallIntValue(A *Int B +Int A)
      andBool notBool isSmallIntValue(A *Int B +Int A -Int B)
    ensures ?RA ==Int A
      andBool ?RB ==Int B
      andBool ?RR ==Int arithMix(A, B)
endmodule
