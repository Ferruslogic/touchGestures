script "com.ferruslogic.library.touchGestures"
/*
This library is in the public domain.
There are no restrictions whatsoever.

Original Author - Ferruslogic Ltd.

*/

on extensionInitialize
   if the target is not me then
      pass extensionInitialize
   end if
   
   insert the script of me into front
   
   if the environment contains "development" then
      set the _ideoverride of me to true
   end if
end extensionInitialize

on extensionFinalize
   if the target is not me then
      pass extensionFinalize
   end if

   remove the script of me from front
end extensionFinalize


global gTouchs
local sChangerPinch, sAddressOfMovePinch, sDoubleTouchIDs, sAngleOfPinch
local sIsPinch = 0, sPinchId = 0
constant kDoubleClickInterval = 250
local sTouchDoubleDown, sLastTouchDown
local sTouchDoubleUp, sLastTouchUp
local tNumTouchs
local sPendingTouchStillDown, sStatTouchStillDown
constant kTouchStillDownTimeSec = 1

/**
Title: Mobile Gestures

Version: 1.0.0

Author: FerrusLogic

Description:
This mini library is for some of the most common gestures we have on mobile devices.

Tags:
gestures

*/

/**
Sent periodically while the touch is being held down.

Example:
on TouchStillDown pTouchId
   if pTouchId is a number then
      # Script
   end if
end TouchStillDown

Description:
You can handle the touchStillDown message to perform an action when the user holds the touch long time in screen.

The touchStillDown message is sent to the control that was originally clicked, or to the card if no control was under the touch.

Parameters:
pTouchId: A number which uniquely identifies an individual physical touch action from
a sequence of touch messages.

Syntax: TouchStillDown pTouchId

Type: message

Platforms: mobile
*/
on TouchStillDown pTouchId
   put the target
end TouchStillDown

/**
Sent when the user double-touch.

Example:
on TouchDoubleDown pTouchId
   if pTouchId is a number then
      # Script
   end if
end TouchDoubleDown

Description:
Handle The TouchDoubleDown message to perform an action when the user double-touch in mobile. 

The TouchDoubleDown message is sent to the control that was double-touchs, or to the card if no control was under the touch point.

Note: This message is not sent if the user touches multiple screen points.

Parameters:
pTouchId: A number which uniquely identifies an individual physical touch action from
a sequence of touch messages.

Syntax: TouchDoubleDown pTouchId

Type: message
*/
on TouchDoubleDown pTouchId

end TouchDoubleDown


/**
Sent when the user double-touch.

Example:
on TouchDoubleUp pTouchId
   if pTouchId is a number then
      # Script
   end if
end TouchDoubleUp

Description:
Handle the TouchDoubleUp message to perform an action when the user double-touchs in mobile.

The TouchDoubleUp message is sent to the control that was double-touchs, or to the card if no control was under the touch point.

Note: This message is not sent if the user touches multiple screen points.

Parameters:
pTouchId: A number which uniquely identifies an individual physical touch action from
a sequence of touch messages.

Syntax: TouchDoubleUp pTouchId

Type: message
*/
on TouchDoubleUp pTouchId
   
end TouchDoubleUp

/**
Sent when a user pinches a control in a mobile application

Example:
on PinchStart pPinchId
   if pPinchId is a number then
      # Script
   end if
end PinchStart

Description:
Handle the PinchStart message to perform an action when the user touches the screen, starting the pinch.

The PinchStart message is sent to the control that was touched, or to the card if no control was under the pinch point.

The pPinchId parameter is a number which uniquely identifies a sequence of pinch messages corresponding to an individual, physical touch action. All such sequences start with a PinchStart message, have one or more PinchMove messages and finish with either a PinchEnd message.

No two pinch will have the same pPinchID, and it is possible to have multiple (interleaving) such sequences occurring at once. This allows handling of more than one physical pinch at once.

Parameters:
pTouchId: A number which uniquely identifies an individual physical pinch action from
a sequence of pinch messages.

Syntax: PinchStart pTouchId

Type: message
*/
on PinchStart pPinchId
   /**  pPinchId. Pinch Id. **/
end PinchStart

