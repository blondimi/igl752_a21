chan c = [1] of { bit };

init
{
  atomic
  {
    c ! 1
    run process(0)
    run process(1)
  }
}

proctype process(bit i)
{
noncritical:
  skip
  
wait:
  c ? 1

critical:
  skip
  
leave:
  atomic
  {
    c ! 1
    goto noncritical
  }
}

#define crit0 (process[0]@critical)
#define wait0 (process[0]@wait)
#define pid0  (process[0]:_pid)

#define crit1 (process[1]@critical)
#define wait1 (process[1]@wait)
#define pid1  (process[1]:_pid)

#define phi0 (<>[](enabled(pid0)) && !(_last == pid0))
#define phi1 (<>[](enabled(pid1)) && !(_last == pid1))
#define weak (!phi0 && !phi1)

#define phi0_  ([]<>(enabled(pid0)) && <>[](_last != pid0))
#define phi1_  ([]<>(enabled(pid1)) && <>[](_last != pid1))
#define strong (!phi0_ && !phi1_)

#define ev_enter ([](wait0 -> <> crit0) && [](wait1 -> <> crit1))

ltl mutex        { [](!crit0 || !crit1) }
ltl enter_unfair { ev_enter }
ltl enter_weak   { weak -> ev_enter}
ltl enter_strong { strong -> ev_enter}
