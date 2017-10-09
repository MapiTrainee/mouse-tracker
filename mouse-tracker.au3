#cs ----------------------------------------------------------------------------
 Author:         MapiTrainee
 Script Function:
 - simulates move the mouse pointer, click or double-click the left button.
#ce ----------------------------------------------------------------------------

#include <Array.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <File.au3>

;<===USED HOTKEYS===>
HotKeySet("{ESC}","Quit")
HotKeySet("^{s}","WriteMouseState")
HotKeySet("^{f}","WriteMouseState")
HotKeySet("^{c}","WriteMouseState")
HotKeySet("^+{c}","WriteMouseState")
HotKeySet("^{d}","WriteMouseState")
HotKeySet("^{r}","RunMousePointer")
HotKeySet("^+{r}","RunMousePointerLoop")
HotKeySet("^{q}","StopMouse")
HotKeySet("^{e}","EmptyCoords")
HotKeySet("^{z}","CancelLast")
HotKeySet("^{t}","PrintTrack")
HotKeySet("^{o}","ReadFromFile")
HotKeySet("^{w}","WriteToFile")
HotKeySet("{F1}","HelpMsgBox")
;<!==USED HOTKEYS==!>

Global $sIconPath = @ScriptDir & "/mt.ico"
Global $aCoords[0]
Global $hGUI = GUICreate("", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP, $WS_EX_LAYERED)
Global $bTrackOn = True
Global Enum $eMouseMove, $eMouseClick, $eMouseDoubleClick, $eMouseRightClick, $eMouseDrag
Global $aMouseStates[0]
Global $iMouseSpeed = 15
Global $bStopMouse = False

GUISetBkColor(0x123456, $hGUI)
GUISetIcon($sIconPath)
_WinAPI_SetLayeredWindowAttributes($hGUI, 0x123456)

While True
   ToolTip ("Current coordinates: ["& MouseGetPos(0) &", "& MouseGetPos(1) &"]", MouseGetPos(0) + 10, MouseGetPos(1) + 20)
   Sleep(100)
WEnd

Func WriteMouseState()
   Switch @HotKeyPressed
	  Case "^{s}"
		 _ArrayAdd($aMouseStates, $eMouseMove)
	  Case "^{f}"
		 _ArrayAdd($aMouseStates, $eMouseRightClick)
	  Case "^{c}"
		 _ArrayAdd($aMouseStates, $eMouseClick)
	  Case "^+{c}"
		 _ArrayAdd($aMouseStates, $eMouseDoubleClick)
	  Case "^{d}"
		 _ArrayAdd($aMouseStates, $eMouseDrag)
   EndSwitch
   WriteCurrentCoords()
EndFunc

Func WriteCurrentCoords()
   _ArrayAdd($aCoords,MouseGetPos(0))
   _ArrayAdd($aCoords,MouseGetPos(1))
   If $bTrackOn Then
	  PrintTrackPoints()
   EndIf
EndFunc

Func EmptyCoords()
   StopMouse()
   _WinAPI_RedrawWindow($hGUI, 0, 0, BitOR($RDW_INVALIDATE, $RDW_ERASE, $RDW_UPDATENOW))
   Local $aEmpty[0]
   $aCoords = $aEmpty
   $aMouseStates = $aEmpty
EndFunc

Func RunMousePointer()
   $bStopMouse = False
   Local $start_x, $start_y
   $prev_x = 0
   $prev_y = 0

   For $i = 0 To UBound($aCoords)/2 - 1
	  $x = $aCoords[$i*2]
	  $y = $aCoords[$i*2+1]

	  Switch $aMouseStates[$i]
	  Case $eMouseMove
		 MouseMove($x,$y,$iMouseSpeed)
	  Case $eMouseRightClick
		 MouseClick($MOUSE_CLICK_RIGHT,$x,$y,1,$iMouseSpeed)
	  Case $eMouseClick
		 MouseClick($MOUSE_CLICK_LEFT,$x,$y,1,$iMouseSpeed)
	  Case $eMouseDoubleClick
		 MouseClick($MOUSE_CLICK_LEFT,$x,$y,2,$iMouseSpeed)
	  Case $eMouseDrag
		 MouseClickDrag($MOUSE_CLICK_LEFT,$prev_x,$prev_y,$x,$y,$iMouseSpeed)
	  EndSwitch

	  $prev_x = $x
	  $prev_y = $y

	  If $bStopMouse Then
		 $bStopMouse = False
		 Return False
	  EndIf
   Next

   Return True
EndFunc

Func RunMousePointerLoop()
   Do
	  Local $bRunLoop = Not RunMousePointer()
   Until $bRunLoop
EndFunc


Func StopMouse()
   $bStopMouse = True
EndFunc

Func CancelLast()
   StopMouse()
   If UBound($aCoords)>0 Then
	  _ArrayPop($aCoords)
	  _ArrayPop($aCoords)
	  _ArrayPop($aMouseStates)

	  If $bTrackOn Then
		 _WinAPI_RedrawWindow($hGUI, 0, 0, BitOR($RDW_INVALIDATE, $RDW_ERASE, $RDW_UPDATENOW))
		 PrintTrackPoints()
	  EndIf
   EndIf
EndFunc

