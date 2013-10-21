undef("drawwavelet")  ;0-morlet,dt-1次取样，6，2-最小尺度2dt，0.25-离散波步长，尺度数的整数？jtot-大概是y轴域，npad-dimsizes，noise-1，0-卡方检验，0.05-95%水平，0.
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;load "$WORK/compress@.ncl"
procedure drawwavelet(x,opt,dtopt,Value,Label,nm,span,opt1,wks)  
;opt>0时只画小波图，span可以随便设；<0时，span为截取波的范围,Value和Label可以随便设；opt=0时即画小波也画截取波。opt1=1时画附侧全波图，否则不画。 deopt-0:逐年数据，-1：逐月数据。
local n,jtot,w,power,SIG,plot,iplot,gws,plotc,plotg,scale,Cdelta,powernorm,scaleavg
begin
  n = dimsizes(x)
  jtot = 1+floattointeger(((log10(n/2))/0.25)/log10(2.))
  w = wavelet(x,0,1,6,2,0.25,jtot,n,1,0,0.05,0)
  yyyyfrac = yyyymm_to_yyyyfrac(x&time,0.)
  power            = onedtond(w@power,(/jtot,n/))
  power!0          = "period"                        ; Y axis
  power&period     = w@period                   ; convert periodperiod to units of years
                                                ;jtot编号的scale对应的傅立叶周期，画的图更准确。
  power!1          = "time"                          ; X axis
  power&time       = yyyyfrac

  power@long_name  = "Power Spectrum"     ;gsnleft
  power@units      = "1/unit-freq"        ;gsnright

; compute significance ( >= 1 is significant)
  SIG              = power                            ; transfer meta data
  SIG              = power/conform(power,w@signif,0)  ;功率值达到显著性水平的才shade
  SIG@long_name    = "Significance"
  SIG@units        = " "
  printMinMax(power,True)
  printMinMax(SIG,True)
    gsn_define_colormap(wks,"BlAqGrYeOrReVi200") 
  plot = new(1+nm,graphic)

  res                     = True                  ; plot mods desired
  res@gsnDraw             = False                 ; Do not draw plot
  res@gsnFrame            = False                 ; Do not advance frome
  res@vpYF                = .98
  res@vpWidthF            = 0.6 
  res@vpHeightF           = 0.4
  res@tmXTOn              = False
  res@trYMinF             = span(0)
  res@trYMaxF             = span(1)
  if(dtopt.eq.1)
  res@trYMinF             = span(0)*12
  res@trYMaxF             = span(1)*12
  end if
  res@trYReverse          = True                  ; reverse y-axis
  res@tmYLMode            = "Explicit"
  res@tmYLValues = Value;(/1,2,4,8,16,32/)              ;y 坐标位置
  if(dtopt.eq.1) 
  res@tmYLValues = Value*12
  end if
  res@tmYLLabels = Label;(/"1","2","4","8","16","32"/)   ;y 坐标值
 ; res@tmYRLabelsOn = True      ;;;
  res@tiXAxisString = ""
  res2                    = res
  res@cnFillOn            = True                  ; turn on color
  res@cnFillMode          = "RasterFill"          ; turn on raster mode  ；？？？？？？？？？
  res@cnRasterSmoothingOn = True                  ; turn on raster smoothing
  res@cnLinesOn           = False                 ; turn off contour lines
  res@cnLineLabelsOn      = False
  res@cnInfoLabelOn       = False
;  res@cnLevelSelectionMode =  "ManualLevels"             ;;;
;  res@cnMaxLevelValF       = 40                     ;;;
;  res@cnMinLevelValF       = 0                     ;必须配对用才会有反应
;  res@cnLevelSpacingF     =  2
  res@gsnSpreadColors     = True                  ; use full colormap
 ; res@tmLabelAutoStride   = True
  res@vpHeightF           = .3                    ;图尺寸
  res@vpWidthF            = .6
  ;res@cnLevelSelectionMode= "ExplicitLevels"      ; set manual contour levels
  res@lbLabelAutoStride   = True
  res@gsnLeftString       = ""
  res@gsnRightString      = ""
 ; res@cnLevels = (/0.5,1.,2.,4./)                  ;选择绘曲线
      
