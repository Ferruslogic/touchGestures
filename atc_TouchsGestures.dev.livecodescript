script "TouchsGestures"
/*

* Author: Andrés del Toro Cruz
* Email: torocruzand@gmail.com
* License: MIT
* Creation [Frcha: 7/14/19 || 10:21 PM]
* Rafael Freire - Holguin - CUBA

* This mini Library is for the behavior of some of the most common gestures
* that we have on mobile devices.

* LiveCode allows us to capture certain gestures specific to mobiles.
* As are the touchStart, touchEnd, touchRelease and touchMove ...

* Now we can capture others.
* When a pinch is performed on the screen (PinchMove, PinchZoomingUp, PinchZoomingDown and PinchRotate).
* To the user to release a touch we will have information of the duration of the touch,
* distance traveled and the last direction in which the user moved. In the me the
* messages (TouchVeryFast, TouchFast, TouchSlow, TouchVerySlow).
* When one finger is pushed or slid from side to side, one of the
* following messages (PushDown, PushLeft, PushUp, PushRight)

* Note_
* If you use one of the gestures (touchStart, touchEnd, touchRelease or touchMove) you must give it a pass so that
* the other gestures that are here work correctly.
*/

# MultiTouchs
global gTouchs
local sChangerPinch, sAddressOfMovePinch, sDoubleTouchIDs, sAngleOfPinch
local sIsPinch = 0, sPinchId = 0

# TouchDouble
constant kDoubleClickInterval = 250
local sTouchDoubleDown, sLastTouchDown
local sTouchDoubleUp, sLastTouchUp
local tNumTouchs

# Long touch
local sPendingTouchStillDown, sStatTouchStillDown
constant kTouchStillDownTimeSec = 1

on touchStart pTouchID
local tLoc
put the mouseLoc into tLoc
put the millisec into gTouchs[pTouchID]["StartTime"]

if the num of lines of keys of gTouchs is 1 then
# TouchDoubleDown
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

# remove the touch just ended in the array
delete global gTouchs[pTouchId]

# remove the touch just ended from the double touch list
filter sDoubleTouchIDs without pTouchID

if tNumTouchs < 2 then
# PINCHEND
if sIsPinch is 1  then
put 0 into sIsPinch
send "PinchEnd  sPinchId" to the long id of me in 0
else
# TOUCHDOUBLEUP
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

# Saving touch position
if gTouchs[pTouchID]["StartLoc"] is empty then
put pTouchX, pTouchY into gTouchs[pTouchID]["StartLoc"]
else
put pTouchX, pTouchY into gTouchs[pTouchID]["CurrentLoc"]
# Changer in X
put item 1 of gTouchs[pTouchID]["StartLoc"] - pTouchX into gTouchs[pTouchID]["ChangedInX"]
# Changer in Y
put item 2 of gTouchs[pTouchID]["StartLoc"]  - pTouchY into gTouchs[pTouchID]["ChangedInY"]
# Distance
put round(sqrt((gTouchs[pTouchID]["ChangedInX"]^2) + (gTouchs[pTouchID]["ChangedInY"]^2))) into gTouchs[pTouchID]["Changed"]

# Angles and Rotation
put _AngleTouch(pTouchID) into gTouchs[pTouchID]["Angle"]

# For the address
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

# If I have not moved the touch I do nothing
if gTouchs[pTouchID]["CurrentLoc"] is a point then

# To know if it is a multitouch
if the num of lines of keys of gTouchs >= 2 then

# PINCHSTART
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
# PINCHS ZOOMING

# Messages generated when the screen is "pinched"
if item 3 of tInfoOfPinch is 0 then send "PinchZoomingDown sPinchId, tChangerPinch" to the long id of me in 0
if item 3 of tInfoOfPinch is 1 then send "PinchZoomingUp sPinchId, tChangerPinch" to the long id of me in 0

end if

put item 1 of tInfoOfPinch  into sChangerPinch

# ROTATE
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

# PUSH LEFT AND RIGHT
if ((tAngle >= 0 and tAngle <= 40) or (tAngle >= 320 and tAngle <= 360) or (tAngle >= 140 and tAngle <= 220)) then
put  gTouchs[pTouchID]["ChangedInX"] into tChanged
if abs(tChanged) > 10 then
if tChanged > 1 then
send "PushLeft pTouchID, tChanged" to the long id of me  in 0
else
send "PushRight pTouchID, tChanged" to the long id of me in 0
end if
end if

# PUSH UP AND DOWN
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
# Save changes to not send messages for pleasure
put gTouchs[pTouchID]["Changed"] into gTouchs[pTouchID]["OldChanged"]
end if
end if
end if

# To know where I come from
put  pTouchX, pTouchY into gTouchs[pTouchID]["PrevLoc"]
pass touchMove
end touchMove

--------------------------------------------------------------------------
------------------ MESSAGES GENERATED FOR EVERY GESTURE ---------------------
--------------------------------------------------------------------------
# Long touch *
on TouchStillDown pPinchId
# pPinchId. Pinch Id.
end TouchStillDown

# Double tap pressed
on TouchDoubleDown pPinchId
# pPinchId. Pinch Id.
end TouchDoubleDown

