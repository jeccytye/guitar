undef("difftestV")
;全场的相关系数r, time维数n(自由度n-2),opt显著性水平:90%,95%,98%,99% and 99.9% |
;return：tn
;external FOO "./ttable.so"  ;也许可以。主程序不用再声明。
function difftestV(n,m,A,B)  ;A!0=time, A!1=dirc A&direc=(/"u","v"/)
local ax,vx,ay,vy,sn,SA,SB  ;不能杂七杂八加：[]等，那是对输入的要求   尚只能保证4维。代改进。
begin
 ;  sig = (/0.90,0.95,0.98,0.99,0.999/)
 ;  dim = dimsizes(A)
   sA = sqrt(A(0,:,:,:)^2+A(1,:,:,:)^2)  ;2,time,lat,lon
   sB = sqrt(B(0,:,:,:)^2+B(1,:,:,:)^2)
    ax = dim_avg_n(sA,0)
    vx = dim_variance_n(sA,0)
    ay = dim_avg_n(sB,0)
    vy = dim_variance_n(sB,0)
    sn=ttest(ax,vx,n,ay,vy,m,True,False)
    sn = 1-sn
    return(sn)
end

;sig = difftest(en(0),en(1),H,L) 
;deta = x-y         ; h-l 
;deta = mask(deta,sig.lt.0.95,False) ;95%
