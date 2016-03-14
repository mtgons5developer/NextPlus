;1280 x 768
#include <ScreenCapture.au3>
#include <GUIConstants.au3>
#include <Math.au3>
#include <Array.au3>
#include <String.au3>
#include <File.au3>
#include <AutoItConstants.au3>

Global $MSG, $LASTMESSAGE, $x, $y, $letter, $number, $num

$APP = "BlueStacks App Player"
$OCR = "FreeOCR"
$BS = "BlueStacks Tweaker 3.12"

Opt("MouseCoordMode", 0)
Opt("PixelCoordMode", 0)

HotKeySet("{F11}", "_X")
HotKeySet("x", "_X")

;_OPEN_NP()
;Exit

;~ _StartUp()
;~ _START_BS()
;~ _INSTALL()
;Exit

$i = 0
While 1
	$i += 1

	_SIGNUP()
	_OCR()
	_VerifyPhone()
	_SignOut()

	If $i = 3 Then
		$i = 0
		_UNINSTALL()
		_TWEAK()
		_INSTALL()
 	EndIf

WEnd

;=================================================================================


Func _StartUp()

ProcessClose("FreeOCR.exe")
ProcessClose("FreeOCR.exe")
Sleep(1000)

If ProcessExists("FreeOCR.exe") Then
Else
	Run(@WorkingDir & "\FreeOCR\FreeOCR.exe")
EndIf

WinWaitActive("FreeOCR")

Local $windows = WinList()

For $i = 0 to $windows[0][0]
	If StringInStr($windows[$i][0], "FreeOCR") Then
		WinActivate($windows[$i][0],'')
		Sleep(100)
		WinMove($windows[$i][0], '', 0, 0)
		Sleep(100)
	EndIf
Next

Sleep(1000)
MouseClick("left", 425, 147, 2, 10)
Sleep(1000)


EndFunc

;=================================================================================

Func _START_BS()

Local $N2, $N21

WinActivate($BS)
Sleep(1000)
WinMove($BS, "", 0, 0)
Sleep(1000)
MouseMove(355, 115, 1)
Sleep(1000)

$N1 = PixelChecksum(324, 105, 381, 120)
$N2 = PixelChecksum(324, 105, 381, 120)

While $N1 = $N2 ;GUID
	MouseClick("left", 355, 115, 1, 10)
	Sleep(1000)
	$N2 = PixelChecksum(324, 105, 381, 120)
WEnd

WinWaitActive($APP)

EndFunc

;=================================================================================

