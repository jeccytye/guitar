undef("difftest")
;全场的相关系数r, time维数n(自由度n-2),opt显著性水平:90%,95%,98%,99% and 99.9% |
;return：tn
;external COO "./diff_t_test.so"  ;也许可以。主程序不用再声明。
function difftest(n,m,A,B)  ;程序待修改，不需要ny，nx
local ax,vx,ay,vy,sn  ;不能杂七杂八加：[]等，那是对输入的要求   
begin
;   sig = (/0.90,0.95,0.98,0.99,0.999/)
    ;  dim = dimsizes(A)  ;因此必须提供 n 和 m
       ax = dim_avg_n(A,0)
       vx = dim_variance_n(A,0)
       ay = dim_avg_n(B,0)
       vy = dim_variance_n(B,0) 
       sn=ttest(ax,vx,n,ay,vy,m,True,False)
       sn=1-sn    
    return(sn)
end

;sig = difftest(en(0),en(1),H,L,1)  ;95%
; mask(Var,sig.lt.0.95,False)  
