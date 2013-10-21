undef("series_comx")
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$WORK/compress@.ncl"  ;本子程序中_2與否無所謂。不涉及維數環境。
procedure series_comx(Var,lev,tag,Ltime,Htime,wks,opt)  ;lev是event水平，opt是event方案。主要是针对标志的位置。
local Var0,dim,n,movstd,std,ave,i,j,sign,plot,yyyyfrac,Ltime0,Htime0,Ltime1,Htime1,res,res1,pres,attachres1,attachres2
;  Var(n-1,:),tag(n-1),Ltime(n-1,:),Htime(n-1,:),wks
begin
  Var0    = transpose(transpose(Var))   ;針對一個變量。
  LTime   = transpose(transpose(Ltime))
  HTime   = transpose(transpose(Htime)) 
  dim = dimsizes(Var0)
  n = dim(0)
  if(opt.eq.2) n = n/3  end if;2/3矩陣是儲存滑動所得的窗口序列std和ave的。
  std = dim_stddev(Var)
  ave = dim_avg(Var)
  time = Var&time
  Var0!1 = "time"
  Var0&time = time
 ; Std = conform(Var,std,0)  ;Var-Std is ok
  sign = Var0
  do i = 0,n-1
   k = dimsizes(compress(Var0(i,:),Var@_FillValue))
  do j = 0,k-1;dimsizes(time)-1
   ;if(Var0(i,j).ne.Var0@_FillValue)
if(opt.eq.0)    ;opt
  if((Var0(i,j)-lev(i))*(Var0(i,j)+lev(i)).lt.0)then
     sign(i,j) = (/ave(i)/)  ;!!第一次赋值，要首先消除dim差别。此后就不必了。
   else
   if((Var0(i,j)-lev(i)).ge.0)
     sign(i,j) = ave(i)+lev(i)
   end if
   if((Var0(i,j)+lev(i)).le.0)
     sign(i,j) = ave(i)-lev(i)
   end if
  end if  
end if

if(opt.eq.1)    ;opt  ;其实可以利用opt=0/1的特殊性，结合*和+统一起来。
 if((Var0(i,j)-ave(i)-std(i)*lev(i))*(Var0(i,j)-ave(i)+std(i)*lev(i)).lt.0)
     sign(i,j) = (/ave(i)/)
   else 
   if((Var0(i,j)-ave(i)-std(i)*lev(i)).ge.0)
     sign(i,j) = ave(i)+std(i)*lev(i)
   end if
   if((Var0(i,j)-ave(i)+std(i)*lev(i)).le.0)
     sign(i,j) = ave(i)-std(i)*lev(i)
   end if
  end if
end if

if(opt.eq.2)    ;opt   ;爲了顯示上清楚，相對於opt=1，只是修改了標註的條件，並沒有更改標識位置。但是另外加了一條std的曲綫。
  if((Var0(i,j)-Var0(2*n+i,j)-Var0(n+i,j)*lev(i))*(Var0(i,j)-Var0(2*n+i,j)-Var0(n+i,j)*lev(i)).lt.0)
     sign(i,j) = (/ave(i)/)
   else
   if((Var0(i,j)-Var0(2*n+i,j)+Var0(n+i,j)*lev(i)).le.0)
     sign(i,j) = ave(i)-std(i)*lev(i)
         ;   print(j+" L: "+sign(i,j))
   end if
   if((Var0(i,j)-Var0(2*n+i,j)-Var0(n+i,j)*lev(i)).ge.0)
     sign(i,j) = ave(i)+std(i)*lev(i)
         ;   print(j+" H: "+sign(i,j))
   end if
  end if
end if
    ; end if
  end do
  end do

  
