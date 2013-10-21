undef("extreme_movjudge")
;input: x(n),jdgopt[0.8/1]
;output:hx,lx,en
procedure extreme_movjudge(n,x,mov,jdgopt,en,hx,lx,opt)   ;mov = (nyear-1)/2   ;nyear滑动平均  nyear = 2*mov+1
local i,j,id1,id2,jdg
begin
 do i = 0,n-1
   if (i.lt.mov)then
   add = onedtond(x(0),mov-i)
   series = array_append_record(x(0:i+mov),add,0)  
   delete(add)
   end if
   if (i.gt.n-1-mov)then
   add = onedtond(x(n-1),i+mov-n+1)
   series = array_append_record(x(i-mov:n-1),add,0)    
   delete(add)
   end if  
   if ((i.ge.mov).and.(i.le.n-1-mov)) then
    series = x(i-mov:i+mov)
   end if
      
    Std = dim_stddev(series)
    xstd = (x(i)-avg(series))/Std
    jdg = jdgopt*Std
   if(xstd.ge.jdg)then  
   id1=en(0)
   if(opt.eq.1)then   ;opt=1 
   hx(id1)=x&time(i)
   else
   hx(id1)=i  ;ind.  x(etrx)
   end if
   en(0)=en(0)+1
   end if 
   
   if(xstd.le.jdg*(-1))then
   id2=en(1)
   if(opt.eq.1)then   ;opt=1 是否含时间维
   lx(id2)=x&time(i)
   else
   lx(id2)=i  ;ind.  x(etrx)
   end if
   en(1)=en(1)+1
   end if   
 end do
end
; en = (/0,0/)  ;  hx = new(sizeof(x),"integer")  lx
; extremejudge(53,Ilz,mov,1,en,hx,lx,1)

; Hind = hx(0:en(0)-1)  Lind=lx(0:en(1)-1)
; H = Var(hx)   L = Var(lx)    
