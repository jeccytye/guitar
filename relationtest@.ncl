undef("relationtest")
;全场的相关系数r, time维数n(自由度n-2),opt显著性水平
;return：rmin，rmax
procedure relationtest(r:numeric,n[1]:numeric,opt,rmin[1],rmax[1])
local rb,ii,b
begin
; opt取值限0-2
sig = (/0.10,0.05,0.01/)   ;(/0.90,0.95,0.99/)
siglev = sig(opt)    
rb = ndtooned(r)
b = rtest(rb,n-2,0)     ;1-rtest()
   ii = ind(b.ge.siglev)   ;不显著   ;(b.le.siglev)   
if(.not.(all(ismissing(ii))))then
   rmax = max(rb(ii))   ;取临界
   rmin = min(rb(ii))
   else
   rmax = 1.
   rmin = -1.   
 end if
   delete(ii)
end
; covering the insignificance span, and then to locate the shreshold.
; if hope to judge whether it is significant, just compare rtest value with 0.1. rtest < 0.1 significant!
