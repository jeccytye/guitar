undef("yearstrid")
function yearstrid(str,n)
local n0,n1,last,i,n,str
begin
n0 = new(dimsizes(n),float)
n0 = n
n1 = floattoint(n0)
n0 = str
if(n1.ge.0)then
last = floattoint(n0) + n1/12*100 + n1%12-1  ;!!ע��-1.n������ʼ�µĳ���������
end if
if(n1.lt.0)then
last = floattoint(n0) + n1/12*100 + n1%12 
end if
do i=0,dimsizes(last)-1
if(last(i)%100.ge.12.or.last(i)%100.eq.0) then
if(n1.ge.0)then
last(i) = last(i)-12+100 
end if
if(n1.lt.0) then
last(i) = last(i)+12-100  ;194901 - 3 = 194898  = 194810
end if
end if
end do
return(last)
end

;9.3.3_1 str:��ʼ�£�n��������(+),��ǰn�£�-��
;n can be negative value