Func _SIGNUP()

	WinActivate($APP)
	Sleep(1000)
	WinMove($APP, "", 0, 0)
	Sleep(1000)

	While PixelGetColor(718, 530) <> 51283
		ToolTip("Waiting for Signup",0,0)
		Sleep(1000)
	WEnd

	If PixelGetColor(718, 530) = 51283 Then MouseClick("left", 718, 530, 2, 10)

	While PixelGetColor(41, 343) <> 13421772 ;Sign Up
		ToolTip("Signup",0,0)
		Sleep(500)
	WEnd

	ToolTip("",0,0)

	If PixelGetColor(41, 343) = 13421772 Then
		ToolTip("Fill Up",0,0)
		Sleep(500)
		_RandomLetters()
		ToolTip("Name",0,0)
		SendMessage($letter, 232, 133)
		_RandomLetters()
		ToolTip("Last Name",0,0)
		SendMessage($letter, 741, 133)
		Sleep(250)
		Send("{ENTER}")
		Sleep(250)
		Send("{ENTER}")

		Sleep(1000)
		ToolTip("Gender",0,0)
		MouseClick("left", 711, 235, 1, 10)
		Sleep(1000)

		While 1
			Local $aCoord = PixelSearch(206, 132, 295, 165, 3388901)
			Sleep(1000)
			If $aCoord = @error Then
			ElseIf Not @error And $aCoord[0] > 0 Then
				ExitLoop
			EndIf
			Sleep(1000)
		WEnd

		MouseMove(453, 267, 2)
		Sleep(500)
		$num = Round(Random(14, 30))
		$x = 0
		While 1
			$x += 1
			MouseWheel("UP", 1)
			Sleep(100)
			If $num = $x + 3 Then ExitLoop
		WEnd
		Sleep(1000)
		MouseClick("left", 514, 485, 1, 10)

		Sleep(500)
		_RandomLetters()
		_RandomNumbers()
		ToolTip("Email",0,0)
		SendMessage($letter & $number & "@gmail.com", 139, 229)
		ToolTip("Password",0,0)
		_RandomLetters()
		SendMessage($letter, 70, 279)

		While PixelGetColor(39, 341) <> 44610 ;Next
			ToolTip("Check green",0,0)
			Sleep(1000)
			MouseClick("left", 40, 343, 1, 10)
			Sleep(3000)
		WEnd

	EndIf

	$i = 0
	While 1
		$i += 1
		Local $aCoord = PixelSearch(364, 656, 414, 694, 44610)
		Local $aCoord2 = PixelSearch(212, 244, 347, 269, 4176358, 10)
		Sleep(1000)
		If PixelGetColor(39, 341) = 44610 Then MouseClick("left", 1001, 80, 1, 10)

		If $aCoord = @error Then
			ToolTip("Maybe Later",0,0)
			Sleep(1000)
			WinActivate($APP)
			WinMove($APP, "", 0, 0)
		ElseIf Not @error And $aCoord[0] > 0 Then
			ToolTip("Click Maybe Later",0,0)
			Sleep(1000)
			WinActivate($APP)
			MouseClick("left", 58, 676, 1, 10)
			ExitLoop
		EndIf

		If $aCoord2 = @error Then
			ToolTip("Maybe Later",0,0)
			Sleep(1000)
			WinActivate($APP)
			Sleep(1000)
			WinMove($APP, "", 0, 0)
			Sleep(1000)
		ElseIf Not @error And $aCoord2[0] > 0 Then
			ToolTip("Sign Up Error",0,0)
			Sleep(1000)
			MouseClick("left", 494, 374, 1, 10)
		EndIf
		Sleep(1000)
		If $i = 5 Then
			_OPEN_NP()
			$i = 5
		EndIf
	WEnd

	While PixelGetColor(386, 72) <> 16777215
		ToolTip('Waiting...')
		WinActivate($APP)
		WinMove($APP, "", 0, 0)
		Sleep(2000)
	WEnd

	Sleep(2000)

	While 1
		Local $aCoord = PixelSearch(878, 62, 920, 85, 1348425)
		Sleep(1000)
		If $aCoord = @error Then
		ElseIf Not @error And $aCoord[0] > 0 Then
			ToolTip("HOME",0,0)
			WinMove($APP, "", 0, 0)
			Sleep(1000)
			MouseClick("left", 923, 67, 1, 10)
			ExitLoop
		EndIf
		Sleep(1000)
	WEnd

	ToolTip("",0,0)

While PixelChecksum(18, 293, 366, 322) <> 3900982786
	ToolTip('',0,0)
	Sleep(1000)
WEnd

While PixelChecksum(18, 293, 366, 322) == 3900982786
	ToolTip('Waiting for Phone #',0,0)
	Sleep(1000)
	MouseClick("left", 442, 311, 1, 10)
WEnd

While PixelChecksum(22, 288, 137, 299) == 1165902813
	ToolTip('Waiting for Phone #',0,0)
	Sleep(1000)
	If PixelChecksum(208, 223, 427, 255) = 3389278141 Then Send("{Esc}")
	Sleep(1000)
WEnd

Sleep(500)
_ScreenCapture_Capture("number.jpg", 17, 305, 215, 329)
Sleep(500)

EndFunc

Func _INSTALL()

WinActivate($APP)
WinMove($APP, "", 0, 0)
Sleep(1000)

While PixelGetColor(151, 106) <> 15987698 ;Wait ES
	ToolTip("Wait for ES Explorer",0,0)
	Sleep(1000)
WEnd

While 1 ;Click ES
	Local $aCoord = PixelSearch(419, 72, 557, 94, 3515634)
	Sleep(1000)
	ToolTip("Open ES Explorer",0,0)
	If $aCoord = @error Then
		MouseClick("left", 144, 90, 1, 10)
	ElseIf Not @error And $aCoord[0] > 0 Then
		Sleep(3000)
		ExitLoop
	EndIf
	Sleep(1000)
WEnd

MouseClick("left", 711, 60, 1, 10)

ToolTip("",0,0)
Run(@ComSpec & " /c " & '"nextplus.apk"')
ToolTip("Insalling Nextplus.",0,0)

