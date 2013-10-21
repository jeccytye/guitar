undef("plotjust")
procedure plotjust(wks:graphic, plot1:graphic, plot2:graphic, just:string, width:numeric, height:numeric)
local res,sx,ex,sy,ey,map,x,y,w,h,xl,xr,yt,yb,eps
begin   ;已有plot1，调整plot2的大小和位置，附在plot1的四角位置，加框;
;由
  eps=0.001

  getvalues plot1
    "vpXF" : x
    "vpYF" : y
    "vpWidthF"  : w
    "vpHeightF" : h
  end getvalues
  if (just .eq. "BottomLeft")
    y=y-h+height
  end if
  if (just .eq. "TopRight")
    x=x+w-width
  end if
  if (just .eq. "BottomRight")
    x=x+w-width
    y=y-h+height
  end if
  xl=x
  yt=y
  xr=x+width-eps
  yb=y-height
  
  setvalues plot2
    "vpXF"      : x
    "vpYF"      : y
    "vpWidthF"  : width
    "vpHeightF" : height
  end setvalues
     NhlAddOverlay(plot1,plot2,plot1)
  res=True 
  res@gsFillColor=0
  gsn_polygon_ndc(wks, (/xl,xl,xr,xr,xl/), (/yt,yb,yb,yt,yt/), res)
  delete(res)

end
