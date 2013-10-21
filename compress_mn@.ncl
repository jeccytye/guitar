undef("compress_mn")  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
function compress_mn(a,missingvalue)
local N,i,j,n,m,nm,istrind,iendind,iistrind,iiendind,jstrind,jendind,jjstrind,jjendind
begin
; 排列搜出最小有效坐标位置。
  nm = dimsizes(a)
  m = nm(0)
  n = nm(1)
a@_FillValue = missingvalue
  jstrind = new(m,integer)
  istrind = new(n,integer)
  iendind = istrind
  jendind = jstrind
do i=0,m-1
  jstrind(i)=min(ind(.not.ismissing(a(i,:))));minind/maxind 只针对1维
  jendind(i)=max(ind(.not.ismissing(a(i,:))))
end do
do j=0,n-1
  istrind(j)=min(ind(.not.ismissing(a(:,j)))) 
  iendind(j)=max(ind(.not.ismissing(a(:,j)))) 
end do
  iistrind = min(istrind)
  mistrind = max(istrind)
  miendind = min(istrind)
  iiendind = max(iendind)
  jjstrind = min(jstrind)
  mjstrind = max(jstrind)
  mjendind = min(jendind)
  jjendind = max(jendind)
  print(iistrind+" "+iiendind+" "+jjstrind+" "+jjendind)
if (iistrind.ne.0.or.jjstrind.ne.0)
N = a(iistrind:iiendind,jjstrind:jjendind)
print("shortest series: "+mistrind+":"+miendind+" , "+mjstrind+":"+mjendind)
return(N)
else
print("error: no valid data, please check the matrix!")
return(a@_FillValue)
end if
end

