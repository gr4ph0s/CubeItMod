#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.12.0
 Auteur:         Gr4ph0s

 Script function:
	Function To read Data and Assign value with the main content of a BFB File from KISSlicer - PRO

#ce ----------------------------------------------------------------------------

;I will comment all the functions when I will finnish the managment of the main content
;So dont worry it will coming and sory if you understand nothing ^^'

Func a_setContentArrayData($aReadedData)
	Local $aOutput[0],$aOption[0][2]
	For $i = 0 To UBound($aReadedData) - 1
		If Asc($aReadedData[$i]) == 59 Then
			$aOption = a_GetOption($aReadedData[$i],$aOption)
		Else
			_ArrayAdd($aOutput,s_GenerateFinalArray($aReadedData[$i],$aOption))
		EndIf
	Next

	Return $aOutput
EndFunc

Func a_GetOption($sLine,$aOption)
	return $aOption

EndFunc

Func s_GenerateFinalArray($sLine,$aOption)
	Return $sLine
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
	For $i = 2 To ($aLines[0][1] - $aLines[0][0]) - 2
		$sBuffer = FileReadLine($sFile&".bak",$aLines[0][0]+$i) & @CRLF
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