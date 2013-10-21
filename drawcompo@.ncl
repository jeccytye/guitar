undef("drawmap")
undef("drawcompo_cn")
;res = True
;wks = gsn_open_wks("X11","h_lat")  
; gsn_define_colormap(wks,"wh-bl-gr-ye-re")

function drawcompo_cn(res)  ;cp本模板，然后修改定制所需的临时子程序
local
begin
  res@gsnAddCyclic                    = False
  res@gsnDraw                         = False
  res@gsnFrame                        = False
 ; res@vpXF                            = .1
 ; res@vpYF                            = .1
  res@vpHeightF                       = 0.4
  res@vpWidthF                        = 0.8  
;******@lb  
;  res@lbTitleString                   = ""
;  res@lbTitleFontHeightF              = 0.018
  res@lbLabelFontHeightF              = 0.02
  res@lbLabelBarOn                    = False
  res@gsnSpreadColors                 = True   
  res@gsnSpreadColorStart             = 17    ;;;
  res@gsnSpreadColorEnd               = -2    ;;;
  res@lbOrientation             = "Vertical"
  res@pmLabelBarOrthogonalPosF  = -0.07
  res@pmLabelBarParallelPosF   = 0.015
  res@lbTitlePosition           = "Bottom"	; put it below the plot
  res@lbLabelAutoStride          = True   ;会自动设label的字大小
  res@lbLabelStride              = 2              ; every other color
  resP@pmLabelBarWidthF          = 0.15
  resP@pmLabelBarKeepAspect      = True
;*******@tx  
  res@gsnLeftStringFontHeightF        =0.011
  res@gsnCenterStringFontHeightF      =0.012
  res@gsnRightStringFontHeightF       =0.011
  res@tiXAxisFontHeightF              = 0.03    
  res@tiYAxisFontHeightF              = 0.03
  res@gsnLeftString        = ""
  res@gsnCenterString      = ""
  res@gsnRightString       = ""
  res@tiXAxisString        = ""
  res@tiYAxisString        = ""  
;---------  
  res@gsnPanelLabelBar     = True  ;一般供panel用
  res@txFontHeightF        = .02   
  res@txString             = ""
  res@txPosXF              = 0.08
  res@txPosYF              = .43
  res@txAngleF             = 90
  res@txJust               = "TopLeft"
;********@tm  
  res@tmYLLabelFontHeightF            = 0.01
  res@tmEqualizeXYSizes               = True
  res@tmYROn               = False
  res@tmYLMinorOn          = False   ;局部关闭刻记
  res@tmXTOn               = False
  res@tmYRLabelsOn         = False
  res@tmXTLabelsOn         = False
    res@tmYRMode           = "Automatic" 
    res@gsnMajorLatSpacing = 30      ;标记label间隔
    res@gsnMinorLatSpacing = 10
    res@tmYRLabelDeltaF    = 2.0
    res@tmLabelAutoStride  = True
    res@tmXBLabelStride    = 10
    res@tmXBMode           = "Explicit"
    res@tmXBValues         = ispan(0,371,60) 
    res@tmXBLabels         = ispan(1958,2010,5)
    res@tmXBMode           = "Manual"
    res@tmXBTickSpacingF   = 5
  res@tmXUseBottom       = True
  res@tmYRAutoPrecision  = True    
  res@tmYRPrecision      = 4
  res@tmYRFormat         = "f"     ; "0@*+^sg"
  
  res@trYReverse         = True
  res@trYMinF            = -20
  res@trYMaxF            = 20
;*********@cn  
  res@cnInfoLabelOn                   = False  
;  res@cnInfoLabelFontHeightF          = 0.03 
  res@cnInfoLabelOrthogonalPosF       = -0.07 ; move contour label up 到图内右下角 
  res@cnInfoLabelFontHeightF          = 0.03
  res@cnLinesOn           = False
  res@cnLineDrawOrder     = "PreDraw" 
  res@cnLineThicknessF    = 1.  
  res@cnLineDashPatterns  = 0                ;莫非可以类似xy那样很多组变量一起画？
  res@cnLineLabelsOn                = False
  res@cnLabelDrawOrder              = "PreDraw"
  res@cnLineLabelFontHeightF        = 0.03
  res@cnLineLabelPlacementMode      = "Computed" 
  res@cnConstFLabelFontColor        = 1
  res@cnMonoLineLabelFontColor      = True
  res@cnLineLabelFontColor          = 0
  res@cnLabelMasking                = True
  res@cnLineLabelBackgroundColor    = -1
  
  res@cnFillOn            = True  
  res@cnFillDrawOrder     = "PreDraw"          
  res@cnFillPattern       = 0
  res@cnFillColors        = -1
     res@cnLevelSelectionMode =  "ManualLevels"   
     res@cnMinLevelValF       = -10.
     res@cnMaxLevelValF       =  45.
     res@cnLevelSpacingF      =   5. 
     res@cnLevelSelectionMode = "ExplicitLevels"
     res@cnLevels             = ispan(-5,35,5)
     symMinMaxPlt(eof, 16, False, res)     ; contributed.ncl,  set symmetric plot min/max  ，eof是输入数据本身
 res1 = res
 return(res1)
 end 
