undef("relationtest")
;全场的相关系数r, time维数n(自由度n-2),opt显著性水平
;return：rmin，rmax
function relationtest(r:numeric,n,opt)
local rb,ii,b,rmin,rmax,mnmx
begin
; opt取值限0-2
sig = (/0.10,0.05,0.01/)
siglev = sig(opt)
rb = ndtooned(r)
b = rtest(rb,n-2,0)
   ii = ind(b.ge.siglev)
if(.not.(all(ismissing(ii))))then
   rmax = max(rb(ii))
   rmin = min(rb(ii))
   else
   rmax = 1.
   rmin = -1.   
 end if
   delete(ii)
   mnmx = (/rmin,rmax/)
   return(mnmx)
end
;检验一个场许多点的相关显著与否
