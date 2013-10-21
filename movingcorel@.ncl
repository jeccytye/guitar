undef("movingcorel")
function  movingcorel(x[*]:numeric,y[*]:numeric,m[1]:integer,opt)
local n1,n2,n,r,a,b,bf  ;slv (/0.01,0.05,0.1/)
begin
 n1 = dimsizes(x)
 n2 = dimsizes(y)
  n = min((/n1,n2/))
 if(opt.eq.1)  ;有时间维“time”且为数字维
 strtm = max((/x&time(0),y&time(0)/))
 endtm = min((/x&time(n1-1),y&time(n2-1)/))
    n  = dimsizes(x({strtm:endtm}))
 end if
 if (m.ge.n-2)then
 print("error: timewindow should be less than "+ n)
 return(-999)
 else
 r = new(n-m+1,float)
 do i=0,n-m   
 a = x(i:i+m-1)
 b = y(i:i+m-1)
 r(i) = escorc(a,b)
 end do
 end if
 if(opt.eq.1)
 r!0 = "time"
 if (strtm.eq.x&time(0))then
 bf = x&time
 else 
 bf = y&time
 end if
 r&time = bf(m/2:n-m+m/2)   ;m最好是奇数
 ; r&time = bf(0:n-m)
 end if
 return(r)
end

;load "$WORK/movingcorel@.ncl"
;这里暂只能处理开始时刻一致的数组
