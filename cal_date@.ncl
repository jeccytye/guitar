undef("cal_date")
function cal_date(ystr,yend)
local
begin
n = yend-ystr
if(n.le.4)
 m = n
 else
 m = 4
end if
 do i = 0,m-1
 year = ystr+i
 if(isleapyear(year))
  stry = i
 end if
 end do
 
