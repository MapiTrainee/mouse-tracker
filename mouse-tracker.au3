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
HotKeySet("{r}","RunMousePointer")
HotKeySet("{e}","EmptyCoords")
HotKeySet("{t}","PrintTrack")
;<!--USED HOTKEYS--!>

;Global

While True
   ToolTip ("Current coordinates: ["& MouseGetPos(0) &", "& MouseGetPos(1) &"]", MouseGetPos(0) + 10, MouseGetPos(1) + 20)
   Sleep(5)
WEnd

Func WriteCurrentCoords()
   ConsoleWrite("WRITE CURRENT COORDS !!!");
EndFunc

Func EmptyCoords()

EndFunc

Func RunMousePointer()

EndFunc

Func PrintTrack()

EndFunc

Func Quit()
   Local $hExitMsgBox = MsgBox(32+4,"Exit...","Are you sure you want to exit the application?")
   If $hExitMsgBox == 6 Then
	  Exit
   EndIf
EndFunc