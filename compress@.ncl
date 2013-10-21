undef("compress")  ;可多次使用，筛去特定值. 不影响属性传递,但a最好是一维的，因为输出成了一维。
function compress(a,missingvalue)
local N,i,j,nm
begin
b = ndtooned(a)
b@_FillValue = missingvalue
nm = num(.not.ismissing(b))
if(nm.le.0)then
print("error: no valid data, please check the array!")
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
return(N)
end

;load "$WORK/compress@.ncl"

