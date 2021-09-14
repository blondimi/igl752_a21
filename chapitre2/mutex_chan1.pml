chan c = [1] of { bit };
byte crit = 0;

init
{
  atomic
  {
    run process(0)
    run process(1)
  }
}

proctype process(bit i)
{
request:
  c ! i

wait:
  c ? i

critical:
  atomic
  {
    crit++
    assert(crit == 1)
  }

noncritical:
  atomic
  {
    crit--
    goto request
  }
}

#define crit0 process[0]@critical
#define crit1 process[1]@critical

ltl mutex { [](!crit0 || !crit1) }