from pathlib import Path
import re,json,runpy
r=Path(__file__).resolve().parents[1]
p=r.parents[1]/"program"
run=runpy.run_path(str(p/'program.py'))['run']
checks=0
for n in list(range(-12,601))+[1023,1024,4097]:
 for i,c in [(0,0),(-17,900),(2**80,-2**80)]:
  assert run(n,i,c)==(n,max(n,0),(max(n,0)+1)//2)
  checks+=1
for i in range(601):
 c=(i+1)//2
 assert 2*c==i+i%2
 cp=c+(i%2==0)
 assert 2*cp==i+1+(i+1)%2
code=re.findall(r'#CoCodeValue\((.*?)\.CoCodeValueItems',(p/'program.kpyc').read_text())[1]
ops=re.findall(r'([A-Z_]+\(\d+\))',code)
f=r/'program-helper.k'
encoded=re.findall(r'\((\d+)\s*\|->\s*([A-Z_]+\(\d+\))\)',f.read_text())
assert [(int(i),op) for i,op in encoded]==list(enumerate(ops))
print(json.dumps({'source_checks':checks,'invariant_boundary_checks':601,'exact_code_units':len(ops),'status':'passed','kind':'finite evidence, not universal proof'}))
