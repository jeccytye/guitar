undef("compress")  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
function compress(a,missingvalue)
local b,N,i,j,nm
begin
if(dimsizes(dimsizes(a)).gt.1)  
b = ndtooned(a) 
else
b = a
end if
b@_FillValue = missingvalue
nm = num(.not.ismissing(b))
if(nm.le.0)then
print("error: no valid data, please check the array! and a fatal warning on N below")
else
N = new(nm,typeof(b))
end if
j = 0
do i=0,dimsizes(b)-1
if(.not.ismissing(b(i)))
N(j) = b(i)
j = j+1
end if
end do
copy_VarCoords(b(:dimsizes(N)-1),N)
return(N)
end

;load "$WORK/compress@.ncl"

;***varr = where(dif.lt.e90,-999.,dif)
