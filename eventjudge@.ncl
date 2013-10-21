undef("eventjudge")
;连续ex个单位时间达到a值以上算作一次事件，lx,hx记录低高事件时间起点,	持续时长,en记录次数
procedure eventjudge(x,a,ex,en,lx,hx,opt) 
;x 0维为时间，opt=1，有“time”维  
;lx = new((/(dm(0)/a+1)/2+1,2/),integer)   hx = new((/dm(0)/a,2/),integer)
local i,dm,id1,id2,idl,idh
begin
  dm = dimsizes(x)
  id1 = 0              ;计数指针
  id2 = 0
  do i=0,dm(0)-1
   if(x(i).ge.a)then
      id1 = id1+1
      else
    if(id1.gt.ex)then       ;条件上，确定持续时长
      hx(en(1)-1,1) = id1
    end if
    id1 = 0
   end if
  if(id1.eq.ex)then         ;临界条件，确定起点
    hx(en(1),0) = i-ex+1
    hx(en(1),1) = ex             ;临界值
    en(1) = en(1)+1
  end if
  
  if(x(i).le.a*(-1))then
       id2 = id2+1
      else
    if(id2.gt.ex)then       ;条件上，确定持续时长
      lx(en(0)-1,1) = id2
    end if
    id2 = 0
  end if
  if(id2.eq.ex)then       ;临界条件，确定起点
    lx(en(0),0) = i-ex+1
    lx(en(0),1) = ex             ;临界值
    en(0) = en(0)+1
  end if
  end do
  if(opt.eq.1)then
    i = en(0)-1
   lx(0:i,0) = floattoint(x&time(lx(0:i,0)))
    i = en(1)-1
   hx(0:i,0) = floattoint(x&time(hx(0:i,0)))
  end if
  end
  
 ;eventjudge(Nino34,0.5,5,en,lx,hx,1) 
 ;print(lx(:,0)+lx(:,1))
 ;print(en)
  
  
     
