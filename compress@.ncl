undef("compress")  ;�ɶ��ʹ�ã�ɸȥ�ض�ֵ. ��Ӱ�����Դ���,��a�����һά�ģ���Ϊ�������һά��
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
