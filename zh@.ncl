;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                                             ;
;                Copyright (C)  2007                                                          ;
;                Yongjun Zheng                                                                ;
;                All Rights Reserved                                                          ;
;                                                                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  Author:       Yongjun Zheng
;                National Key Laboratory of Atmospheric Sciences and Geophysical Fluid Dynamics
;                Institute of Atmospheric Physics
;                Chinese Academy of Sciences
;                P.O. Box 9804, Beijing 100029, China
;
;  Date:         Wed Nov 28, 2007
;
;  Description: 
;

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

undef("zh_rectgrid")
undef("zh_trim")
undef("zh_text")
undef("zh_map")
undef("zh_cbar")
undef("zh_southsea")
undef("zh_city")

function zh_rectgrid(tx:numeric, ty:numeric, tz:numeric, mvalue:numeric, mfile:string, mtype:string, nx:integer, ny:integer, sx:numeric, ex:numeric, sy:numeric, ey:numeric, mode:string, dataintaiwan:logical)
local gx,gy,cnmask,gdata,mdata,is,ie,js,je,opt
begin
  gx = fspan(sx, ex, nx)
  gx!0 = "lon"
  gx@units = "degrees_east"
  gx&lon = gx

  gy = fspan(sy, ey, ny)
  gy!0 = "lat"
  gy@units = "degrees_north"
  gy&lat = gy

  cnmask = fbindirread(mfile, 0, (/ny,nx/), mtype)
  cnmask!0 = "lat"
  cnmask&lat = gy
  cnmask!1 = "lon"
  cnmask&lon = gx

  if (mode .eq. "nat")
    gdata = natgrid_Wrap(ty, tx, tz, gy, gx)
  end if
  if (mode .eq. "tri")
    opt=True
    opt@distmx=100.0
    gdata = triple2grid(tx, ty, tz, gx, gy, opt)
  end if
  if (mode .eq. "css")
    gdata = cssgrid_Wrap(ty, tx, tz, gy, gx)
  end if
  if (mode .eq. "csa")
    knots = (/4,4/)
    gdata = csa2(ty, tx, tz, knots, gy, gx)
  end if
  if (mode .eq. "ds")
    dssetp("dmx", 1.0)
    gdata = dsgrid2(ty, tx, tz, gy, gx)
  end if
  gdata!0 = "lat"
  gdata&lat = gy
  gdata!1 = "lon"
  gdata&lon = gx

  mdata = mask(gdata, cnmask, mvalue)
  mdata!0 = "lat"
  mdata&lat = gy
  mdata!1 = "lon"
  mdata&lon = gx  
  
  ; if there is not data in taiwan
  if (.not. dataintaiwan)
    is=floattoint((120.0-sx)/0.1)
    ie=floattoint((122.0-sx)/0.1)
    js=floattoint((22.0-sy)/0.1)
    je=floattoint((25.1-sy)/0.1)
    mdata(js:je,is:ie)=mdata@_FillValue
  end if
  return mdata
end

function zh_trim(str[*]:string, side:string)
local nrow, trim, blank, ch, nc, k
begin
  nrow = dimsizes(str)                            ; # rows/strings
  trim = new(nrow, "string", "No_FillValue")      ; return string(s)

  blank = inttochar(32)                           ; character blank
 
  do n=0,nrow-1
      
    ; trim left
    ch = stringtochar(str(n))   
    nc = dimsizes(ch)-2
    if (side .eq. "both" .or. side .eq. "left")
      do k=0,nc
        if (ch(k) .ne. blank)
          trim(n)=chartostring(ch(k:nc))
          break
        end if   
      end do
    end if
    delete(ch)

    ; trim right
    ch = stringtochar(trim(n))   
    nc = dimsizes(ch)-2
    if (side .eq. "both" .or. side .eq. "right")
      do k=nc,0,-1
        if (ch(k) .ne. blank)
          trim(n)=chartostring(ch(0:k))
          break
        end if   
      end do
    end if
    delete(ch)

  end do
  return(trim)
end

