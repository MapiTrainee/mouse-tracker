#cs ----------------------------------------------------------------------------
 Author:         MapiTrainee
 Script Function:
 - simulates move the mouse pointer, click or double-click the left button.
#ce ----------------------------------------------------------------------------

 #include <File.au3>
 #include <Array.au3>

;<---USED HOTKEYS--->
HotKeySet("{q}","Quit")
HotKeySet("{w}","WriteCurrentCoords")
HotKeySet("{r}","RunMouse")
HotKeySet("{e}","EmptyCoords")
HotKeySet("{t}","PrintTrack")
;<!--USED HOTKEYS--!>

While True
   ToolTip ("Current coordinates: ["& MouseGetPos(0) &", "& MouseGetPos(1) &"]", MouseGetPos(0) + 10, MouseGetPos(1) + 20)
   Sleep(5)
WEnd

Func WriteCurrentCoords()

EndFunc

Func EmptyCoords()

EndFunc

Func RunMouse()

EndFunc

Func PrintTrack()

EndFunc

Func Quit()
   Exit
EndFunc