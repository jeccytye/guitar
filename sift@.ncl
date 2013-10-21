undef("sift")
;9.3.0)    9.3.3_1) 
 load "$WORK/eventjudge@.ncl"
 load "$WORK/yearstrid@.ncl"
 load "$WORK/compress_2@.ncl"  ;compress_2保證了用於eventjudge的變量x1含有time維坐標。
 load "$WORK/reshape_2@.ncl"
 load "$WORK/extremejudge_2@.ncl" 
 load "$WORK/extreme_movjudge_3@.ncl"  ;_2不生成std文件。
function sift(x,lev,nt,name,opt)  ;x变量-带time，lev-event的水平/方差的水平(1d可帶缺省的變量)，nt-持续时间（针对opt=0/2的event方案）/滑动窗口长度（针对opt=2的event方案），name-输出文件名（""是不输出），opt-选择方案。
local x1,nm,en,spec,Levent,Hevent,Lind,Hind,Lind1,Hind1,Lind_bf,Hind_bf,Ltime,Htime,LH,ctr
begin
  x1 = compress(x,x@_FillValue)
  nm   = dimsizes(x1)   ;变量x，0维为时间，opt=1，有“time”维  
  en   =  (/0,0/)    ;记录有效的spec长度，即size  
if(opt.eq.0)
  spec = new((/nm/nt,4/),float)  ;要求维持5月，所以至少可以n/5，即使是floor格式的整除
  spec!1     = "event"
  spec&event = (/"Lstr","Llast","Hstr","Hlast"/) ;spec0针对穷举的extreme L142；spec2针对
  eventjudge(x1,lev,nt,en,spec(:,0:1),spec(:,2:3),1)  ;最右端参数opt=1，输出的是时间维。若opt=0，则输出是针对变量x的ind  ;lx,hx
  Lind1 = -1
  Hind1 = -1
 if(en(0).gt.0) 
  Levent = floattoint(reshape(compress(spec(:en(0)-1,0:1),spec@_FillValue),2))  
 ; Levent = floattoint(compress(spec(:en(0)-1,0:1),spec@_FillValue)) ;************ 把
;  print(Levent)
  printVarSummary(Levent)
  Levent(:,1)=yearstrid(Levent(:,0),Levent(:,1))
  do i=0,en(0)-1
  if(isvar("Lind_bf")) delete(Lind_bf) end if
  Lind_bf     = ind(x&time.ge.Levent(i,0).and.x&time.le.Levent(i,1))
  if(isvar("Lind")) delete(Lind) end if 
  Lind = array_append_record(Lind1,Lind_bf,0) 
  delete(Lind1)
  Lind1 = Lind
  end do 
 end if
 if(en(1).gt.0)
  Hevent = floattoint(reshape(compress(spec(:en(1)-1,2:3),spec@_FillValue),2))
  Hevent(:,1)=yearstrid(Hevent(:,0),Hevent(:,1))
  do i=0,en(1)-1
  if(isvar("Hind_bf")) delete(Hind_bf) end if
  Hind_bf     = ind(x&time.ge.Hevent(i,0).and.x&time.le.Hevent(i,1))
  if(isvar("Hind")) delete(Hind) end if
  Hind = array_append_record (Hind1,Hind_bf,0) 
  delete(Hind1)
  Hind1 = Hind
  end do
 end if  
   ;    d = array_append_record (Hind(1:),Lind(1:),0) 
   ; Mind = get1Dindex_Collapse(ispan(0,nm-1,1),d) ;_Exclude
 if(dimsizes(Lind1).gt.1 .and. dimsizes(Hind1).gt.1) 
   Ltime = x&time(Lind1(1:))
   Htime = x&time(Hind1(1:))
     en(0) = dimsizes(Ltime)
     en(1) = dimsizes(Htime)
  else
  if(Hind1.ne.-1)
   Htime = x&time(Hind1(1:))  
  end if
  if(Lind1.ne.-1)
   Ltime = x&time(Lind1(1:))
  end if
 end if
end if
; ***************************************************************************
if(opt.eq.1.or.opt.eq.2)
  spec     = new((/nm,2/),float)    ;nm:输出数组维度上限
  spec!1   = "event"                  ;对于二进制输出是不必要的。
  spec&event = (/"L","H"/)
  if(opt.eq.1)
  extremejudge(x1,lev,en,spec(:,0),spec(:,1),1)  ;最右端参数opt=1，输出的是时间维。若opt=0，则输出是针对变量x的ind
  end if
  if(opt.eq.2)
  extreme_movjudge(x1,lev,nt,en,spec(:,0),spec(:,1),1) ;_3的會生成序列文件"extreme_movjudge_std.ascii"
  print("output std to: extreme_movjudge_avestd.ascii")
  end if
  if(en(0).gt.0)          ;对于lev=1可能不用担心，但lev如果取得不当，可能会出现的。
  Ltime = spec(:en(0)-1,0) 
  end if
  if(en(1).gt.1) 
  Htime = spec(:en(1)-1,1)
  end if 
end if
 ; delete(d)
 ; d = compress(spec,spec@_FillValue)
 ; Myear = eliminate(x&time,d)    
  ; Mtime = x&time(Mind)   ;spec(:en(0)-1,0),spec(:en(1)-1,0) :Ltime,Htime
   
 ; if (Hind.ne.-1 .and. Lind.ne.-1)
 ; opt@fout  = ".ascii"    
 ; write_matrix(spec(:i,:),"2i7",opt)
 ; end if
 ; if(Lind.eq.-1)
 ;  asciiwrite(name+"_L.ascii",spec(:i,0)) 
 ; end if
 ; if(Hind.eq.-1)
 ;  asciiwrite(name+"_H.ascii",spec(:i,1)) 
 ; end if   
    

if(isvar("Ltime").and.isvar("Htime"))   ;对于extreme，好像相当于干呕了一遍，有点多余。不过，对于程序的简明训练，还是保留了。
   LH = new((/max(en),2/),typeof(x&time))
   LH(:en(0)-1,0) = Ltime
   LH(:en(1)-1,1) = Htime
   if(name.ne."".and.name.ne." ")
   out = True
  out@fout  = name+".ascii"  
  write_matrix(LH,"2f7.0",out)
   end if
  print("L: "+en(0)+"   H: "+en(1))
  return(LH)
else
 ctr = 0
 if(isvar("Ltime"))
   if(name.ne."".and.name.ne." ")
   asciiwrite(name+"_L.ascii",Ltime)
   end if 
   print("L: "+dimsizes(Ltime)+"no H event")
   return(Ltime)
   ctr = 1
 end if 
 if(isvar("Htime"))
   if(name.ne."".and.name.ne." ")
   asciiwrite(name+"_H.ascii",Htime) 
   end if
   print("no L event"+"H: "+dimsizes(Htime))
   return(Htime)
   ctr = 2
 end if
 if(ctr.eq.0)
 print("no special event")
 return(x@_FillValue)
 end if
end if 
 end
