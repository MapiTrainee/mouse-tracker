#cs ----------------------------------------------------------------------------
 Author:         MapiTrainee
 Script Function:
 - simulates move the mouse pointer, click or double-click the left button.
#ce ----------------------------------------------------------------------------

#include <Array.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>

;<---USED HOTKEYS--->
HotKeySet("{q}","Quit")
HotKeySet("{w}","WriteCurrentCoords")
HotKeySet("{r}","RunMousePointer")
HotKeySet("{e}","EmptyCoords")
HotKeySet("{t}","PrintTrack")
;<!--USED HOTKEYS--!>

Global $sIconPath = @ScriptDir & "/mt.ico"
Global $aCoords[0]
Global $hGUI = GUICreate("", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP, $WS_EX_LAYERED)

GUISetBkColor(0x123456, $hGUI)
GUISetIcon($sIconPath)
_WinAPI_SetLayeredWindowAttributes($hGUI, 0x123456)

While True
   ToolTip ("Current coordinates: ["& MouseGetPos(0) &", "& MouseGetPos(1) &"]", MouseGetPos(0) + 10, MouseGetPos(1) + 20)
   Sleep(100)
WEnd

Func WriteCurrentCoords()
   _ArrayAdd($aCoords,MouseGetPos(0))
   _ArrayAdd($aCoords,MouseGetPos(1))
EndFunc

Func EmptyCoords()
   _WinAPI_RedrawWindow($hGUI, 0, 0, BitOR($RDW_INVALIDATE, $RDW_ERASE, $RDW_UPDATENOW))
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
   _WinAPI_RedrawWindow($hGUI, 0, 0, BitOR($RDW_INVALIDATE, $RDW_ERASE, $RDW_UPDATENOW))
   GUISetState(@SW_SHOW, $hGUI)

   Local $hGraphic, $hBrush, $hPen, $hFormat, $hFamily, $hFont, $tLayout, $aInfo

   _GDIPlus_Startup()
   $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)
   $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF) ;0xFF18A1BF 0xFF17C77C
   $hPen = _GDIPlus_PenCreate(0xFFFFFFFF, 2)
   $hBrushBg = _GDIPlus_BrushCreateSolid(0xFF18A1BF)
   $hFormat = _GDIPlus_StringFormatCreate()
   $hFamily = _GDIPlus_FontFamilyCreate("Trebuchet MS")
   $hFont = _GDIPlus_FontCreate($hFamily, 10, 1)

   Local $iSpace = 4
   Local $j = 1

   For $i = 0 To UBound($aCoords)/2 - 1
	  $x = $aCoords[$i*2]
	  $y = $aCoords[$i*2+1]
	  $sString = $j

	  $tLayout = _GDIPlus_RectFCreate($x, $y, 0, 0)
	  $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $sString, $hFont, $tLayout, $hFormat)
	  _GDIPlus_GraphicsFillRect($hGraphic, $aInfo[0].X - $iSpace/2, $aInfo[0].Y - $iSpace/2, $aInfo[0].Width + $iSpace, $aInfo[0].Height + $iSpace, $hBrushBg)
	  _GDIPlus_GraphicsDrawStringEx($hGraphic, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)
	  _GDIPlus_GraphicsDrawRect($hGraphic, $aInfo[0].X - $iSpace/2, $aInfo[0].Y - $iSpace/2, $aInfo[0].Width + $iSpace, $aInfo[0].Height + $iSpace, $hPen)

	  $j = $j + 1
   Next

   _GDIPlus_FontDispose($hFont)
   _GDIPlus_FontFamilyDispose($hFamily)
   _GDIPlus_StringFormatDispose($hFormat)
   _GDIPlus_BrushDispose($hBrushBg)
   _GDIPlus_BrushDispose($hBrush)
   _GDIPlus_PenCreate($hPen)
   _GDIPlus_GraphicsDispose($hGraphic)
   _GDIPlus_Shutdown()

EndFunc

Func Quit()
   Local $hExitMsgBox = MsgBox(32+4,"Exit...","Are you sure you want to exit the application?")
   If $hExitMsgBox == 6 Then
	  GUIDelete($hGUI)
	  Exit
   EndIf
EndFunc