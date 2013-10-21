undef("cal_date")
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
function cal_date(dstr,dend)
local time,dates,strind,endind
begin
stry = floattoint(floor(dstr/10000))
endy = floattoint(floor(dend/10000))
time  =  yyyymmdd_time(stry,endy,"integer")
strind = ind(time.eq.dstr)
endind = ind(time.eq.dend)
dates  = time(strind:endind)
return(dates)
end