/**
Sent when a user pinches a control in a mobile application

Example:
on PinchMove pPinchId, pRadioOfTouches, pType
   if pPinchId is a number then
      # Script
   end if
end PinchMove

Description:
Handle the pinchMove message if you want to perform some action when the user changes the pinch position without ending the pinch or if you want to keep continuous track of the pinch position.

The pinchMove message is sent to the control which received the pinchStart message.

The pPinchID parameter is a number which uniquely identifies a sequence of pinch messages corresponding to an individual, physical pinch action. All such sequences start with a touchStart message, have one or more pinchMove messages and finish with either a pinchEnd.

Parameters:
pPinchId: A number which uniquely identifies an individual physical pinch action from
a sequence of pinch messages.

pRadio: Radius between two of the touches. The one who moves and any other.

pType: Type of pinch. Up (1), down (0) or simply by moving your fingers the same distance (null).

Syntax: PinchMove pPinchId, pRadio, pType

Type: message
*/
on PinchMove pPinchId, pRadio, pType
   /**  pPinchId. Pinch Id. **/
   /**  pRadioOfTouches. Radius between two of the touches. The one who moves and any other. **/
   /**  pType. Type of pinch. Up (1), down (0) or simply by moving your fingers the same distance (null). **/
end PinchMove


/**
Sent when a user pinches a control in a mobile application

Example:
on PinchZoomingDown pPinchId, pRadioOfTouches, pType
   if pPinchId is a number then
      # Script
   end if
end PinchZoomingDown

Description:
Handle the PinchZoomingDown message if you want to take any action when the user pinches to decrease on the screen.

The PinchZoomingDown message is sent to the control which received the pinchStart message.

The pPinchID parameter is a number which uniquely identifies a sequence of pinch messages corresponding to an individual, physical pinch action. All such sequences start with a touchStart message, have one or more pinchMove messages and finish with either a pinchEnd.

Parameters:
pPinchId: A number which uniquely identifies an individual physical pinch action from
a sequence of pinch messages.

pRadio: Radius between two of the touches. The one who moves and any other.

Syntax: PinchZoomingDown pPinchId, pRadio

Type: message
*/
on PinchZoomingDown pPinchId, pRadio
   
end PinchZoomingDown

/**
Sent when a user pinches a control in a mobile application

Example:
on PinchZoomingUp pPinchId, pRadioOfTouches, pType
   if pPinchId is a number then
      # Script
   end if
end PinchZoomingUp

Description:
Handle the PinchZoomingUp message if you want to take any action when the user pinches to zoom on the screen.

The PinchZoomingUp message is sent to the control which received the pinchStart message.

The pPinchID parameter is a number which uniquely identifies a sequence of pinch messages corresponding to an individual, physical pinch action. All such sequences start with a touchStart message, have one or more pinchMove messages and finish with either a pinchEnd.

Parameters:
pPinchId: A number which uniquely identifies an individual physical pinch action from
a sequence of pinch messages.

pRadio: Radius between two of the touches. The one who moves and any other.

Syntax: PinchZoomingUp pPinchId, pRadio

Type: message
*/
on PinchZoomingUp pPinchId, pRadio
   
end PinchZoomingUp


/**
Sent when a user pinches a control in a mobile application

Example:
on PinchRotate pPinchId, pRadioOfTouches, pType
   if pPinchId is a number then
      # Script
   end if
end PinchRotate

Description:
Handle the PinchRotate message if you want to take any action when the user pinches to rotate on the screen.

The PinchRotate message is sent to the control which received the pinchStart message.

The pPinchID parameter is a number which uniquely identifies a sequence of pinch messages corresponding to an individual, physical pinch action. All such sequences start with a touchStart message, have one or more pinchMove messages and finish with either a pinchEnd.

Parameters:
pPinchId: A number which uniquely identifies an individual physical pinch action from
a sequence of pinch messages.

pRotation: It is what has rotated the touches on the screen..

Syntax: PinchRotate pPinchId, pRotation

Type: message
*/
on PinchRotate pPinchId, pRotation
   
end PinchRotate

/**
Sent when a user pinches a control in a mobile application

Example:
on PinchEnd pPinchId
   if pPinchId is a number then
      # Script
   end if
end PinchEnd

Description:
Handle the pinchEnd message to perform an action when the user finishes a pinch sequence.

The pinchEnd message is sent to the control that received the pinchStart message that started the touch sequence.

The pPinchId parameter is a number which uniquely identifies a sequence of pinch messages corresponding to an individual, physical touch action. All such sequences start with a PinchStart message, have one or more PinchMove messages and finish with either a PinchEnd message.

Parameters:
pTouchId: A number which uniquely identifies an individual physical pinch action from
a sequence of pinch messages.


Syntax: PinchEnd pPinchId

Type: message
*/
on PinchEnd pPinchId
   
