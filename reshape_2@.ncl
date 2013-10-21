  undef("reshape_2")
  function reshape_2(a,n)
  local a1,m,aout
  begin
  a1 = ndtooned(a)
  m = dimsizes(a1)/n
  aout = onedtond(a,(/m,n/))
  return(aout)
  end
  
 ;load "$WORK/reshape_2@.ncl"
 ;input: a[] ,n
 ;output: aout[,n]  2d matrix
