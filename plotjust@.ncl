undef("plotjust")
procedure plotjust(wks:graphic, plot1:graphic, plot2:graphic, just:string, width:numeric, height:numeric)
local res,sx,ex,sy,ey,map,x,y,w,h,xl,xr,yt,yb,eps
begin   ;����plot1������plot2�Ĵ�С��λ�ã�����plot1���Ľ�λ�ã��ӿ�;
;��
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