  undef("reshape")
  function reshape(a,dma)
  local aout
  begin
  aout = onedtond(ndtooned(a),dma)
  return(aout)
  end
  
