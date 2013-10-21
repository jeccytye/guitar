undef("crosscor")
procedure crosscor(x,y,opt)
local n1,n2,n,r,b
begin
 n1 = dimsizes(x)
 n2 = dimsizes(y)
  n = min((/n1,n2/))
  if(opt.ne.1)  ;有时间维“time”且为数字维
  r = escorc(x(:n-1),y(:n-1))
  else
 strtm = max((/x&time(0),y&time(0)/))
 endtm = min((/x&time(n1-1),y&time(n2-1)/))
    n  = dimsizes(x({strtm:endtm}))
  r = escorc(x({strtm:endtm}),y({strtm:endtm}))
 end if
  b = 1-rtest(r,n-2,0)  
  print("r: "+r+" significance: "+b)
end