; wks = gsn_open_wks("X11" ," ")
 ; yyyyfrac = compress(yyyymm_to_yyyyfrac(Var&time,0),Ltime@_FillValue)  ;yyyy函数可以处理missingvalue，而且不會改變原變量傳遞的缺省值。  ;time@_FillValue未定义。
 ;   delete(yyyyfrac@long_name)
 yyyyfrac = yyyymm_to_yyyyfrac(Var&time,0)
    plot = new(n,graphic)
    dum0 = plot
    dum1 = plot
    if(opt.eq.2)
    dum2 = dum0 
    dum3 = dum0 
    end if
  res                       = True
  res@gsnDraw               = False
  res@gsnFrame              = False 
 ; res@gsnMaximize           = True
  res@vpWidthF              = 0.75       
  res@vpHeightF             = 0.25 
  res@vpXF          = 0.1
 ; res@vpYF          = 0.1
  res@trXMinF       = min(yyyyfrac)
  res@trXMaxF       = max(yyyyfrac)
 ; res@tmXTDataLeftF  = min(yyyyfrac)
 ; res@tmXTDataRightF = max(yyyyfrac)

 ; res@gsnYRefLineColor      = (/-1,1,-1/)
 ; res@gsnBelowYRefLineColor = (/ "sky blue", "transparent", "transparent"/)
 ; res@gsnAboveYRefLineColor = (/ "transparent", "transparent", "pink"/)
  res@xyLineThicknessF      = 2.0
  res@tmXTOn                = False   ;因为不齐删了 
  res@tmXBOn                = False
  pres                      = res
 ; res@tiYAxisFontHeightF    = 0.02
 ; res@tmYLLabelFontHeightF  = 0.01      ; resize tick labels
  res@tmEqualizeXYSizes     = True
  res@tmLabelAutoStride     = True
  res@gsnYRefLineDashPatterns = (/3,0,3/)   ;注意 s
  res@xyDashPattern  = 0
  res1                      = res
  res@tfPolyDrawOrder       = "PreDraw"          ;很重要，而且res1不能设。只有这样才能调整各图尺寸,而且只有这样才不会出现x轴虽然同，但是由于y轴的影响，还是不能重叠好。
 ; res@tmYLLabelFontHeightF  = 0.02 

  res1@xyDashPattern       = 0         ; 关掉自动为2nd换线型
  res1@tiYAxisSide          = "Right"
;  res1@xyLineThicknessF     = 2.     ;我想要细线。  2
;  res1@tiYAxisFontColor     = res1@xyLineColor  
;  res1@tmYLLabelFontColor   = res1@xyLineColor
  res1@tmYLLabelsOn         = False
  res1@tmYRLabelsOn         = True
  
  pres@xyMarkLineMode     = "Markers"
  pres@xyMarker           = 5
  pres@tmXMajorGrid = True
  pres@tmXMinorGrid = True
  pres@tmXMinorGridLineDashPattern = 3
  pres@tmXMajorGridThicknessF = 1.  
 ; pres@gsnYRefLine          = 0  
   
  do i = 0,n-1,2  
if(opt.eq.0)
  res@gsnYRefLine           = (/ave(i)-lev(i),ave(i),ave(i)+lev(i)/)
end if
if(opt.eq.1.or.opt.eq.2)
  res@gsnYRefLine           = (/ave(i)-std(i)*lev(i),ave(i),ave(i)+std(i)*lev(i)/)  
end if   
  res@tiYAxisString         = tag(i)  
  if(i.eq.n-1) res@tmXBOn   = True end if 
 plot(i) = gsn_csm_xy(wks,yyyyfrac,Var0(i,:),res) 
  pres@tmYLOn   = False   ;tmYLValues
  pres@tmXMinorGrid = False
  pres@tmXMajorGrid = False
;  if(i.eq.n-1) pres@tmXBOn = True
;  else
 ; if(i+1.eq.n-1) pres@tmXBOn = True end if
 ; end if
; pres@trXMaxF = right  ;overlay不需要設這些了。
  pres@xyMarkerColor = "green"
