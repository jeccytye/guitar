undef("yearstride")
function yearstrid(str,n:integer)
local last
begin
last = str + n/12*100 + n%12   ;1d var
do i=0,dimsizes(last)-1
if(last(i)%100.gt.12)
last(i) = last(i)-12+100 
end if
end do
return(last)
end

;9.3.3_1 str:起始月，n：持续月
; str - missing value is allowed	