# Double tap released
on TouchDoubleUp pPinchId
# pPinchId. Pinch Id.
end TouchDoubleUp

# Start a pinch
on PinchStart pPinchId
# pPinchId. Pinch Id.
end PinchStart

# Pinch on the screen
on PinchMove pPinchId, pRadioOfTouches  , pType
# pPinchId. Pinch Id.
# pRadioOfTouches. Radius between two of the touches. The one who moves and any other.
# pType. Type of pinch. Up (1), down (0) or simply by moving your fingers the same distance (null).
end PinchMove

# Pinch down
on PinchZoomingDown pPinchId, pRadioOfTouches
# pPinchId. Pinch Id.
# pRadioOfTouches. Radius between two of the touches. The one who moves and any other.
end PinchZoomingDown

# Pinch down
on PinchZoomingUp pPinchId, pRadioOfTouches
# pPinchId. Pinch Id.
# pRadioOfTouches. Radius between two of the touches. The one who moves and any other.
end PinchZoomingUp

# Pinch rotate
on PinchRotate pPinchId, pRotation
# pPinchId. Pinch Id.
# pRotation. It is what has turned the touches on the screen.
end PinchRotate

# End of the pinch
on PinchEnd pPinchId
# pPinchId. Pinch Id.
end PinchEnd

# Push to the left
on PushLeft pTouchID, pDistance
# pTouchID. The id of the touch.
# pDistance. The distance traveled by the touch.
end PushLeft

# Push to the right
on PushRight pTouchID, pDistance
# pTouchID. The id of the touch.
# pDistance. The distance traveled by the touch.
end PushRight

# Push up
on PushUp pTouchID, pDistance
# pTouchID. The id of the touch.
# pDistance. The distance traveled by the touch.
end PushUp

# Push down
on PushDown pTouchID, pDistance
# pTouchID. The id of the touch.
# pDistance. The distance traveled by the touch.
end PushDown

# Touch very fast
on TouchVeryFast pTouchID, pDistance, pMoveAddress
# pTouchID. The id of the touch
# pDistance. The distance traveled by the touch
# pMoveAddress. Direction in which the touch moves for the last time
end TouchVeryFast

# quick tap
on TouchFast pTouchID, pDistance, pMoveAddress
# pTouchID. The id of the touch
# pDistance. The distance traveled by the touch
# pMoveAddress. Direction in which the touch moves for the last time
end TouchFast

# Slow touch
on TouchSlow pTouchID, pDistance, pMoveAddress
# pTouchID. The id of the touch
# pDistance. The distance traveled by the touch
# pMoveAddress. Direction in which the touch moves for the last time
end TouchSlow

# Touch too slow
on TouchVerySlow pTouchID, pDistance, pMoveAddress
# pTouchID. The id of the touch
# pDistance. The distance traveled by the touch
# pMoveAddress. Direction in which the touch moves for the last time
end TouchVerySlow

---------------------------------------------------------------------
--------------- Private functions and commands ----------------------
---------------------------------------------------------------------

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

# Current distance between the two touches.
put gTouchs[pTouchId]["CurrentLoc"] into tLocOneTouch
put gTouchs[tTouchNumberTwo]["CurrentLoc"] into tLocTwoTouch
put  _ResizeDistance(tLocOneTouch, tLocTwoTouch) into tCurrentDistance
put _TwoPointAngle(tLocOneTouch, tLocTwoTouch) into tEndAngle

# Distance of the points before this movement.
put gTouchs[pTouchId]["PrevLoc"] into tLocOneTouch
put gTouchs[tTouchNumberTwo]["PrevLoc"] into tLocTwoTouch
put  _ResizeDistance(tLocOneTouch, tLocTwoTouch) into tPrevDistance

# To know if it's a pinch up or down.
if tPrevDistance > tCurrentDistance then
put 0 into sAddressOfMovePinch
else if tPrevDistance < tCurrentDistance then
put 1 into sAddressOfMovePinch
end if

# Radius, angle, pinch direction
return round((tCurrentDistance/ tStartDistance)* 100), (tEndAngle - tStartAngle), sAddressOfMovePinch
end _InfoOfPinch

# Distance between two points
private function  _ResizeDistance pLoc1, pLoc2
local dx = 0, dy = 0, tDistance = 0
put item 2 of pLoc1 - item 2 of pLoc2 into dy
put item 1 of  pLoc1 - item 1 of pLoc2 into dx
put sqrt((dy^2) + (dx^2)) into tDistance
return tDistance
end  _ResizeDistance

# Angle formed between current and initial position
private function _AngleTouch pTouchID
return _TwoPointAngle( gTouchs[pTouchID]["StartLoc"],gTouchs[pTouchID]["CurrentLoc"])
end _AngleTouch

# Touch address
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

# Angle between two points
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

# TouchStillDown
put item  1 of tLoc into tTouchX
put item 2 of tLoc into tTouchY
send "TouchStillDown pTouchID, tTouchX, tTouchY" to the long id of me
send "_DispatchTouchDoubleDown pTouchID" to me in 0.1 sec
put pTouchID into tTouchID
end _DispatchTouchDoubleDown