procedure zh_text(wks:graphic, zstr:string, ndot:integer, style:string, just:string, csize:numeric, fgcolor:string, bgcolor:string, x:numeric, y:numeric)
local res,dir,filename,bitmap,nrow,ncol,nhzk,offset,width,xleft,ytop,qh,wh,cstr,clen,idx,bitval,i,j,k,n,newline,len,xl,xr,yt,yb,eps
begin
  eps=0.05
  onebyte=0
  bitval=(/128,64,32,16,8,4,2,1/)
  if (ndot .ne. 24 .and. ndot .ne. 40 .and. ndot .ne. 48) 
    print("Error: only 24, 40 and 48 dots font be surported now")
    return
  end if

  if (style .ne. "F" .and. style .ne. "f" .and. style .ne. "H" .and. style .ne. "h" .and. style .ne. "K" .and. style .ne. "k" .and. style .ne. "S" .and. style .ne. "s")
    print("Error: only the following style awailable:")
    print("F(f)---FangSong")
    print("H(h)---HeiTi")
    print("K(k)---KaiTi")
    print("S(s)---SongTi")
    return
  end if

  if (just .ne. "TopLeft" .and. just .ne. "CenterLeft" .and. just .ne. "BottomLeft" .and. just .ne. "TopCenter" .and. just .ne. "CenterCenter" .and. just .ne. "BottomCenter" .and. just .ne. "TopRight" .and. just .ne. "CenterRight" .and. just .ne. "BottomRight")
    print("Error: unknown justification: "+just)
    return
  end if
  
  if (csize .gt. 0)
    width=csize/(1.0*ndot)
  else
    print("Error: char size must be greater than 0")
    return
  end if
  
  if (style .eq. "F" .or. style .eq. "f")
    filename="HZK"+sprinti("%2i",ndot)+"F"
  end if
  if (style .eq. "H" .or. style .eq. "h")
    filename="HZK"+sprinti("%2i",ndot)+"H"
  end if
  if (style .eq. "K" .or. style .eq. "k")
    filename="HZK"+sprinti("%2i",ndot)+"K"
  end if
  if (style .eq. "S" .or. style .eq. "s")
    filename="HZK"+sprinti("%2i",ndot)+"S"
  end if

  offset=0
  nrow=ndot
  ncol=ndot/8
  nhzk=(offset+72)*94
  dir="$WORK/script/font/"
  bitmap=fbindirread(dir+filename,0,(/nhzk,nrow,ncol/),"byte") 

  cstr=stringtochar(zstr)
  clen=sizeof(cstr)-1

  n=0
  newline=True
  do while (n .lt. clen)
    if (newline)
      do len=n,clen-1
        if (chartoint(cstr(len)) .eq. 10)
          break
        end if
      end do
      len=len-n
      
      xleft=x
      ytop=y
      if (just .eq. "CenterLeft")
        ytop=ytop+csize/2.0
      end if
      if (just .eq. "BottomLeft")
        ytop=ytop+csize
      end if
      if (just .eq. "TopCenter")
        xleft=xleft-csize*len/4.0
      end if
      if (just .eq. "CenterCenter")
        xleft=xleft-csize*len/4.0
        ytop=ytop+csize/2.0
      end if
      if (just .eq. "BottomCenter")
        xleft=xleft-csize*len/4.0
        ytop=ytop+csize
      end if
      if (just .eq. "TopRight")
        xleft=xleft-csize*len/2.0
      end if
      if (just .eq. "CenterRight")
        xleft=xleft-csize*len/2.0
        ytop=ytop+csize/2.0
      end if
      if (just .eq. "BottomRight")
        xleft=xleft-csize*len/2.0
        ytop=ytop+csize
      end if
      
      if (fgcolor .ne. bgcolor)
        xl=xleft
        xr=xleft+csize*len/2.0+csize/2.0
        yt=ytop
        yb=ytop-csize
    
        res=True
        res@gsFillColor=bgcolor
        gsn_polygon_ndc(wks,(/xl,xl,xr,xr,xl/),(/yt,yb,yb,yt,yt/),res)        
      end if
      
      newline=False
    end if
    
    if (chartoint(cstr(n)) .eq. 10)
      n=n+1
      newline=True
      ytop=ytop-csize
      continue
    end if

    if (n+1 .lt. clen .and. chartoint(cstr(n)) .gt. 160 .and. chartoint(cstr(n+1)) .gt. 160)
      ; for Chinese
      qh=chartoint(cstr(n))-160
      wh=chartoint(cstr(n+1))-160
      idx=(qh-16+offset)*94+(wh-1)
      if (idx .lt. 0 .or. idx .ge. nhzk) 
        n=n+2
        xleft=xleft+csize
        continue
      end if
      
      do j=1,nrow
        yt=ytop-(j-1)*width
        yb=ytop-j*width
        do i=1,ncol
          onebyte=bitmap(idx,j-1,i-1)
          do k=1,8
            if (onebyte/bitval(k-1) .gt. 0) 
              xl=xleft+((i-1)*8+(k-1))*width
              xr=xleft+((i-1)*8+k)*width
            
              res=True
              res@gsFillColor=fgcolor
              gsn_polygon_ndc(wks,(/xl,xl,xr,xr,xl/),(/yt,yb,yb,yt,yt/),res)
            end if
            onebyte=onebyte%bitval(k-1)
          end do
        end do
      end do

      xleft=xleft+csize
      n=n+2
      if (n .lt. clen .and. chartoint(cstr(n)) .le. 160)
        xleft=xleft+eps*csize
      end if
    else
      ; for English
      res=True
      res@txFontHeightF=csize/2.0
      res@txJust="CenterLeft"
      res@txFontColor=fgcolor
      gsn_text_ndc(wks, chartostring(cstr(n)), xleft, ytop-csize*0.5, res)
      
      xleft=xleft+csize/2.0
      n=n+1
      if (n .lt. clen .and. chartoint(cstr(n)) .gt. 160)
        xleft=xleft+eps*csize
      end if
    end if
  end do
  
