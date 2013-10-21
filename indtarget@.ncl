  undef("indtarget")
  function indtarget(a,target) ;最好是最小/最大值
  local d,c,nm,bf,tnum,cnum,ca
  begin
    d = ndtooned(a)
    c = new((/2,1000/),integer)
    nm = dimsizes(target)
    tnum = new(nm,integer)
    do i=0,nm-1
    bf = ind(d.eq.target(i))
    tnum(i) = dimsizes(bf)
    c(0,:tnum(i)-1) = bf
    delete(bf)
    end do
;if(.not.all(ismissing(c))) then
; cnum = where(num(ismissing(c(0,:)).ge.num(ismissing(c(1,:)),num(.not.ismissing(c(1,:)),num(.not.ismissing(c(0,:)))
;end if
    cnum = max(a)
    ca = c(:,:cnum-1)
    ca@target = target ;可以不声明，默认为0维
    return(ca)
  end
 
; load "$WORK/indtarget@.ncl"
     ;return多维数组一维化以后的坐标。可以利用ind_resolve来改善。
; write_matrix(ca,jjf7.2",opt)
