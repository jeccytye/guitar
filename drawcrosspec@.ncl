undef("drawcrosspec")
function drawcrosspec(x,y,opt,tw,wopt,lf,hf,c,sh,wks,tag)
local wgt,x1,y1,plot,res,spec,splt,res_P
begin
 opt = 0   ;滤波参数
 wgt = filwgts_lanczos(tw,wopt,lf,hf,1);(241,2,1./120,0.2,1)  ;注意1.  
 if (opt.eq.1)then
  x = wgt_runave (x, wgt, 0) ;opt 为正则以0，1，2的wgt*x(0),x(1)..补足；opt 为0则缺省； opt 为负，则以0，1，2的wgt*x(N-2),x(N-1)..补足
  y = wgt_runave (y, wgt, 0)
 y1 = compress(x,x@_FillValue)
 x1 = compress(y,y@_FillValue)
; x1 = dim_standardize(x,1)
; y1 = dim_standardize(y,1)
   else 
 x1 = x
 y1 = y
 end if
; detrending opt: 0=>remove mean 1=>remove mean and detrend
; smoothing periodogram: (0 <= sm <= ??.) should be at least 3 and odd
; percent tapered: (0.0 <= pct <= 1.0) 0.10 common. 
;************************************************
; calculate spectrum
;************************************************
  spec = specxy_anal(x1,y1,0,3,0.10)  ;x,y必须同记录数
;************************************************
; plotting parameters that remain constant
;************************************************
   plot=new(6,graphic)                            ; creates a graphic array
   res               = True                       ; no plot mods desired
 ;  res@tiXAxisString = "Frequency (cycles/month)" ; xaxis
   res@gsnFrame      = False                      ; required for panel plots
   res@gsnDraw       = False                      ; required for panel plots
   
   res@tmXBLabelFontHeightF = 0.035
   res@tmEqualizeXYSizes = True
   ;res@tmLabelAutoStride = True
   res@tmXBLabelAngleF = -30
   res@tmXBLabelJust  = "CenterLeft";"BottomRight"
   res@tiYAxisFontHeightF =0.045
   res@tiYAxisSide     = "Right"
   res@tiYAxisAngleF   = -90
   res@tiYAxisOffsetXF = -0.02   
   
   res@tmXBMode      = "Explicit"
   res@tmXBLabels           = c/12.
   res@tmXBValues           = 1./c
   res@trXMaxF              = sh(0);1./10    ;放大
   res@trXMinF              = sh(1);1./60
   res@tmXMajorGrid                = True 
   res@tmXMajorGridThicknessF      = 1.0           
   res@tmXMajorGridLineDashPattern = 16
   res@xyLineThicknesses           = 1.5
;************************************************
; create plot of cospectrum
;************************************************
   res@tiYAxisString = "Cospectrum"               ; yaxis
   res@trYMinF = sh(2);-7000
   res@trYMaxF = sh(3);3000
   plot(4)=gsn_csm_xy(wks,spec@frq,spec@cospc,res); create plot   
;***********************************************
; create plot of quadrature spectrum. 
;************************************************
   res@tiYAxisString = "Quadrature"               ; yaxis
   res@trYMinF = sh(4)
   res@trYMaxF = sh(5) 
   plot(5)=gsn_csm_xy(wks,spec@frq,spec@quspc,res); create plot   
;***********************************************
; create plot of coherance
;************************************************
delete(res@trYMinF)
delete(res@trYMaxF)
   res@tiYAxisString   = "Coherance SQ"             ; yaxis 
   res@gsnYRefLineThicknessF = 1.
   res@gsnYRefLineColor  = 1
   res@gsnYRefLineDashPattern = 3
   res@gsnYRefLine     = spec@coher_probability(1)  ;90,95,99,99.9 ，不知道是不是t检验的平方？
   plot(2)=gsn_csm_xy(wks,spec@frq,spec@coher,res) 
;***********************************************
; create plot of phase
;************************************************
   res@tiYAxisString = "Phase"                    ; yaxis
   res@gsnYRefLine     = 0
   res@trYMaxF         = 180
   res@trYMinF         = -180
   res@tmYLMode             = "Explicit"
   res@tmYLValues           = (/-180,-90,-45,0,45,90,180/)
   res@tmYLLabels           = (/"-pi","-pi/2","-pi/4","0","pi/4","pi/2","pi"/)
   plot(3)=gsn_csm_xy(wks,spec@frq,spec@phase,res); create plot  
   delete(res@gsnYRefLine)
   delete(res@trYMinF)
   delete(res@trYMaxF)
   delete(res@tiXAxisString)
;************************************************
; create plot spec iod
;************************************************
   res@tmYLMode     = "Automatic"
   res@trYMaxF       = sh(6);4000
   res@tiYAxisString = "Variance of x"          ; yaxis 
   splt = specx_ci(spec,0.05,0.95)  
   plot(0)=gsn_csm_xy(wks,spec@frq,splt,res)  ; create plot
     
;************************************************
; create plot spec mei
;************************************************
   res@tiYAxisString = "Variance of y"          ; yaxis
   res@trYMaxF       = sh(7);10000
   spec@spcx = spec@spcy   
   splt = specx_ci(spec,0.05,0.95)  
   plot(1)=gsn_csm_xy(wks,spec@frq,splt,res)  ; create plot  
;***************简单堆砌布置**************************
;  plot1 = (/plot(),plot().../)  ;挑选显示
   res_P             = True                        ; panel mods desired
   res_P@gsnMaximize = True                        ; blow up plot
   res_P@tiMainString = tag
   res_P@tiMainDirection = "Down"
   res_P@tiMainPosition = "Left"
   res_P@txString    = tag
   gsn_panel(wks,plot,(/3,2/),res_P)               ; create panel plot
   return(spec)
 end
