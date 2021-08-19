bool x = false;
bool y = false;

init
{
  atomic
  {
    run A()
    run B()
  }
}

proctype A()
{
  do
    :: true ->
enter:
       x = true
wait:  
       do
         :: y    -> skip
         :: else -> break
       od  
critical:
       skip
leave:
       x = false
  od
}

proctype B()
{
  do
    :: true ->
enter:
       y = true   
wait:
       if
         :: x ->
            y = false

            do
              :: x    -> skip
              :: else -> break
            od

            goto enter

         :: else -> goto critical
       fi       
critical:
       skip
leave:
       y = false
  od
}

ltl p1 { !(<> (A@critical && B@critical)) }
ltl p2 { [] (B@enter -> <> B@critical) }