end PinchEnd

/** 
It is sent when the point at which the user touches the screen changes in a certain time interval.

Example:
on TouchVeryFast pTouchID, pDistance, pMoveAddress
   put "very fast touch. touch address is " &  pMoveAddress & " with a distance of " & pDistance & "px" into field 1
end TouchVeryFast

Description:
Handle the TouchVeryFast  message to perform an action when the user touch very fastan object.

The TouchVeryFast  message is sent to the control that received the touchStart message that initiated the touch sequence.

The pPinchId parameter is a number that uniquely identifies a sequence of touch messages corresponding to an individual physical touch action. All these sequences begin with a touchStart message, have one or more touchMove messages and end with a touchEnd message.

Parameters:
pTouchID: a number that uniquely identifies an individual physical touch action of a sequence of touch messages.

pDistance: the distance traveled by touch.

pMoveAddress: Direction in which the touch moves for the last time

Syntax: TouchVeryFast  pTouchID, pDistance, pMoveAddress

Type: message
*/
on TouchVeryFast pTouchID, pDistance, pMoveAddress
   
end TouchVeryFast

/** 
It is sent when the point at which the user touches the screen changes in a certain time interval.

Example:
on TouchFast pTouchID, pDistance, pMoveAddress
   put "fast touch. touch address is " &  pMoveAddress & " with a distance of " & pDistance & "px" into field 1
end TouchFast

Description:
Handle the TouchFast  message to perform an action when the user touch fastan object.

The TouchFast  message is sent to the control that received the touchStart message that initiated the touch sequence.

The pPinchId parameter is a number that uniquely identifies a sequence of touch messages corresponding to an individual physical touch action. All these sequences begin with a touchStart message, have one or more touchMove messages and end with a touchEnd message.

Parameters:
pTouchID: a number that uniquely identifies an individual physical touch action of a sequence of touch messages.

pDistance: the distance traveled by touch.

pMoveAddress: Direction in which the touch moves for the last time

Syntax: TouchFast  pTouchID, pDistance, pMoveAddress

Type: message
*/
on TouchFast pTouchID, pDistance, pMoveAddress
   
end TouchFast

/** 
It is sent when the point at which the user touches the screen changes in a certain time interval.

Example:
on TouchFast pTouchID, pDistance, pMoveAddress
   put "fast touch. touch address is " &  pMoveAddress & " with a distance of " & pDistance & "px" into field 1
end TouchFast

Description:
Handle the TouchFast  message to perform an action when the user touch slow object.

The TouchFast  message is sent to the control that received the touchStart message that initiated the touch sequence.

The pPinchId parameter is a number that uniquely identifies a sequence of touch messages corresponding to an individual physical touch action. All these sequences begin with a touchStart message, have one or more touchMove messages and end with a touchEnd message.

Parameters:
pTouchID: a number that uniquely identifies an individual physical touch action of a sequence of touch messages.

pDistance: the distance traveled by touch.

pMoveAddress: Direction in which the touch moves for the last time

Syntax: TouchFast  pTouchID, pDistance, pMoveAddress

Type: message
*/
on TouchSlow pTouchID, pDistance, pMoveAddress
   
end TouchSlow


/** 
It is sent when the point at which the user touches the screen changes in a certain time interval.

Example:
on TouchVerySlow pTouchID, pDistance, pMoveAddress
   put "fast touch. touch address is " &  pMoveAddress & " with a distance of " & pDistance & "px" into field 1
end TouchVerySlow

Description:
Handle the TouchVerySlow  message to perform an action when the user touch very slow object.

The TouchVerySlow  message is sent to the control that received the touchStart message that initiated the touch sequence.

The pPinchId parameter is a number that uniquely identifies a sequence of touch messages corresponding to an individual physical touch action. All these sequences begin with a touchStart message, have one or more touchMove messages and end with a touchEnd message.

Parameters:
pTouchID: a number that uniquely identifies an individual physical touch action of a sequence of touch messages.

pDistance: the distance traveled by touch.

pMoveAddress: Direction in which the touch moves for the last time

Syntax: TouchVerySlow  pTouchID, pDistance, pMoveAddress

Type: message
*/
on TouchVerySlow pTouchID, pDistance, pMoveAddress
   
end TouchVerySlow

/////////////////////////////////////////////////////////////
//////****************** The magic ********************//////
/////////////////////////////////////////////////////////////

