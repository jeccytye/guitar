undef("extremejudge")
;input: x(n),jdgopt[0.8/1]
;output:hx,lx,en
procedure extremejudge(n,x,jdgopt,en,hx,lx,opt)
local i,id1,id2,jdg
begin
   xstd = dim_standardize(x,1)
    Std = dim_stddev(x)
    jdg = jdgopt*Std
   do i=1,n-1
   if(xstd(i).ge.jdg)then  
   id1=en(0)
   if(opt.eq.1)then   ;opt=1 xå¸¦æ—¶é—´ç»´
   hx(id1)=x&time(i)
   else
   hx(id1)=i  ;ind.  x(etrx)
   end if
   en(0)=en(0)+1
   end if 
   
   if(xstd(i).le.jdg*(-1))then
   id2=en(1)
   if(opt.eq.1)then   ;opt=1 ÊÇ·ñº¬Ê±¼äÎ¬
   lx(id2)=x&time(i)
   else
   lx(id2)=i  ;ind.  x(etrx)
   end if
   en(1)=en(1)+1
   end if   
   end do
   end
; en = (/0,0/)  ;  hx = new(sizeof(x),"integer")  lx
; extremejudge(53,Ilz,1,en,hx,lx,1)

; Hind = hx(0:en(0)-1)  Lind=lx(0:en(1)-1)
; H = Var(hx)   L = Var(lx)    