While PixelChecksum(898, 183, 980, 205) <> 1757157512
	ToolTip("Waiting for Nextplus",0,0)
	WinActivate($APP)
	Sleep(5000)
	If PixelGetColor(952, 142) = 9289811 Then
		MouseClick("left", 941, 142, 1, 10)
		ExitLoop
	ElseIf PixelGetColor(952, 320) = 9552982 Then
		MouseClick("left", 937, 320, 1, 10)
		ExitLoop
	EndIf
WEnd

While PixelGetColor(361, 202) <> 9421397
	ToolTip("Nextplus Found",0,0)
	Sleep(1000)
WEnd

While 1
	WinActivate($APP)
	Sleep(1000)
	WinMove($APP, "", 0, 0)
	Sleep(1000)

	If PixelGetColor(718, 530) = 51283 Then
		ToolTip("Waiting for Signup",0,0)
		ExitLoop
	ElseIf PixelGetColor(361, 202) = 9421397 Then
		ToolTip("Opening Nextplus",0,0)
		MouseClick("left", 643, 455, 1, 10)
		Sleep(1000)
		ExitLoop
	EndIf
	Sleep(1000)
WEnd


EndFunc




Func _UNINSTALL()

WinActivate($APP)
Sleep(1000)
WinMove($APP, "", 0, 0)
Sleep(1000)

While PixelGetColor(144, 90) <> 4370425 ;Close App
	MouseClick("left", 131, 599, 1, 10)
	Sleep(1000)
WEnd

While PixelChecksum(13, 64, 76, 88) <> 2718240028 ;Click ES
	ToolTip("Open ES Explorer",0,0)
	MouseClick("left", 144, 90, 1, 10)
	Sleep(3000)
WEnd

While PixelGetColor(276, 174) <> 3515634 ;Blue House
	ToolTip("Blue House",0,0)
	MouseClick("left", 603, 60, 1, 10)
	Sleep(1000)
WEnd

While PixelGetColor(951, 141) <> 9620555 ;Android
	ToolTip("HOME",0,0)
	MouseClick("left", 282, 175, 1, 10)
	Sleep(1000)
WEnd

While PixelGetColor(951, 141) = 9620555 ;Android
	ToolTip("APP",0,0)
	MouseClick("left", 949, 143, 2, 10)
	Sleep(1000)
WEnd


While PixelChecksum(898, 183, 980, 205) <> 1757157512
	ToolTip("Waiting for Nextplus",0,0)
	Sleep(1000)
	If PixelChecksum(898, 366, 978, 387) = 904638655 Then
		MouseClick("left", 941, 336, 1, 10)
		ExitLoop
	ElseIf PixelChecksum(898, 183, 980, 205) = 1757157512 Then
		MouseClick("left", 937, 145, 1, 10)
		ExitLoop
	EndIf
WEnd

While PixelChecksum(468, 147, 558, 165) <> 84889809 ;Properties
	Sleep(1000)
WEnd

While PixelChecksum(468, 147, 558, 165) = 84889809 ;Properties
	ToolTip("Uninstall1",0,0)
	Sleep(1000)
	MouseClick("left", 513, 405, 1, 10)
WEnd
ToolTip("",0,0)
Sleep(500)
While PixelGetColor(399, 256) <> 975900 ; Wait OK
	ToolTip("Wait OK",0,0)
	Sleep(1000)
WEnd

While PixelGetColor(399, 256) = 975900
	ToolTip("OK",0,0)
	MouseClick("left", 591, 373, 1, 10)
	Sleep(1000)
WEnd
ToolTip("",0,0)

EndFunc


Func _TWEAK()

Local $N2, $N21

WinActivate($BS)
Sleep(1000)
WinMove($BS, "", 0, 0)
Sleep(1000)

$N1 = PixelChecksum(108, 186, 315, 204)
$N2 = PixelChecksum(108, 186, 315, 204)

While $N1 = $N2 ;GUID
	MouseClick("left", 422, 198, 1, 10)
	Sleep(500)
	$N2 = PixelChecksum(108, 186, 315, 204)
WEnd

While 1
	ToolTip("Waiting for BSAndroidID",0,0)
	MouseClick("left", 289, 236, 1, 10)
	Sleep(250)
	If WinExists("BSAndroidID") Then ExitLoop ;Change
WEnd

Sleep(500)
WinMove("BSAndroidID", "", 0, 0)

$N11 = PixelChecksum(11, 34, 189, 55)
$N21 = PixelChecksum(11, 34, 189, 55)