Func PrintTrackPoints()
   GUISetState(@SW_SHOW, $hGUI)
   Local $hGraphic, $hBrush, $hPen, $hFormat, $hFamily, $hFont, $tLayout, $aInfo

   _GDIPlus_Startup()
   $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)
   $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
   $hPen = _GDIPlus_PenCreate(0xFFFFFFFF, 2)
   $hFormat = _GDIPlus_StringFormatCreate()
   $hBrushBg = _GDIPlus_BrushCreateSolid(0xFF18A1BF)
   $hFamily = _GDIPlus_FontFamilyCreate("Trebuchet MS")
   $hFont = _GDIPlus_FontCreate($hFamily, 10, 1)

   Local $iSpace = 4

   For $i = 0 To UBound($aCoords)/2 - 1
	  $x = $aCoords[$i*2]
	  $y = $aCoords[$i*2+1]
	  $sString = $i + 1

	  $tLayout = _GDIPlus_RectFCreate($x + 4, $y, 0, 0)
	  $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $sString, $hFont, $tLayout, $hFormat)

	  Switch $aMouseStates[$i]
	  Case $eMouseMove
		 _GDIPlus_BrushSetSolidColor ($hBrushBg, 0xff18a1bf)
	  Case $eMouseRightClick
		 _GDIPlus_BrushSetSolidColor ($hBrushBg, 0xff18bf36)
	  Case $eMouseClick
		 _GDIPlus_BrushSetSolidColor ($hBrushBg, 0xffffa500)
	  Case $eMouseDoubleClick
		 _GDIPlus_BrushSetSolidColor ($hBrushBg, 0xffbf3618)
	  Case $eMouseDrag
		 _GDIPlus_BrushSetSolidColor ($hBrushBg, 0xffbf18a1)
	  EndSwitch

	  _GDIPlus_GraphicsFillRect($hGraphic, $aInfo[0].X - $iSpace/2, $aInfo[0].Y - $iSpace/2, $aInfo[0].Width + $iSpace, $aInfo[0].Height + $iSpace, $hBrushBg)
	  _GDIPlus_GraphicsDrawStringEx($hGraphic, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)
	  _GDIPlus_GraphicsDrawRect($hGraphic, $aInfo[0].X - $iSpace/2, $aInfo[0].Y - $iSpace/2, $aInfo[0].Width + $iSpace, $aInfo[0].Height + $iSpace, $hPen)
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

Func PrintTrack()
   If $bTrackOn Then
	  _WinAPI_RedrawWindow($hGUI, 0, 0, BitOR($RDW_INVALIDATE, $RDW_ERASE, $RDW_UPDATENOW))
	  $bTrackOn = False
   Else
	  PrintTrackPoints()
	  $bTrackOn = True
   EndIf
EndFunc

Func WriteToFile()
   Local $x, $y, $m, $hFile, $sFilePath
   $sFilePath = FileSaveDialog("Save as ...", @ScriptDir & "\", "Saves (*.mt)",$FD_PATHMUSTEXIST, "save.mt")
   If @error == 0 Then
	  $hFile = FileOpen($sFilePath, $FO_OVERWRITE)
	  For $i = 0 To UBound($aCoords)/2 - 1
		 $x = $aCoords[$i*2]
		 $y = $aCoords[$i*2+1]
		 $m = $aMouseStates[$i]
		 FileWriteLine($hFile, $x & @CRLF  & $y & @CRLF & $m)
	  Next
	  FileClose($hFile)
   EndIf
EndFunc

Func ReadFromFile()
   Local $aFile, $hFile, $sFilePath

   $sFilePath = FileOpenDialog("Select Mouse Tracker save", @ScriptDir & "\", "Saves (*.mt)", $FD_FILEMUSTEXIST)
   If @error == 0 Then
	  EmptyCoords()
	  $hFile = FileOpen($sFilePath)
	  $aFile = FileReadToArray($hFile)
	  FileClose($hFile)

	  For $i = 0 To UBound($aFile)/3 - 1
		 _ArrayAdd($aCoords,$aFile[$i*3])
		 _ArrayAdd($aCoords,$aFile[$i*3+1])
		 _ArrayAdd($aMouseStates,$aFile[$i*3+2])
	  Next
	  $bTrackOn = False
	  PrintTrack()
   EndIf
EndFunc

Func Quit()
   Local $hExitMsgBox = MsgBox(32+4,"Exit...","Are you sure you want to exit the application?")
   If $hExitMsgBox == 6 Then
	  GUIDelete($hGUI)
	  Exit
   EndIf
EndFunc

Func HelpMsgBox()
   MsgBox(0, "Help...", "Shortcuts that you have to know: " & @CRLF _
   & "[1] F1 = Help. " & @CRLF _
   & "[2] ESC = Exit." & @CRLF _
   & "[3] CTRL+S = Mouse 'move' operation." & @CRLF _
   & "[4] CTRL+F = Mouse 'right button click' operation." & @CRLF _
   & "[5] CTRL+C = Mouse 'left button click' operation." & @CRLF _
   & "[6] CTRL+SHIFT+C = Mouse 'left button double-click' operation." & @CRLF _
   & "[7] CTRL+D = Mouse 'left button click and drag' operation." & @CRLF _
   & "[8] CTRL+Z = Cancel last operation." & @CRLF _
   & "[9] CTRL+Q = Stop mouse running." & @CRLF _
   & "[10] CTRL+R = Run mouse pointer." & @CRLF _
   & "[11] CTRL+SHIFT+R = Run mouse pointer in loop." & @CRLF _
   & "[12] CTRL+T = Switch on/off track mode." & @CRLF _
   & "[13] CTRL+W = Save the way." & @CRLF _
   & "[14] CTRL+O = Load the way." & @CRLF)
EndFunc