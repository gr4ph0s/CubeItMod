#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.12.0
 Auteur:         Gr4ph0s

 Script function:
	Function To read Data and Assign value with the main content of a BFB File from KISSlicer - PRO

#ce ----------------------------------------------------------------------------

;I will comment all the functions when I will finnish the managment of the main content
;So dont worry it will coming and sory if you understand nothing ^^'



Func a_getContentDataBySearch()
	Local $aDataToGet[0][2],$iStartLine,$iEndLineLine,$i = 0
	$sFile = FileOpen($sFile)
;~ 	While $i <= $iFileLinesNumber
	While $i <= 1789
		$sLine = FileReadLine($sFile,$i)
		If StringInStr ($sLine,"; BEGIN_LAYER_OBJECT") <> 0 Then
			$iStartLine = $i
		EndIf
		If StringInStr ($sLine,"; END_LAYER_OBJECT ") <> 0 Then
			$iEndLineLine = $i
			_ArrayAdd($aDataToGet,$iStartLine&"|"&$iEndLineLine)
		EndIf
		$i += 1
	WEnd
	Return $aDataToGet
EndFunc
Func a_setContentArrayData($aReadedData)
	Local $aOutput[0],$aBuffer
	Global $aOption[8]
	$aOption[6] = 1
	$aOption[7] = 1


	For $i = 0 To UBound($aReadedData) - 1
		If Asc($aReadedData[$i]) == 59 Then
			$aOption = a_GetOption($aReadedData[$i])
		Else
			$aBuffer = s_GenerateFinalArray($aReadedData[$i])
			For $y = 0 To UBound($aBuffer)-1
				_ArrayAdd($aOutput,$aBuffer[$y])
			Next
		EndIf
	Next

	Return $aOutput
EndFunc

Func a_GetOption($sLine)
	Local $vBuffer, $aBuffer

	If StringInStr ($sLine,"Warming Extruder") <> 0 Then
		$aBuffer = StringRegExp($sLine, "(\d+)", 3)
		$aOption[0] = $aBuffer[0]
		$aOption[1] = $aBuffer[1]
	EndIf

	If StringInStr ($sLine,"; BEGIN_LAYER_OBJECT") <> 0 Then
		$aBuffer = StringRegExp($sLine, "(\d+.\d+)", 3)
		$aOption[2] = $aBuffer[0]
	EndIf

	If StringInStr ($sLine,"[head mm/s]") <> 0 Then
		$aBuffer = StringRegExp($sLine, "(?:\')(.+)(?:\', )(\d+.\d+)(?: \[RPM\]\, )(\d+.\d+)", 3)
		$aOption[3] = $aBuffer[0]
		$aOption[4] = $aBuffer[1]
		$aOption[5] = $aBuffer[2]
	EndIf

	return $aOption
EndFunc

Func s_GenerateFinalArray($sLine)
	Local $aOutput[0],$aBuffer
	If StringInStr ($sLine,"M104") <> 0 Then
		_ArrayAdd($aOutput,$sLine)
		$aOutput = a_GenerateM227($aOutput)
		$aOutput = a_GenerateM228($aOutput)
		return $aOutput
	EndIf

	If StringInStr ($sLine,"M227") <> 0 Then
		Return $aOutput
	EndIf

	If StringInStr ($sLine,"M227") <> 0 Then
		Return $aOutput
	EndIf

	If StringInStr ($sLine,"G1") <> 0 Then
		If $aOption[6] == 1 Then
			_ArrayAdd($aOutput,"M103")
			$aOption[6] = 0
			$aOption[7] = 0
		EndIf
		If $aOption[7] == 0 Then
			_ArrayAdd($aOutput,$sLine&"TEST")
		Else
			$aOutput = a_GenerateG1($sLine,$aOutput)
			Return $aOutput
		EndIf
		Return $aOutput
	EndIf

	If StringInStr ($sLine, "M"&$aOption[0]&"01") <> 0 Then
			$aOption[7] = 1
			_ArrayAdd($aOutput,$sLine)
			Return $aOutput
	EndIf

	_ArrayAdd($aOutput,$sLine)
	Return $aOutput
EndFunc


Func a_GenerateM227($aOutput)
	If $styleSet_use_destring = 1 Then
		Local $P = int(Eval("matSetEx"&$aOption[0]&"_destring_prime")*2962)
		Local $S = int(Eval("matSetEx"&$aOption[0]&"_destring_suck")*2962)
		_ArrayAdd($aOutput,"M227 P"& $P &" S" & $S)
	EndIf
	Return $aOutput
EndFunc


Func a_GenerateM228($aOutput)
	If $printSet_fan_pwm = 1 Then
		Local $P = int(Eval("matSetEx"&$aOption[0]&"_sec_per_C_per_C")*2962)
		Local $S = int(Eval("matSetEx"&$aOption[0]&"_cost_per_cm3")*2962)
		_ArrayAdd($aOutput,"M228 P"& $P &" S" & $S)
	EndIf
	Return $aOutput
EndFunc


Func a_GenerateG1($sLine,$aOutput)
	$aBuffer = StringRegExp($sLine, "(?:G1 X)([\-0-9.]+)(?: Y)([\-0-9.]+)(?: Z)([\-0-9.]+)(?: F)([\-0-9.]+)", 3)
	_ArrayAdd($aOutput,$sLine)
	Return $aOutput
EndFunc


Func b_WriteData($fFile,$aData)
	for $i = 0 to UBound($aData)-1
		FileWriteLine($fFile,$aData[$i])
	Next
EndFunc


Func a_getContentDataByName($aDataToGet)
	Local $aLines
	For $i = 0 To UBound($aDataToGet) - 1
		$aLines = a_getSettingsLines($aDataToGet[$i][0],$aDataToGet[$i][1])
		If Not IsArray($aLines) Then
			SetError(0,$i,"Can't Find "& StringRegExp($aDataToGet[$i][0], "([A-Za-z_ ]+ )", 3))
			Return False
		EndIf
	Next
	Return $aLines
EndFunc


func a_readContentData($aLines)
	Local $aOutput[0], $sBuffer = ""
	For $i = 2 To ($aLines[0][1] - $aLines[0][0]) - 1
;~ 		$sBuffer = FileReadLine($sFile&".bak",$aLines[0][0]+$i) & @CRLF
		$sBuffer = FileReadLine($sFile,$aLines[0][0]+$i) & @CRLF
		if @error Then
			SetError( 0 , @error)
			Return False
		EndIf
		If IsArray(StringRegExp($sBuffer, "(.+)", 3)) AND $sBuffer <> ";"&@CRLF Then
			_ArrayAdd($aOutput, $sBuffer)
		EndIf
	Next
	Return $aOutput
EndFunc