undef("leadlagpoint")

procedure leadlagpoint(ts1[*],ts2[*],maxlag[1],opt[1],x,ccrtot)    ;需改进，如何使得两序列不等长求相关。opt=0不需要标准化，1，标
local ccr1,ccr2
begin          
   if(opt.eq.1)then
   ts1 = dim_standardize(ts1)
   ts2 = dim_standardize(ts2)
   end if                                               ; set total lag
   ccr1 = esccr(ts1,ts2,maxlag)                  ; calc pos lag cross cor
   ccr2 = esccr(ts2,ts1,maxlag)                  ; calc neg lag cross cor
;************************************************
;  combine pos and neg into one time series
;************************************************
 
   ccrtot(0:maxlag-1) = ccr2(0:maxlag-1:-1)      
   ccrtot(maxlag:)    = ccr1(0:maxlag-1)
 
   x = ispan(-maxlag,maxlag,1)                   ; define x axis	
end
