undef("crosscor")
procedure crosscor(x,y)
local n1,n2,n,r,b
begin
 n1 = dimsizes(x)
 n2 = dimsizes(y)
  n = min((/n1,n2/))
  r = escorc(x(:n-1),y(:n-1))
  b = 1-rtest(r,n-2,0)  
  print("r: "+r+" significance: "+b)
end
