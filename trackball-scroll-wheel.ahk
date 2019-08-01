/*
Emulate_Scrolling_Middle_Button.ahk
Author: Erik Elmore <erik@ironsavior.net>
Version: 1.1 (Aug 16, 2005)
Enables you to use any key with cursor movement
to emulate a scrolling middle button.  While
the TriggerKey is held down, you may move the
mouse cursor up and down to send scroll wheel
events.  If the cursor does not move by the
time the TriggerKey is released, then a middle
button click is generated.  I wrote this for my
4-button Logitech Marble Mouse (trackball),
which has no middle button or scroll wheel.

trackman-scroll-wheel.ahk
Author: Wayne Jensen
Version: 0.1
Added horizontal scroll

Added XButton2, added multi-monitor support. 
Also added cursor toggle feature but it's 
GNU GPLv2 licensed. Changed threshold to feel
more natural for logi trackman marble.
2019-07-25 by Coughingmouse
*/

;; Configuration

;#NoTrayIcon

;; Higher numbers mean less sensitivity
esmb_Threshold = 32

;; This key/Button activates scrolling
esmb_TriggerKey = XButton1

;; toggle 0/1 to hide cursor while it goes nuts
;; which is when esmb_TriggerKey is pressed
cursor_not_crazy = 1


;; End of configuration

#Persistent
CoordMode, Mouse, Screen
Hotkey, %esmb_TriggerKey%, esmb_TriggerKeyDown
HotKey, %esmb_TriggerKey% Up, esmb_TriggerKeyUp
esmb_KeyDown = n
SetTimer, esmb_CheckForScrollEventAndExecute, 10

OnExit, ShowCursor  ; Ensure the cursor is made visible when the script exits.
return


ShowCursor:
SystemCursor("On")
ExitApp

SystemCursor(OnOff = 1)   ; INIT = "I","Init"; OFF = 0,"Off"; TOGGLE = -1,"T","Toggle"; ON = others
{
    static AndMask, XorMask, $, h_cursor
        ,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13 ; system cursors
        , b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13   ; blank cursors
        , h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13   ; handles of default cursors
    if (OnOff = "Init" or OnOff = "I" or $ = "")       ; init when requested or at first call
    {
        $ := "h"                                       ; active default cursors
        VarSetCapacity( h_cursor,4444, 1 )
        VarSetCapacity( AndMask, 32*4, 0xFF )
        VarSetCapacity( XorMask, 32*4, 0 )
        system_cursors := "32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650"
        StringSplit c, system_cursors, `,
        Loop %c0%
        {
            h_cursor   := DllCall( "LoadCursor", "Ptr",0, "Ptr",c%A_Index% )
            h%A_Index% := DllCall( "CopyImage", "Ptr",h_cursor, "UInt",2, "Int",0, "Int",0, "UInt",0 )
            b%A_Index% := DllCall( "CreateCursor", "Ptr",0, "Int",0, "Int",0
                , "Int",32, "Int",32, "Ptr",&AndMask, "Ptr",&XorMask )
        }
    }
    if (OnOff = 0 or OnOff = "Off" or $ = "h" and (OnOff < 0 or OnOff = "Toggle" or OnOff = "T"))
        $ := "b"  ; use blank cursors
    else
        $ := "h"  ; use the saved cursors

    Loop %c0%
    {
        h_cursor := DllCall( "CopyImage", "Ptr",%$%%A_Index%, "UInt",2, "Int",0, "Int",0, "UInt",0 )
        DllCall( "SetSystemCursor", "Ptr",h_cursor, "UInt",c%A_Index% )
    }
}


esmb_TriggerKeyDown:
  esmb_Moved = n
  esmb_HMoved = n
  esmb_FirstIteration = y
  esmb_KeyDown = y
  MouseGetPos, esmb_OrigX, esmb_OrigY, esmb_HoverWnd, esmb_HoverCtl
  ;;ControlFocus, ahk_class %esmb_HoverCtl%, ahk_id %esmb_HoverWnd%
  esmb_AccumulatedDistance = 0
  esmb_HAccumulatedDistance = 0

  if (cursor_not_crazy = 1){
    SystemCursor("Toggle")
  }
return

esmb_TriggerKeyUp:
  esmb_KeyDown = n
  if (cursor_not_crazy = 1){
    SystemCursor("Toggle")
  }
  ;; Send a middle-click if we did not scroll
  if esmb_Moved = n
    MouseClick, Middle
return

esmb_CheckForScrollEventAndExecute:
  if esmb_KeyDown = n
    return

  MouseGetPos, esmb_NewX, esmb_NewY, id, fcontrol, 1
  esmb_Distance := esmb_NewY - esmb_OrigY
  if esmb_Distance
    esmb_Moved = y

  esmb_HDistance := esmb_NewX - esmb_OrigX
  if esmb_HDistance
    esmb_HMoved = y

  esmb_AccumulatedDistance := (esmb_AccumulatedDistance + esmb_Distance)
  esmb_HAccumulatedDistance := (esmb_HAccumulatedDistance + esmb_HDistance)
  esmb_Ticks := (esmb_AccumulatedDistance // esmb_Threshold) ; floor divide
  esmb_HTicks := (esmb_HAccumulatedDistance // esmb_Threshold) ; floor divide
  esmb_AccumulatedDistance := (esmb_AccumulatedDistance - (esmb_Ticks * esmb_Threshold))
  esmb_HAccumulatedDistance := (esmb_HAccumulatedDistance - (esmb_HTicks * esmb_Threshold))
  esmb_WheelDirection := "WheelUp"
  if (esmb_Ticks < 0) {
    esmb_WheelDirection := "WheelDown"
    esmb_Ticks := (-1 * esmb_Ticks)
  }

  esmb_HWheelDirection := "WheelLeft"
  if (esmb_HTicks < 0) {
    esmb_HWheelDirection := "WheelRight"
    esmb_HTicks := (-1 * esmb_HTicks)
  }

  ;; Do not send clicks on the first iteration
  if (esmb_FirstIteration = y) {
    esmb_FirstIteration = n
  } else {
    Loop % esmb_Ticks {
      MouseClick, %esmb_WheelDirection%
    }
    Loop % esmb_HTicks {
      MouseClick, %esmb_HWheelDirection%
    }
  }

  ;; For multi-monitor setup, instead of MouseGetPos
  DllCall("SetCursorPos", "int", esmb_OrigX, "int", esmb_OrigY)  ;

return

  ;; Added XButton2 for Blender 2019-07-25 by Coughingmouse
  XButton2:: MButton ; I'm sorry, I don't know how to code