local sLongId
on touchStart pTouchID
   local tLoc, tLocX, tLocY
   put the mouseLoc into tLoc
   put the millisec into gTouchs[pTouchID]["StartTime"]
   
   put the long id of target into sLongId[pTouchID]
   
   if the num of lines of keys of gTouchs is 1 then
      /** TouchDoubleDown **/
      add 1 to sTouchDoubleDown
      if sTouchDoubleDown is 1 then
         put gTouchs[pTouchID]["StartTime"] into sLastTouchDown["StartTime"]
      else if (gTouchs[pTouchID]["StartTime"] - sLastTouchDown["StartTime"]) <= kDoubleClickInterval then
         put 0 into sTouchDoubleDown
         put item  1 of tLoc into tLocX
         put  item 2 of tLoc into tLocY
         if there is sLongId[pTouchID] and "TouchDoubleDown" is not among the lines of the pendingMessages then
            dispatch "TouchDoubleDown" to sLongId[pTouchID] with  pTouchID, tLocX, tLocY
         end if
         pass touchStart
      else
         put gTouchs[pTouchID]["StartTime"] into sLastTouchDown["StartTime"]
      end if
      if sPendingTouchStillDown is a number then cancel sPendingTouchStillDown
      put tLoc into sStatTouchStillDown
      send "_DispatchTouchDoubleDown pTouchID" to the long id of me in kTouchStillDownTimeSec sec
      put the result into sPendingTouchStillDown
   end if
   pass touchStart
end touchStart

on touchMove pTouchID, pTouchX, pTouchY
   if the mouse is not down then pass touchMove
   /** Saving touch position **/
   if gTouchs[pTouchID]["StartLoc"] is empty then
      put pTouchX, pTouchY into gTouchs[pTouchID]["StartLoc"]
   else
      put pTouchX, pTouchY into gTouchs[pTouchID]["CurrentLoc"]
      /** Changer in X **/
      put item 1 of gTouchs[pTouchID]["StartLoc"] - pTouchX into gTouchs[pTouchID]["ChangedInX"]
      /** Changer in Y **/
      put item 2 of gTouchs[pTouchID]["StartLoc"]  - pTouchY into gTouchs[pTouchID]["ChangedInY"]
      /** Distance **/
      put round(sqrt((gTouchs[pTouchID]["ChangedInX"]^2) + (gTouchs[pTouchID]["ChangedInY"]^2))) into gTouchs[pTouchID]["Changed"]
      /** Angles and Rotation **/
      put _AngleTouch(pTouchID) into gTouchs[pTouchID]["Angle"]
      /** For the address **/
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
   
   /** If I have not moved the touch I do nothing **/
   if gTouchs[pTouchID]["CurrentLoc"] is a point then
      
      /** To know if it is a multitouch **/
      if the num of lines of keys of gTouchs >= 2 then
         
         /** PINCHSTART  **/
         if sIsPinch is 0 then
            put 1 into sIsPinch
            add 1 to sPinchId
            put the long id of target into sLongId[sPinchId]
            dispatch "PinchStart" to sLongId[sPinchId] with sPinchId
         end if
         
         local tInfoOfPinch, tChangerPinch
         put _InfoOfPinch(pTouchID) into tInfoOfPinch
         put item 1 of tInfoOfPinch into tChangerPinch
         
         if sChangerPinch is not tChangerPinch then
            if there is sLongId[sPinchId] then
               dispatch "PinchMove" to sLongId[sPinchId] with sPinchId, tChangerPinch
            end if
            /** PINCHS ZOOMING **/
            local tPrevAngle, tDoNotTurnFingers = true
            if tPrevAngle is not a number then
               put the item 2 of tInfoOfPinch into tPrevAngle
            else
               put the item 2 of tInfoOfPinch is tPrevAngle into tDoNotTurnFingers
            end if
            /** Messages generated when the screen is "pinched" **/
            if item 3 of tInfoOfPinch is 0 and tDoNotTurnFingers then
               if there is sLongId[sPinchId] then
                  dispatch "PinchZoomingDown" to sLongId[sPinchId] with sPinchId, tChangerPinch
               end if
            end if
            if item 3 of tInfoOfPinch is 1 and tDoNotTurnFingers then
               if there is sLongId[sPinchId] then
                  dispatch "PinchZoomingUp" to sLongId[sPinchId] with sPinchId, tChangerPinch
               end if
            end if
            
            put the item 2 of tInfoOfPinch into tPrevAngle
         end if
         
         put item 1 of tInfoOfPinch  into sChangerPinch
         
         /** ROTATE **/
         local tAngleOfPinch = 0
         put item 2 of tInfoOfPinch into tAngleOfPinch
         if abs(tAngleOfPinch) > 5 and sAngleOfPinch <> tAngleOfPinch then
            if there is sLongId[sPinchId] then
               dispatch "PinchRotate" to sLongId[sPinchId] with sPinchId, tAngleOfPinch
            end if
         end if
         put tAngleOfPinch into sAngleOfPinch
      else
         
         local tAngle = 0
         put gTouchs[pTouchID]["Angle"] into tAngle
         
         if gTouchs[pTouchID]["Changed"] > 50 and gTouchs[pTouchID]["OldChanged"] <> gTouchs[pTouchID]["Changed"] then           
            put tAngle into fld 2
            
            
            /** PUSH LEFT AND RIGHT **/
            if ((tAngle >= 0 and tAngle <= 40) or (tAngle >= 320 and tAngle <= 360) or (tAngle >= 140 and tAngle <= 220)) then
               put  gTouchs[pTouchID]["ChangedInX"] into tChanged
               if abs(tChanged) > 10 then
                  if tChanged > 1 then
                     send "PushLeft pTouchID, tChanged" to the long id of me  in 0
                  else
                     send "PushRight pTouchID, tChanged" to the long id of me in 0
                  end if
               end if
               
               /** PUSH UP AND DOWN **/
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
            /** Save changes to not send messages for pleasure **/
            put gTouchs[pTouchID]["Changed"] into gTouchs[pTouchID]["OldChanged"]
         end if
      end if
   end if
   
   /** To know where I come from **/
   put pTouchX, pTouchY into gTouchs[pTouchID]["PrevLoc"]
   pass touchMove
