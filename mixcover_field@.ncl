load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$WORK/compress@.ncl"
undef("mixfield")
function mixfield(x,y) ;仅针对一维变量
local n1,n2,z,z1,i,j,k
begin
n1 = dimsizes(x)
n2 = dimsizes(y)                                            
z  = new(min((/n1,n2/)),typeof(x))
do i=0,n1-1
  k = 0
  do j=k,n2-1   ;这里针对单调序列，其实可以再缩检索域。 对一般序列可以先做个排序。
   if(x(i).eq.y(j))
    z(k)=y(j)
    k = k+1
   end if
  end do
end do
z1 = compress(z,z@_FillValue)
return(z1)
end

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

undef("exclusield")   ;x里删去y里的元素
function exclusield(x,y)  ;过程对声明的要求比函数严格
local z,d,n1,n2,z1,i,j
begin
 n1 = dimsizes(x)
 d  = mixfield(x,y)
 n2 = dimsizes(d)
 z  = x
do i=0,n1-1
  do j=0,n2-1
   if(x(i).eq.d(j))
    z(i) = x@_FillValue
   end if
  end do
end do
z1 = compress(z,x@_FillValue)
return(z1) 
end