;  res2@cnLevelSelectionMode = "ManualLevels" ; set manual contour levels ;
;  res2@cnMinLevelValF      = 0.00        ; set min contour level  ;
;  res2@cnMaxLevelValF      = 2.00        ; set max contour level  ;
;  res2@cnLevelSpacingF     = 1.00        ; set contour spacing
  res2@cnInfoLabelOn       = False
  res2@cnLinesOn           = False       ; do not draw contour lines
  res2@cnLineLabelsOn      = False       ; do not draw contour labels
  res2@lbLabelBarOn        = False
  res2@cnFillScaleF        = 0.5         ; add extra density
  res2@gsnLeftString  = ""
  res2@gsnRightString = ""  

  if(opt.ge.0)  
  plot(0) = gsn_csm_contour(wks,power,res)   
  iplot = gsn_csm_contour(wks,SIG,res2)
  iplot = ShadeGtContour(iplot,1.,17)    ; power>signif的画出来
  overlay(plot(0),iplot)		
  end if
  
  if(opt1.eq.1)
   gws = w@gws
  resl = True
  resl@gsnFrame = False
  resl@gsnDraw = False
  resl@trYReverse          = True                  ; reverse y-axis
  resl@tmYRMode = "Explicit"
  resl@tmYRValues = Value
  resl@tmYRLabels = Label
  resl@vpWidthF   = .3
  resl@trYMinF             = span(0)
  resl@trYMaxF             = span(1)
  if(dtopt.eq.1)
  resl@trYMinF             = span(0)*12
  resl@trYMaxF             = span(1)*12
  end if
  resl@tmXTOn              = False
  resl@tmLabelAutoStride   = True
  resl@trYAxisType = "LogAxis"    ;对数坐标  !因为小波把时间处理成对数log2坐标了，为了配合period对应jtot。；？？？log2
  
  plotg = gsn_csm_xy(wks,gws,power&period,resl)     ;高明的配合表现周期信号总强度。
  plotc = gsn_attach_plots(plot(0),plotg,res,resl)
  end if
  
  if(opt.le.0)
   scale = w@scale
  Cdelta = w@cdelta
  powernorm = power
  powernorm = power/conform(power,scale,0)

  ress = True
  ress@vpKeepAspect = False
  ress@vpHeightF = 0.1
  ress@vpWidthF       = .6
  ress@xyDashPatterns = (/0,1/)
  ress@pmLegendDisplayMode = "Always"
  ress@pmLegendOrthogonalPosF = -1.9    ; 上下移
  ress@pmLegendParallelPosF   =  0.13 ;0.87   ; 左右移
  ress@pmLegendWidthF         =  0.1 ; 长
  ress@pmLegendHeightF        =  0.08  ; 宽
  ress@tmXBLabelFontHeightF = 0.015
  ress@tmEqualizeXYSizes    = True  
  ress@lgPerimOn              = False   ; turn off box around
  ress@lgLabelFontHeightF     = .017 
  ress@gsnFrame = False
  ress@gsnDraw  = False
  ress@tiXAxisString       = ""
  ress@tmXTOn              = False
  ress@trXMinF             = min(yyyyfrac)   ;;;;;;;;;
  ress@trXMaxF             = max(yyyyfrac)  
  ress@tmYLFormat          = "e"
  ress@tmYLLabelStride     = 2
 ; ress@tmYLLabelDeltaF     = 1 ;只是按fontheight的尺寸的倍数来移动label位置

  yn = 0.72           ;;;
  do i = 1,nm 
  print(yn+" : "+i)
  ress@vpYF = yn-0.18    ;;;
  ress@xyExplicitLegendLabels = (/span(i*2)+"-"+span(i*2+1)+" yr"/)   
 ; ress@tiYAxisString = "variance"
;if(i.eq.3)  ress@pmLegendOrthogonalPosF = -1.5  end if  ; 上下移  ;;;
  scaleavg = 0.25*1/Cdelta*dim_sum_Wrap(powernorm(time|:,{period|span(i*2)*12:span(i*2+1)*12}))   
  plot(i) = gsn_csm_xy(wks,yyyyfrac,scaleavg,ress)  
  getvalues  plot(i)
  "vpYF" :yn
  end getvalues
  end do
  end if
  
 ; if(opt.eq.0)
 ; pres = True
 ; pres@gsnMaximize = True
 ; pres@gsnPaperOrientation = "portrait"
 ; gsn_panel(wks,plot,(/1+nm,1/),pres)
 ; else
 ; if(opt.gt.0)  draw(plot(0))  end if  
 ; if(opt.lt.0)  draw(plot(1))  end if
 ; frame(wks)
 ; end if
 draw(plot)
 frame(wks)
end
