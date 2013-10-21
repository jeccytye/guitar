  undef("reshape_ndf") ;n为缺测维
  function reshape_ndf(a,dma,n) ;a为1维变量,dma是缺省处理前的维数环境，n是长度有变的维数号(最左为0维)
  local ain,nm,k,dmb,n,i,aout
  begin
  ain = ndtooned(a)    ;以防万一
  nm  = dimsizes(ain)
  k = dimsizes(dma)-1
  dmb = dma
  do i = 0,k
  if(i.ne.n)   nm = nm/dma(i)  end if
  end do
  dmb(n) = nm
  aout = onedtond(ain,dmb)
  return(aout)
  end
  
  ;conform, dim_sum...