end

procedure zh_map(wks:graphic, plot:graphic, color:string, thick:numeric, style:integer)
local filename,n,map,np,factor,i,j,x,y,res
begin
  n=32757
  filename="$WORK/script/map.tab"
  map=asciiread(filename,(/n,2/),"float")
  
  np=2048
  x=new(np,float)
  y=new(np,float)

  j=0
  factor=0.0
  do while (j .lt. n)
    np=floattointeger(map(j,0))-1
    factor=map(j,1)
    j=j+1

    do i=0,np
      x(i)=map(j,0)
      y(i)=map(j,1)
      j=j+1
    end do
    
    res=True
    res@gsClipOn=True
    res@gsLineColor=color
    res@gsLineThicknessF=thick/factor
    res@gsLineDashPattern=style
    gsn_polyline(wks, plot, x(0:np), y(0:np), res)
  end do
end


procedure china_map(wks:graphic, plot:graphic, color:string, thick:numeric, style:integer)
local filename,n,map,np,factor,i,j,x,y,res
begin
  n=48580
  filename="$WORK/script/cn.txt"
  map=asciiread(filename,(/n,2/),"float")
  
  np=46317
  x=new(np,float)
  y=new(np,float)

  j=0
  factor=0.0
  do while (j .lt. n)
    np=floattointeger(map(j,0))-1
    factor=map(j,1)
    j=j+1

    do i=0,np
      x(i)=map(j,0)
      y(i)=map(j,1)
      j=j+1
    end do
    
    res=True
    res@gsClipOn=True
    res@gsLineColor=color
    res@gsLineThicknessF=thick/factor
    res@gsLineDashPattern=style
    gsn_polyline(wks, plot, x(0:np), y(0:np), res)
  end do
end


procedure china_river(wks:graphic, plot:graphic, color:string, thick:numeric, style:integer)
local filename,n,map,np,factor,i,j,x,y,res
begin
  n=301
  filename="$WORK/cnriver.txt"
  map=asciiread(filename,(/n,2/),"float")
  
  np=159
  x=new(np,float)
  y=new(np,float)

  j=0
  factor=0.0
  do while (j .lt. n)
    np=floattointeger(map(j,0))-1
    factor=map(j,1)
    j=j+1

    do i=0,np
      x(i)=map(j,0)
      y(i)=map(j,1)
      j=j+1
    end do
    
    res=True
    res@gsClipOn=True
    res@gsLineColor=color
    res@gsLineThicknessF=thick/factor
    res@gsLineDashPattern=style
    gsn_polyline(wks, plot, x(0:np), y(0:np), res)
  end do
