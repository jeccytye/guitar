undef("eliminate")  ;可多次使用，筛去特定值. 不影响属性传递,但a,b都得是一维的，且b最好不重复
function eliminate(a,b)  ;input:a,b  output:N,nid
local N,i,j,n,m,nid,id,d,kk
begin
n = dimsizes(a)
m = dimsizes(b)
;nid = new((/m,n/),integer)
 nid = new(n,integer)
nid@_FillValue = -999
N = new(n-m,typeof(a))
  kk = 0
do i=0,n-1
   ;最好设一条报错“input array all const，eliminate is odd!”
 do j=0,m-1
  if(a(i).eq.b(j))   ;用.le.1e-9出错了
    nid(kk) = i
    kk=kk+1
    j = m   ;跳出j循环
  end if
 end do
end do
;  d = compress(ndtooned(nid),nid@_FillValue)
 if (kk.gt.0)
  c = nid(0:kk-1)
  else
  c = -999
 end if 
 id = get1Dindex_Collapse(ispan(0,n-1,1),c)
 if(id(0).lt.0)then
  print(":( err:no target!")
  N = a
 else   N = a(id)
 end if
  return(N)
end