;  Ltime1 = yyyymm_to_yyyyfrac(compress(LTime(i,:),LTime@_FillValue),0)   ;要保留Ltime1和Ltime0
  Ltime0 = compress(LTime(i,:),LTime@_FillValue)
  Ltime1 = yyyymm_to_yyyyfrac(Ltime0,0)
        ; delete(Ltime1@long_name)
  dum0(i)  = gsn_csm_xy(wks,Ltime1,sign(i,{Ltime0}),pres)   ;不能自動處理缺省值做坐標的部分
   delete(Ltime0)
   delete(Ltime1)
  pres@xyMarkerColor = "red"
  Htime0 = compress(HTime(i,:),HTime@_FillValue)  ;如果输入的是按最短序列，则Htime1都不需要设置。
  Htime1 = yyyymm_to_yyyyfrac(Htime0,0)
       ;  delete(Htime1@long_name)
  dum1(i) = gsn_csm_xy(wks,Htime1,sign(i,{Htime0}),pres)
   delete(Htime0)
   delete(Htime1)
  if(opt.eq.2)
;  res@xyDashPattern  = 3
;  dum2(i) = gsn_csm_xy(wks,yyyyfrac,Var0(i,:)+Var0(n+i-1,:),res)
;  dum3(i) = gsn_csm_xy(wks,yyyyfrac,Var0(i,:)-Var0(n+i-1,:),res)
;  overlay(plot(i),dum3(i)) 
;  overlay(plot(i),dum2(i)) 
  end if
   overlay(dum0(i),dum1(i))
   overlay(plot(i),dum0(i))  ;利用overlay取代draw就是爲了避免設了vp和tr範圍以後，兩圖仍然不能坐標軸對齊。
   
if(i+1.le.n-1)
  if(opt.eq.0)
  res1@gsnYRefLine           = (/-lev(i+1),ave(i+1),lev(i+1)/)
  end if
  if(opt.eq.1.or.opt.eq.2)
  res1@gsnYRefLine           = (/ave(i+1)-std(i+1)*lev(i+1),ave(i+1),ave(i+1)+std(i+1)*lev(i+1)/)    
  end if 
  res1@tiYAxisString         = tag(i+1)  
  if(i+1.eq.n-1) res1@tmXBOn   = True end if 
plot(i+1)  = gsn_csm_xy(wks,yyyyfrac,Var0(i+1,:),res1)
  pres@xyMarkerColor = "green"
  Ltime0 = compress(Ltime(i+1,:),Ltime@_FillValue)
  Ltime1 = yyyymm_to_yyyyfrac(Ltime0,0) 
      ;  delete(Ltime1@long_name) 
  dum0(i+1)  = gsn_csm_xy(wks,Ltime1,sign(i+1,{Ltime0}),pres)
  pres@xyMarkerColor = "red"
  Htime0 = compress(Htime(i+1,:),Htime@_FillValue)
  Htime1 = yyyymm_to_yyyyfrac(Htime0,0)  
      ; delete(Htime1@long_name)
  dum1(i+1)  = gsn_csm_xy(wks,Htime1,sign(i+1,{Htime0}),pres) 
   delete(Ltime0)
   delete(Htime0)
   delete(Ltime1)
   delete(Htime1)
   overlay(dum1(i+1),dum0(i+1))
   overlay(plot(i+1),dum1(i+1))
end if
  end do  
  attachres1                     = True
  attachres1@gsnAttachPlotsXAxis = True  ;; attaches along x-axis
  attachres1@gsnAttachBorderOn   = False ;; No border please
  attachres2                     = attachres1
  
  i = 1
  if(n.gt.1) 
  attachid1  = gsn_attach_plots(plot(0),plot(i:),attachres1,attachres2)  ;variable vs constant: i vs 1
  end if
  draw(plot)
  frame(wks)
;  maximize_output(wks,False)
end
  
  
   
  
