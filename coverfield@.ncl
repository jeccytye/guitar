load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$WORK/compress@.ncl"
undef("coverfield")
function coverfield(x,y)   ;实质是去重
local n1,n2,z,bf,z1,i,k,p
begin
n1 = dimsizes(x)       ;最好是无缺省的。
n2 = dimsizes(y)
z  = array_append_record (x,y,0) 
bf = z
do k = 0,n1+n2-1
p = 0
do i=k,n1+n2-1
if(.not.ismissing(bf(i)))
 if(z(k).eq.bf(i)) 
  p = p+1
  if(p.gt.1) 
  bf(i) = bf@_FillValue
  end if
 end if
end if
end do
end do 
 z1 = compress(bf,bf@_FillValue) 
 return(z1)
end
