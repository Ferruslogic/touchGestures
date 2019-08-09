script "atc_TouchsGestures.mini.livecodescript"
script "TouchsGestures"
global gTouchs
local sChangerPinch, sAddressOfMovePinch, sDoubleTouchIDs, sAngleOfPinch
local sIsPinch = 0, sPinchId = 0
constant kDoubleClickInterval = 250
local sTouchDoubleDown, sLastTouchDown
local sTouchDoubleUp, sLastTouchUp
local tNumTouchs
local sPendingTouchStillDown, sStatTouchStillDown
constant kTouchStillDownTimeSec = 1
on touchStart pTouchID
local tLoc
put the mouseLoc into tLoc
put the millisec into gTouchs[pTouchID]["StartTime"]
if the num of lines of keys of gTouchs is 1 then
add 1 to sTouchDoubleDown
if sTouchDoubleDown is 1 then
put gTouchs[pTouchID]["StartTime"] into sLastTouchDown["StartTime"]
else if (gTouchs[pTouchID]["StartTime"] - sLastTouchDown["StartTime"]) <= kDoubleClickInterval then
put 0 into sTouchDoubleDown
put the mouseLoc into tLoc
send "TouchDoubleDown" to the long id of me with pTouchID, item  1 of tLoc, item 2 of tLoc
pass touchStart
else
put gTouchs[pTouchID]["StartTime"] into sLastTouchDown["StartTime"]
end if
if sPendingTouchStillDown is a number then cancel sPendingTouchStillDown
put tLoc into sStatTouchStillDown
send "_DispatchTouchDoubleDown pTouchID" to me in kTouchStillDownTimeSecs sec
put the result into sPendingTouchStillDown
end if
pass touchStart
end touchStart
on touchEnd pTouchID
local tTime = 0, tTouchFast, tMillisec, tLoc
put the millisec into tMillisec
put the num of lines of keys of gTouchs into tNumTouchs
put tMillisec - gTouchs[pTouchID]["StartTime"] into gTouchs[pTouchId]["CurrentTime"]
put round(gTouchs[pTouchId]["CurrentTime"]) into tTime
if gTouchs[pTouchID]["AddressOfTouch"] is empty then
put "None" into gTouchs[pTouchID]["AddressOfTouch"]
end if
if  gTouchs[pTouchID]["Changed"] is empty then
put 0 into  gTouchs[pTouchID]["Changed"]
end if
put gTouchs[pTouchID]["Changed"] into tChanger
put gTouchs[pTouchID]["AddressOfTouch"] into tAddressOfTouch
switch
case tTime <= 50
send "TouchVeryFast pTouchID, tChanger, tAddressOfTouch" to the long id of me in 0
put the result into tTouchFast
break
case tTime <= 250
send "Touchfast pTouchID, tChanger, tAddressOfTouch" to the long id of me in 0
put the result into tTouchFast
break
default
if tTime > 250 and tTime < 700 then
send "Touchslow pTouchID, tChanger, tAddressOfTouch" to the long id of me in 0
put the result into tTouchFast
else
send "TouchVerySlow pTouchID, tChanger, tAddressOfTouch" to the long id of me in 0
put the result into tTouchFast
end if
end switch
delete global gTouchs[pTouchId]
filter sDoubleTouchIDs without pTouchID
if tNumTouchs < 2 then
if sIsPinch is 1  then
put 0 into sIsPinch
send "PinchEnd  sPinchId" to the long id of me in 0
else
add 1 to sTouchDoubleUp
if sTouchDoubleUp is 1 then
put tMillisec into sLastTouchUp["StartTime"]
else if (tMillisec - sLastTouchUp["StartTime"]) <= kDoubleClickInterval then
put 0 into sTouchDoubleUp
put the mouseLoc into tLoc
put item  1 of tLoc into tTouchX
put item 2 of tLoc into tTouchY
send "TouchDoubleUp pTouchID, tTouchX, tTouchY" to the long id of me
else
put tMillisec into sLastTouchUp["StartTime"]
end if
end if
end if
if tNumTouchs is 0 then delete global gTouchs
pass touchEnd
end touchEnd
on touchRelease pID
touchEnd pID
pass touchRelease
end touchRelease
on touchMove pTouchID, pTouchX, pTouchY
if the mouse is not down then pass touchMove
if gTouchs[pTouchID]["StartLoc"] is empty then
put pTouchX, pTouchY into gTouchs[pTouchID]["StartLoc"]
else
put pTouchX, pTouchY into gTouchs[pTouchID]["CurrentLoc"]
put item 1 of gTouchs[pTouchID]["StartLoc"] - pTouchX into gTouchs[pTouchID]["ChangedInX"]
put item 2 of gTouchs[pTouchID]["StartLoc"]  - pTouchY into gTouchs[pTouchID]["ChangedInY"]
put round(sqrt((gTouchs[pTouchID]["ChangedInX"]^2) + (gTouchs[pTouchID]["ChangedInY"]^2))) into gTouchs[pTouchID]["Changed"]
put _AngleTouch(pTouchID) into gTouchs[pTouchID]["Angle"]
local tOldAddress = ""
if gTouchs[pTouchID]["AddressOfTouch"] is not empty then put gTouchs[pTouchID]["AddressOfTouch"] into tOldAddress
if gTouchs[pTouchID]["PrevLoc"] is a point then
put _AddressTouch(gTouchs[pTouchID]["PrevLoc"],gTouchs[pTouchID]["CurrentLoc"]) into gTouchs[pTouchID]["AddressOfTouch"]
else
put _AddressTouch(gTouchs[pTouchID]["StartLoc"],gTouchs[pTouchID]["CurrentLoc"]) into gTouchs[pTouchID]["AddressOfTouch"]
end if
if gTouchs[pTouchID]["AddressOfTouch"] is empty then put tOldAddress into gTouchs[pTouchID]["AddressOfTouch"]
end if
put the keys of gTouchs into sDoubleTouchIDs
if gTouchs[pTouchID]["CurrentLoc"] is a point then
if the num of lines of keys of gTouchs >= 2 then
if sIsPinch is 0 then
put 1 into sIsPinch
add 1 to sPinchId
send "PinchStart sPinchId" to the long id of me in 0
end if
local tInfoOfPinch
put _InfoOfPinch(pTouchID) into tInfoOfPinch
put item 1 of tInfoOfPinch into tChangerPinch
if sChangerPinch is not tChangerPinch then
send "PinchMove sPinchId, tChangerPinch" to the long id of me with
if item 3 of tInfoOfPinch is 0 then send "PinchZoomingDown sPinchId, tChangerPinch" to the long id of me in 0
if item 3 of tInfoOfPinch is 1 then send "PinchZoomingUp sPinchId, tChangerPinch" to the long id of me in 0
end if
put item 1 of tInfoOfPinch  into sChangerPinch
local tAngleOfPinch = 0
put item 2 of tInfoOfPinch into tAngleOfPinch
if abs(tAngleOfPinch) > 5 and sAngleOfPinch <> tAngleOfPinch then
send "PinchRotate sPinchId, tAngleOfPinch" to the long id of me in 0
end if
put tAngleOfPinch into sAngleOfPinch
else
local tAngle = 0
put gTouchs[pTouchID]["Angle"] into tAngle
if gTouchs[pTouchID]["Changed"] > 50 and gTouchs[pTouchID]["OldChanged"] <> gTouchs[pTouchID]["Changed"] then
local tChanged = 0
if ((tAngle >= 0 and tAngle <= 40) or (tAngle >= 320 and tAngle <= 360) or (tAngle >= 140 and tAngle <= 220)) then
put  gTouchs[pTouchID]["ChangedInX"] into tChanged
if abs(tChanged) > 10 then
if tChanged > 1 then
send "PushLeft pTouchID, tChanged" to the long id of me  in 0
else
send "PushRight pTouchID, tChanged" to the long id of me in 0
end if
end if
else if (tAngle >= 50 and tAngle <= 130) or (tAngle >= 140 and tAngle <= 310) then
put gTouchs[pTouchID]["ChangedInY"] into tChanged
if abs(tChanged) > 10 then
if tChanged > 1 then
send "PushUp pTouchID, tChanged" to the long id of me in 0
else
send "PushDown pTouchID, tChanged" to the long id of me  in 0
end if
end if
end if
put gTouchs[pTouchID]["Changed"] into gTouchs[pTouchID]["OldChanged"]
end if
end if
end if
put  pTouchX, pTouchY into gTouchs[pTouchID]["PrevLoc"]
pass touchMove
end touchMove
on TouchStillDown pPinchId
end TouchStillDown
on TouchDoubleDown pPinchId
end TouchDoubleDown
on TouchDoubleUp pPinchId
end TouchDoubleUp
on PinchStart pPinchId
end PinchStart
on PinchMove pPinchId, pRadioOfTouches  , pType
end PinchMove
on PinchZoomingDown pPinchId, pRadioOfTouches
end PinchZoomingDown
on PinchZoomingUp pPinchId, pRadioOfTouches
end PinchZoomingUp
on PinchRotate pPinchId, pRotation
end PinchRotate
on PinchEnd pPinchId
end PinchEnd
on PushLeft pTouchID, pDistance
end PushLeft
on PushRight pTouchID, pDistance
end PushRight
on PushUp pTouchID, pDistance
end PushUp
on PushDown pTouchID, pDistance
end PushDown
on TouchVeryFast pTouchID, pDistance, pMoveAddress
end TouchVeryFast
on TouchFast pTouchID, pDistance, pMoveAddress
end TouchFast
on TouchSlow pTouchID, pDistance, pMoveAddress
end TouchSlow
on TouchVerySlow pTouchID, pDistance, pMoveAddress
end TouchVerySlow
private function _InfoOfPinch pTouchId
local tTouchList, tTouchNumberTwo
local tLocOneTouch, tLocTwoTouch
local tStartAngle, tEndAngle
local tStartDistance, tCurrentDistance, tPrevDistance
put the keys of gTouchs into tTouchList
if line 1 of tTouchList is pTouchId then
put line 2 of tTouchList into tTouchNumberTwo
else
put line 1 of tTouchList into tTouchNumberTwo
end if
put gTouchs[pTouchId]["StartLoc"] into tLocOneTouch
put gTouchs[tTouchNumberTwo]["StartLoc"] into tLocTwoTouch
put  _ResizeDistance(tLocOneTouch, tLocTwoTouch) into tStartDistance
put _TwoPointAngle(tLocOneTouch, tLocTwoTouch) into tStartAngle
put gTouchs[pTouchId]["CurrentLoc"] into tLocOneTouch
put gTouchs[tTouchNumberTwo]["CurrentLoc"] into tLocTwoTouch
put  _ResizeDistance(tLocOneTouch, tLocTwoTouch) into tCurrentDistance
put _TwoPointAngle(tLocOneTouch, tLocTwoTouch) into tEndAngle
put gTouchs[pTouchId]["PrevLoc"] into tLocOneTouch
put gTouchs[tTouchNumberTwo]["PrevLoc"] into tLocTwoTouch
put  _ResizeDistance(tLocOneTouch, tLocTwoTouch) into tPrevDistance
if tPrevDistance > tCurrentDistance then
put 0 into sAddressOfMovePinch
else if tPrevDistance < tCurrentDistance then
put 1 into sAddressOfMovePinch
end if
return round((tCurrentDistance/ tStartDistance)* 100), (tEndAngle - tStartAngle), sAddressOfMovePinch
end _InfoOfPinch
private function  _ResizeDistance pLoc1, pLoc2
local dx = 0, dy = 0, tDistance = 0
put item 2 of pLoc1 - item 2 of pLoc2 into dy
put item 1 of  pLoc1 - item 1 of pLoc2 into dx
put sqrt((dy^2) + (dx^2)) into tDistance
return tDistance
end  _ResizeDistance
private function _AngleTouch pTouchID
return _TwoPointAngle( gTouchs[pTouchID]["StartLoc"],gTouchs[pTouchID]["CurrentLoc"])
end _AngleTouch
private function _AddressTouch pLoc1, pLoc2
local Xo, X, Yo, Y, MovX, MovY
put item 1 of pLoc1 into Xo
put item 2 of pLoc1 into Yo
put item 1 of pLoc2 into X
put item 2 of pLoc2 into Y
if Xo < X then
put "Right" into MovX
else if Xo > X then
put "Left" into MovX
else
put empty into MovX
end if
if Yo < Y then
put "Bottom" into MovY
else if Yo > Y then
put "Top" into MovY
else
put empty into MovY
end if
return MovX & MovY
end _AddressTouch
private function _TwoPointAngle
local tX1, tY1, tX2, tY2, tAngle
put item 1 of Param(1) into tX1
put item 2 of Param(1) into tY1
put item 1 of Param(2) into tX2
put item 2 of Param(2) into tY2
put atan2(tY2 - tY1, tX2 - tX1) into tAngle
put trunc(tAngle*180/pi) into tAngle
return tAngle
end _TwoPointAngle
command _DispatchTouchDoubleDown pTouchID
   local tTouchID, tLoc, tMove, tTouchX, tTouchY
   put the mouseLoc into tLoc
   put _ResizeDistance(tLoc, sStatTouchStillDown) into tMove
   if sPendingTouchStillDown is a number then cancel sPendingTouchStillDown
   if tMove > 33 or the mouse is not down or the num of lines of keys of gTouchs > 1 or (pTouchID is not tTouchID and tTouchID is a number) then exit _DispatchTouchDoubleDown
   put item  1 of tLoc into tTouchX
   put item 2 of tLoc into tTouchY
   send "TouchStillDown pTouchID, tTouchX, tTouchY" to the long id of me
   send "_DispatchTouchDoubleDown pTouchID" to me in 0.1 sec
   put pTouchID into tTouchID
end _DispatchTouchDoubleDown