end



procedure zh_cbar(wks:graphic, plot:graphic, just:string, width:numeric, height:numeric,format:string, title:string, csize:numeric, cbres:logical)
local nlab,nlev,ncol,labels,levels,colors,res,lb,x,y,w,h,xl,xr,yt,yb
begin
  getvalues plot
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
  xr=x+width
  yb=y-height

  res=True
  res@gsFillColor=0
  gsn_polygon_ndc(wks, (/xl,xl,xr,xr,xl/), (/yt,yb,yb,yt,yt/), res)
  delete(res)

  if (cbres)
    colors=cbres@colors
    labels=cbres@labels
  else
    getvalues plot@contour
      "cnLevels" : levels
      "cnFillColors" : colors
    end getvalues
    nlev=dimsizes(levels)
    ncol=dimsizes(levels)
    nlab=nlev+2
    labels=new(nlab,"string")
    labels(0)=""
    labels(nlab-1)=""
    labels(1:nlab-2)=sprintf(format,levels)
  end if

  res=True
  res@vpXF=x
  res@vpYF=y
  res@vpWidthF=width
  res@vpHeightF=height
  res@lbFillColors=colors
  res@lbMonoFillPattern=True
  res@lbLabelAlignment="ExternalEdges"
  res@lbTitleOn=True
  res@lbTitleString=title
  res@lbTitleFontHeightF = csize
  lb=gsn_create_labelbar(wks,dimsizes(colors),labels,res)
  draw(lb)
end

procedure zh_southsea(wks:graphic, plot:graphic, just:string, width:numeric, height:numeric, color:string, thick:numeric, style:integer)
local res,sx,ex,sy,ey,map,x,y,w,h,xl,xr,yt,yb,eps
begin
  eps=0.001
  sx =105; 105.3
  ex =123; 123.8
  sy = 0;3
  ey = 25;21.5

  getvalues plot
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

  res=True 
  res@gsFillColor=0
  gsn_polygon_ndc(wks, (/xl,xl,xr,xr,xl/), (/yt,yb,yb,yt,yt/), res)
  delete(res)

  res = True
  res@mpProjection = "LambertConformal"
  res@mpLambertParallel1F = 20.
  res@mpLambertParallel2F = 50.
  res@mpLambertMeridianF = 105.

  res@mpFillOn = False
  res@mpOutlineBoundarySets ="Geophysical"; "NoBoundaries"
  res@mpPerimOn = True

  res@mpLimitMode = "LatLon"
  res@mpMinLatF = sy
  res@mpMaxLatF = ey
  res@mpMinLonF = sx
  res@mpMaxLonF = ex

  res@vpXF = x
  res@vpYF = y
  res@vpWidthF = width
  res@vpHeightF = height
  res@gsnFrame = False
  ;res@gsnDraw= False
  map = gsn_csm_map(wks, res)
  amres                  = True
  amres@amParallelPosF   = -0.4    
  amres@amOrthogonalPosF = -0.45   
  amres@amJust           = "TopLeft"
 ; map_anno = gsn_add_annotation(plot, map, amres) 
 ; return(map_anno)
 ; zh_map(wks, map, color, thick, style)
 ; china_map(wks, map, color, thick, style)
end

procedure zh_city(wks:graphic, plot:graphic, ndot:integer, style:string, just:string, csize:numeric, fgcolor:string, bgcolor:string, msize:numeric)
local res,data,cdata,city,lon,lat,x,y,i,n
begin
  data=asciiread("$WORK/script/city.tab",-1,"string")
  cdata=stringtochar(data)
  
  city=zh_trim(chartostring(cdata(:,0:9)),"left")
  lon=stringtofloat(charactertostring(cdata(:,10:24)))
  lat=stringtofloat(charactertostring(cdata(:,25:39)))
  res=True
  res@gsMarkerIndex=16
  res@gsMarkerSizeF=msize
  gsn_polymarker(wks,plot,lon,lat,res)
  
  n=dimsizes(data)
  x=new(n,"float")
  y=new(n,"float")
  datatondc(plot,lon,lat,x,y)
  do i=0,n-1
    zh_text(wks,city(i),ndot,style,just,csize,fgcolor,bgcolor,x(i),y(i))
  end do
end