end touchMove


on touchEnd pTouchID
   local tTime = 0, tTouchFast, tMillisec, tLoc, tChanger, tAddressOfTouch, tTouchX, tTouchY
   
   put the millisec into tMillisec
   put the num of lines of keys of gTouchs into tNumTouchs
   put tMillisec - gTouchs[pTouchID]["StartTime"] into gTouchs[pTouchId]["CurrentTime"]
   put round(gTouchs[pTouchId]["CurrentTime"]) into tTime
   
   if gTouchs[pTouchID]["AddressOfTouch"] is empty then
      put "none" into gTouchs[pTouchID]["AddressOfTouch"]
   end if
   
   if gTouchs[pTouchID]["Changed"] is empty then
      put 0 into  gTouchs[pTouchID]["Changed"]
   end if
   
   put gTouchs[pTouchID]["Changed"] into tChanger
   put gTouchs[pTouchID]["AddressOfTouch"] into tAddressOfTouch
   
   switch
      case tTime <= 50
         if there is sLongId[pTouchID] then
            dispatch "TouchVeryFast" to sLongId[pTouchID] with pTouchID, tChanger, tAddressOfTouch
         end if
         put the result into tTouchFast
         break
      case tTime <= 250
         if there is sLongId[pTouchID] then
            dispatch "TouchFast" to sLongId[pTouchID] with pTouchID, tChanger, tAddressOfTouch
         end if
         put the result into tTouchFast
         break
      default
         if tTime > 250 and tTime < 700 then
            if there is sLongId[pTouchID] then
               dispatch "TouchSlow" to sLongId[pTouchID] with pTouchID, tChanger, tAddressOfTouch
            end if
            put the result into tTouchFast
         else
            if there is sLongId[pTouchID] then
               dispatch "TouchVerySlow" to sLongId[pTouchID] with pTouchID, tChanger, tAddressOfTouch
            end if
            put the result into tTouchFast
         end if
   end switch
   
   local tLongId
   put sLongId[pTouchID] into tLongId
   /** remove the touch just ended in the array **/
   delete global gTouchs[pTouchId]
   delete local sLongId[pTouchID]
   
   
   /** remove the touch just ended from the double touch list **/
   filter sDoubleTouchIDs without pTouchID
   
   if tNumTouchs <= 2 then
      /** PINCHEND **/
      if sIsPinch is 1 then
         put 0 into sIsPinch
         if there is sLongId[sPinchId] then
            dispatch "PinchEnd" to sLongId[sPinchId] with sPinchId
         end if
      else
         /** TOUCHDOUBLEUP **/
         add 1 to sTouchDoubleUp
         if sTouchDoubleUp is 1 then
            put tMillisec into sLastTouchUp["StartTime"]
         else if (tMillisec - sLastTouchUp["StartTime"]) <= kDoubleClickInterval then
            put 0 into sTouchDoubleUp
            put the mouseLoc into tLoc
            put item  1 of tLoc into tTouchX
            put item 2 of tLoc into tTouchY
            if there is tLongId then
               dispatch "TouchDoubleUp" to tLongId with pTouchID, tTouchX, tTouchY
            end if
         else
            put tMillisec into sLastTouchUp["StartTime"]
         end if
      end if
   end if
   
   if tNumTouchs is 0 then delete global gTouchs
   pass touchEnd
