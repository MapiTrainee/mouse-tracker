#cs ----------------------------------------------------------------------------
 Author:         MapiTrainee
 Script Function:
 - simulates move the mouse pointer, click or double-click the left button.
#ce ----------------------------------------------------------------------------

#include <Array.au3>

;<---USED HOTKEYS--->
HotKeySet("{q}","Quit")
HotKeySet("{w}","WriteCurrentCoords")
HotKeySet("{r}","RunMousePointer")
HotKeySet("{e}","EmptyCoords")
HotKeySet("{t}","PrintTrack")
;<!--USED HOTKEYS--!>

Local $aCoords[0]

While True
   ToolTip ("Current coordinates: ["& MouseGetPos(0) &", "& MouseGetPos(1) &"]", MouseGetPos(0) + 10, MouseGetPos(1) + 20)
   Sleep(5)
WEnd

Func WriteCurrentCoords()
   _ArrayAdd($aCoords,MouseGetPos(0))
   _ArrayAdd($aCoords,MouseGetPos(1))
EndFunc

Func EmptyCoords()
   _ArrayDisplay($aCoords)
   Local $aEmpty[0]
   $aCoords = $aEmpty
EndFunc

Func RunMousePointer()
   For $i = 0 To UBound($aCoords)/2 - 1
	  $x = $aCoords[$i*2]
	  $y = $aCoords[$i*2+1]
	  MouseMove($x,$y,10)
   Next
EndFunc

Func PrintTrack()

EndFunc

Func Quit()
   Local $hExitMsgBox = MsgBox(32+4,"Exit...","Are you sure you want to exit the application?")
   If $hExitMsgBox == 6 Then
	  Exit
   EndIf
EndFunc