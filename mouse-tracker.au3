#cs ----------------------------------------------------------------------------
 Author:         MapiTrainee
 Script Function:
 - simulates move the mouse pointer, click or double-click the left button.
#ce ----------------------------------------------------------------------------

 #include <File.au3>
 #include <Array.au3>

;<---USED HOTKEYS--->
HotKeySet("{q}","Quit")
HotKeySet("{w}","WriteCurrentCords")
HotKeySet("{r}","RunMouse")
HotKeySet("{e}","EmptyCords")
;<!--USED HOTKEYS--!>

While True
   ToolTip ("Current cordinates: ["& MouseGetPos(0) &", "& MouseGetPos(1) &"]", MouseGetPos(0) + 10, MouseGetPos(1) + 20)
   Sleep(5)
WEnd

Func WriteCurrentCords()

EndFunc

Func EmptyCords()

EndFunc

Func RunMouse()

EndFunc

Func Quit()
   Exit
EndFunc