end touchEnd

on touchRelease pID
   send "touchEnd pID" to me
   pass touchRelease
end touchRelease

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
   //put _TwoPointAngle(tLocOneTouch, tLocTwoTouch) into tStartAngle
   put _AngleTouch(pTouchId) into tStartAngle
   /** Current distance between the two touches. **/
   put gTouchs[pTouchId]["CurrentLoc"] into tLocOneTouch
   put gTouchs[tTouchNumberTwo]["CurrentLoc"] into tLocTwoTouch
   put  _ResizeDistance(tLocOneTouch, tLocTwoTouch) into tCurrentDistance
   put _TwoPointAngle(tLocOneTouch, tLocTwoTouch) into tEndAngle
   
   /** Distance of the points before this movement. **/
   put gTouchs[pTouchId]["PrevLoc"] into tLocOneTouch
   put gTouchs[tTouchNumberTwo]["PrevLoc"] into tLocTwoTouch
   put  _ResizeDistance(tLocOneTouch, tLocTwoTouch) into tPrevDistance
   
   /** To know if it's a pinch up or down. **/
   if tPrevDistance > tCurrentDistance then
      put 0 into sAddressOfMovePinch
   else if tPrevDistance < tCurrentDistance then
      put 1 into sAddressOfMovePinch
   end if
   /** Radius, angle, pinch direction **/
   return round((tCurrentDistance/ tStartDistance)* 100), (tEndAngle - tStartAngle), sAddressOfMovePinch
end _InfoOfPinch

/** Distance between two points **/
private function  _ResizeDistance pLoc1, pLoc2
   local dx = 0, dy = 0, tDistance = 0
   put item 2 of pLoc1 - item 2 of pLoc2 into dy
   put item 1 of  pLoc1 - item 1 of pLoc2 into dx
   put sqrt((dy^2) + (dx^2)) into tDistance
   return tDistance
end  _ResizeDistance

/** Angle formed between current and the center of the screen **/
private function _AngleTouch pTouchID
   local tScreenCenter, tX, tY, tAngle, pX, pY
   
   put item 1 of the loc of me into pX
   put item 2 of the loc of me  into pY
   
   
   // The center of the screen
   put the loc of this cd into tScreenCenter
   put the item 1 of tScreenCenter into tX
   put the item 2 of tScreenCenter into tY
   
   if tScreenCenter is (pX,pY) then
      return 0
   end if
   
   put abs(tX- pX) into oppositeLeg
   put abs(tY- pY) into adjacentLeg
   if adjacentLeg <> 0 then
      // Calculate the angle
      put atan(oppositeleg/adjacentLeg) into alpha 
      // Convert to grade
      put (alpha * 180)/pi into alpha
   else 
      put 90 into alpha
   end if
   -- at this point, the angle will be between -180 and 180 degrees
   
   switch
      case tX <= pX and tY >= pY
         put alpha into foundAngle
         break
      case tX <= pX and tY <= pY
         put 180 - alpha into foundAngle
         break
      case tX >= pX and tY <= pY
         put 180 + alpha into foundAngle
         break
      case tX >= pX and tY >= pY
         put 360 - alpha into foundAngle
         break
   end switch
   
   return abs(round(foundAngle,2))
end _AngleTouch

/** Touch address **/
private function _AddressTouch pLoc1, pLoc2
   local Xo, X, Yo, Y, MovX, MovY
   
   put the loc of this cd into pLoc1
   
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

/** Angle between two points **/
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
   
   /** TouchStillDown **/
   put item 1 of tLoc into tTouchX
   put item 2 of tLoc into tTouchY
   dispatch "TouchStillDown" to sLongId[pTouchID] //with pTouchID, tTouchX, tTouchY
   send "_DispatchTouchDoubleDown pTouchID" to me in 0.1 sec
   put pTouchID into tTouchID
end _DispatchTouchDoubleDown