While $N11 = $N21 ;Random
	ToolTip("Random",0,0)
	MouseClick("left", 223, 87, 1, 10)
	Sleep(500)
	$N21 = PixelChecksum(11, 34, 189, 55)
WEnd

MouseClick("left", 52, 87, 2, 10) ;OK

While Not WinExists("Restarting BlueStacks")
	ToolTip("Start BS",0,0)
	MouseClick("left", 345, 132, 1, 10)
	Sleep(1000)
WEnd

;_INSTALL()

EndFunc

;=================================================================================

;http://sms.topsocialbot.com/user/PV
Func _VerifyPhone()

;OCR GOES HERE
WinActivate($APP)
Sleep(1000)

While PixelGetColor(306, 72) <> 16777215 ;Message Tab
	MouseClick("left", 306, 72, 1, 10)
	Sleep(500)
WEnd

Sleep(1000)

While PixelGetColor(42, 123) = 16777215 ;Message Code
	Sleep(1000)
WEnd

$num = ""

While $num == ""
	_CODE() ;dldl
WEnd

Local $ZZ

If Not _FileReadToArray('code.txt', $ZZ) Then
	MsgBox(0,'code.txt',"File Not Found", 1)
EndIf

For $x = 1 To $ZZ[0]
	$message = $ZZ[$x]
	ExitLoop
Next

WinActivate("Phone Verification - Google Chrome")
Sleep(500)
WinMove("Phone Verification - Google Chrome", "", 0, 0)
Sleep(500)

SendMessage($message, 433, 344)
Sleep(250)
ToolTip("",0,0)

MouseClick("left", 530, 388, 2, 10) ;submit

$i = 0
While PixelChecksum(495, 333, 621, 358) <> 4281117505
	$i += 1
	Sleep(1000)
	If $i = 5 Then
		$i = 0
		MouseClick("left", 530, 388, 2, 10) ;submit

	EndIf
WEnd

Send("{F5}")

EndFunc

;=================================================================================

Func _OCR()
WinActivate($OCR)
Sleep(500)
WinMove($OCR,"",0,0)
Sleep(500)

While Not WinExists("Select Image to OCR") ;dmdm
	MouseClick("left", 110, 92, 1, 10)
	Sleep(1000)
WEnd

ClipPut(@WorkingDir & "\number.jpg")
Sleep(250)
Send("^v")
Sleep(250)
Send("{ENTER}")
Sleep(1000)

$num = ""
While $num == ""

	MouseClick("left", 316, 83, 1, 5)
	Sleep(1000)

	ClipPut("")
	MouseMove(355, 134, 10)
	Sleep(250)
	MouseClick("left", 355, 134, 1, 5) ;OCR
	Sleep(500)
	MouseClick("left", 422, 229, 1, 5) ;clipboard
	Sleep(500)
	MouseClick("left", 424, 149, 2, 5) ;X
	Sleep(500)
	$num = ClipGet()
	$num = StringReplace($num, "U", "0")
	$num = StringReplace($num, @CRLF, "")
	$TT = FileOpen("phone_number.txt", 2)
	FileWriteLine($TT, $num)
	FileClose($TT)
WEnd

Local $ZZ

If Not _FileReadToArray('phone_number.txt', $ZZ) Then
	MsgBox(0,'phone_number.txt',"File Not Found", 1)
EndIf

For $x = 1 To $ZZ[0]
	$phone = $ZZ[$x]
	ExitLoop
Next

WinActivate("Phone Verification - Google Chrome")
Sleep(500)
WinMove("Phone Verification - Google Chrome", "", 0, 0)
Sleep(500)

MouseClick("left", 218, 260, 3, 2)
SendMessage($phone, 218, 260)
Sleep(250)

While PixelGetColor(40, 301) <> 16777215
	MouseClick("left", 646, 298, 2, 10) ;Submit #
	Sleep(1000)
WEnd

$i = 0
While PixelChecksum(495, 333, 621, 358) <> 3165908719
	$i += 1
	Sleep(1000)
	If $i = 5 Then
		MouseClick("left", 646, 298, 2, 10) ;Submit #
		$i = 0
	EndIf

WEnd



EndFunc


