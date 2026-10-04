# Sum: proof scope

Prove the unchanged run function from its initialized bytecode frame, over
arbitrary exact Python integer n and sum, including cached and heap objects.
The source body executes unchanged. For n <= 0 the tuple is (n,sum); for
n > 0 the tuple is (0,sum+n*(n+1)/2). The scaled postcondition uses twice
the sum to avoid integer division. No bounds on mathematical input values.

Entry starts at instruction 0 with no caller frame. This does not prove
Python argument binding. Allocation assumes a well-formed finite heap below
nextId. Input integers may alias when their values agree. Booleans and int subclasses are outside the exact-int domain.

Extensions: targetRunCode is the unchanged decoded instruction map; heapMax
is the maximum Int map key, with a floor of 4095. pairResult/pairPayload observe tuple
contents. Pure objectAt and maximum-key lemmas follow structural map
lookup and integer order. No opcode/control rewrite, trusted claim, or changed
semantics is added.

## Arithmetic and representation review

For n > 0 one source iteration changes (n,s) to (n-1,s+n).
The polynomial is preserved because
2*(s+n)+(n-1)*n = 2*s+n*(n+1). At n=0 it is 2*s.
For n<0 no iteration executes. Thus the scaled integer postcondition is
exactly the source result, without a recursive function unfolding in K.
The loop includes n=0 so the final 1->0 iteration stays in its domain.

Each input reference is either a cached-integer ID or a heap address below
nextId. objectAt(NId,REST)=PyObject(idInt,NImm,PyLongObject(N)) and the
corresponding S equation link addresses to mathematical values directly.
C differs from both references. Removing C's map entry therefore preserves
the integer observations by the objectAt lemma. The equations permit NId=SId
when both values and immortality flags agree. They do not require distinct
integer objects or assume a source result.

The map-read lemma ignores one distinct-key entry; static lookup ignores
all entries and heap lookup reads only its own key. heapMax computes max(4095, all Int keys). Its structural-entry equation
follows this definition and the absent-key lemma follows I>heapMax(M).
Map keys of other sorts do not affect absence of an Int key. C notin REST
makes the code-entry union explicitly disjoint. These lemmas affect symbolic simplification
only, and do not rewrite the program's control or stack. No equivalence to
an alternative execution rule is assumed.

Pure integer lemma: 2*(S+N)+(N-1)*N = 2*S+N*(N+1), by distributivity. It holds for all integers independently of this program and normalizes the circularity postcondition.