Func _RandomLetters()

	$letter = Chr(Random(Asc("A"), Asc("Z"), 1)) & Chr(Random(Asc("A"), Asc("Z"), 1)) & Chr(Random(Asc("A"), Asc("Z"), 1)) & _
	 Chr(Random(Asc("A"), Asc("Z"), 1)) & Chr(Random(Asc("A"), Asc("Z"), 1)) & Chr(Random(Asc("A"), Asc("Z"), 1)) & _
	 Chr(Random(Asc("A"), Asc("Z"), 1)) & Chr(Random(Asc("A"), Asc("Z"), 1)) & Chr(Random(Asc("A"), Asc("Z"), 1))
	$letter = StringLower($letter)

EndFunc

Func _RandomNumbers()

		$number = Round(Random(0, 9)) & Round(Random(0, 9)) & Round(Random(0, 9)) & Round(Random(0, 9)) & Round(Random(0, 9)) & _
					Round(Random(0, 9)) & Round(Random(0, 9)) & Round(Random(0, 9)) & Round(Random(0, 9)) & Round(Random(0, 9))

EndFunc



Func _SignOut()

WinActivate($APP)
Sleep(1000)
WinMove($APP, "", 0, 0)
Sleep(1000)

While PixelGetColor(921, 67) = 16777215 ;Settings
	MouseClick("left", 468, 427, 1, 10)
	Sleep(1000)
WEnd

MouseMove(519, 495, 2)

While PixelChecksum(468, 484, 566, 511) <> 4023916499
	Sleep(1000)
	MouseWheel("DOWN", 2)
WEnd

While PixelChecksum(206, 240, 299, 272) <> 3568640259
	MouseClick("left", 516, 500, 1, 10)
	Sleep(1000)
WEnd

Send("{TAB}")
Sleep(250)
Send("{TAB}")
Sleep(250)
Send("{ENTER}")

EndFunc



Func _CODE()

Sleep(500)
MouseClick("left", 42, 123, 2, 10)
MouseMove(215, 453, 2)
Sleep(2000)
MouseDown($MOUSE_CLICK_LEFT)
While PixelChecksum(207, 248, 389, 281) <> 1469339410
	Sleep(250)
WEnd
MouseUp($MOUSE_CLICK_LEFT)

Sleep(500)
MouseClick("left", 374, 321, 2, 10)
Sleep(100)
$num = ClipGet()
$num = StringTrimLeft($num, 4)
$1 = StringInStr($num, "t")
$code = StringLeft($num, $1 - 2)

$TT = FileOpen("code.txt", 2)
FileWriteLine($TT, $code)
FileClose($TT)

While PixelGetColor(306, 72) <> 16777215 ;Message Tab
	MouseClick("left", 30, 76, 1, 10)
	Sleep(1000)
WEnd

While PixelGetColor(306, 72) = 16777215 ;Message Tab
	MouseClick("left", 924, 74, 1, 10)
	Sleep(500)
WEnd

EndFunc

Func _OPEN_NP()

WinActivate($APP)
WinMove($APP, "", 0, 0)
Sleep(1000)

While PixelGetColor(151, 106) <> 15987698 ;Wait ES
	ToolTip("Wait for ES Explorer",0,0)
	Sleep(1000)
WEnd

ToolTip("Open ES Explorer",0,0)
MouseClick("left", 144, 90, 1, 10)
Sleep(2000)

While PixelChecksum(898, 183, 980, 205) <> 1757157512
	ToolTip("Waiting for Nextplus",0,0)
	WinActivate($APP)
	Sleep(1000)
	If PixelGetColor(952, 142) = 9289811 Then
		MouseClick("left", 941, 142, 1, 5)
		ExitLoop
	ElseIf PixelGetColor(952, 320) = 9552982 Then
		MouseClick("left", 937, 320, 1, 10)
		ExitLoop
	EndIf
WEnd

While PixelGetColor(361, 202) <> 9421397
	ToolTip("Nextplus Found",0,0)
	Sleep(1000)
WEnd

While PixelGetColor(361, 202) = 9421397
	ToolTip("Opening Nextplus",0,0)
	MouseClick("left", 643, 455, 1, 10)
	Sleep(1000)
WEnd


EndFunc



Func SendMessage($MSG, $x, $y)

	If $MSG <> $LASTMESSAGE Then
		ClipPut($MSG)
		MouseClick("left", $x, $y, 2, 5)
		Sleep(50)
		Send("^v")
		Sleep(250)
		Send("{ENTER}")
	EndIf

	ClipPut("")
	$MSG = $LASTMESSAGE

EndFunc

Func _X()
	Exit
EndFunc
