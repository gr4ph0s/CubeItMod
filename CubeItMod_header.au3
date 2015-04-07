#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.12.0
 Auteur:         Gr4ph0s

 Script function:
	Function To read Data and Assign value with the header of a BFB File from KISSlicer - PRO

#ce ----------------------------------------------------------------------------

Local $sFile ,$iFileLinesNumber ;Normally thoses variables are set in the cube.au3

; #FUNCTION# ====================================================================================================================
; Name ..........: a_readVersion
; Description ...: Return an Array with the current Version and the Beta version.
; Syntax ........: a_readVersion()
; Return values .: Array [0] = Version
; 				 : Array [1] = Beta Version
; Error .........: 1 = Error into FileReadLine @extended for know why
; Error .........: 2 = Error into StringRegExp @extended for know why
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func a_readVersion()
	Local $sData = FileReadLine($sFile,3) ;Version string are into line 3
	if @error Then Return  SetError(1,$sData)
	Local $aData = StringRegExp($sData, "(\d+.\d+)", 3) ;Make data into array
	if @error Then Return SetError(2,$aData)
	$aData[0] = Number($aData[0]) ;Be sure its a float number like that we can compare it later if needed.
	$aData[1] = Number($aData[1]) ;Be sure its a float number like that we can compare it later if needed.
	Return $aData
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: b_getHeaderData
; Description ...: Assign variables and values by reading the header .bfb file
; Syntax ........: b_getHeaderData()
; Return values .: True = no problem ! :D
; 				 : False & @error = 0 & @extended = 0 => Problem into Printer Settings
; 				 : False & @error = 0 & @extended = 1 => Problem into Material Setting Extruder1
; 				 : False & @error = 0 & @extended = 2 => Problem into Material Setting Extruder2
; 				 : False & @error = 0 & @extended = 3 => Problem into Style Settings
; 				 : False & @error = 0 & @extended = 4 => Problem into Support Settings
; 				 : False & @error = 0 & @extended = 5 => Problem into Actual Slicing Settings As Used
; Remarks .......: Maybe I will rework on this function if group's name of function often change ;) (for exemple Material Setting for Extruder/Support Setting etc...)
; Related .......: b_getSettings
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func b_getHeaderData()
	If b_getSettings("; *** Printer Settings ***","; *** Material Settings for Extruder") Then ;look b_getSettings informations ;)
		If b_getSettings("; *** Material Settings for Extruder 1 ***","; *** Material Settings for Extruder 2 ***","matSetEx1_") Then
			If b_getSettings("; *** Material Settings for Extruder 2 ***","; *** Style Settings ***","matSetEx2_") Then
				If b_getSettings("; *** Style Settings ***","; *** Support Settings ***","styleSet_") Then
					If b_getSettings("; *** Support Settings ***","; *** Actual Slicing Settings As Used ***","suppSet_") Then
						If b_getSettings("; *** Actual Slicing Settings As Used ***","; *** G-code Prefix ***","actualSliceSet_") Then
							Return True
						Else
							SetError(0,5,"Actual Slicing Settings As Used")
							Return False
						EndIf
					Else
						SetError(0,4,"SupportSettings")
						Return False
					EndIf
				Else
					SetError(0,3,"StyleSettings")
					Return False
				EndIf
			Else
				SetError(0,2,"MaterialSettingExtruder2")
				Return False
			EndIf
		Else
			SetError(0,1,"MaterialSettingExtruder1")
			Return False
		EndIf
	Else
		SetError(0,0,"PrinterSettings")
		Return False
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: b_getSettings
; Description ...: set variable and value with text information beetwin 2 group's name of function.
; Syntax ........: b_getSettings($sFirstSetting, $sLastSetting[, $sPrefix = ""])
; Parameters ....: $sFirstSetting       - A string value. Should be the begin group's name of function. Exemple "; *** Printer Settings ***"
;                  $sLastSetting        - A string value. Should be the end group's name of function. Exemple "; *** Material Settings for Extruder" for Printer Settings.
;                  $sPrefix             - [optional] A string value. Default is "". A prefix added into final variableName.
; Return values .: True if sucess
; 				 : False & @error = 0 & @extended = 1 => Problem into a_getSettingsLines
; 				 : False & @error = 0 & @extended = 2 => Problem into s_readData
; 				 : False & @error = 0 & @extended = 3 => Problem into a_dataToArray
; 				 : False & @error = 0 & @extended = 4 => Problem into n_arrayToVariable
; Remarks .......: Pretty easy function but that's let us to check if fail where the fail appear by adding console_log ;)
; 				 : And that's let us add prefix by group !
; Related .......: a_getSettingsLines,s_readData,a_dataToArray,n_arrayToVariable
; Example .......: b_getSettings("; *** Printer Settings ***","; *** Material Settings for Extruder","PrinterSettings_")
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func b_getSettings($sFirstSetting,$sLastSetting,$sPrefix = "")
	;Get Lines Number
	Local $aPrinterSettingLines = a_getSettingsLines($sFirstSetting,$sLastSetting)
		If Not IsArray($aPrinterSettingLines) Then
			SetError( 0 , 1 )
			Return False
		EndIf

	;Get Text From thoses Lines
	Local $sDataSetting = s_readData($aPrinterSettingLines)
		If Not IsString($sDataSetting) Then
			SetError( 0 , 2 )
			Return False
		EndIf

	;Transform into a 2DArray
	Local $aDataSetting = a_dataToArray($sDataSetting)
		If Not IsArray($aDataSetting) Then
			SetError( 0 , 3 )
			Return False
		EndIf
	;Assign Variable to Value
	n_arrayToVariable($aDataSetting,$sPrefix)

	;Check if the last Data from the $a_dataToArray is now a variable
	If IsDeclared($sPrefix&$aDataSetting[UBound($aDataSetting)-1][0]) Then
		Return True
	Else
		SetError( 0 , 4 )
		Return False
	EndIf
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: a_getSettingsLines
; Description ...: get lines from 2 group's name of function
; Syntax ........: a_getSettingsLines($sFirstSetting, $sLastSetting)
; Parameters ....: $sFirstSetting       - A string value. Should be the begin group's name of function. Exemple "; *** Printer Settings ***"
;                  $sLastSetting        - A string value. Should be the end group's name of function. Exemple "; *** Material Settings for Extruder" for Printer Settings.
; Return values .: Array with [0][0] = line with the first group's name [0][1] = line with then end group's name.
; 				 : False & @error = 0 & @extended = 0 => Problem one of the two string are not found in the file.
; 				 : False & @error = 0 & @extended = 1 => Problem one of the two string are not found in the file.
; Example .......: a_getSettingsLines("; *** Printer Settings ***","; *** Material Settings for Extruder")
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func a_getSettingsLines($sFirstSetting,$sLastSetting)
	Local $iStartLine,$iEndLine,$aOutput[1][2],$i = 0
	While $i <= $iFileLinesNumber
		$sLine = FileReadLine($sFile,$i)
		if StringInStr ($sLine,$sFirstSetting) <> 0 Then ;Looking for $sFirstSetting in the line
			$iStartLine = Int($i)
		EndIf

		if StringInStr ($sLine,$sLastSetting) <> 0 Then ;Looking for $sLastSetting in the line
			$iEndLine = Int($i)
			ExitLoop
		EndIf
		$i = $i + 1
	WEnd
	If $i == $iFileLinesNumber Then SetError( 0 , 0 ) Return False ;if $i = FileNumber that's mean string was not found so we set error ;)
	If $iStartLine == "" OR $iEndLine == "" Then
		SetError(0 , 1)
		Return False
	EndIf;if $iStartLine or $iEndLine is empty we got an error.
	$aOutput[0][0] = $iStartLine
	$aOutput[0][1] = $iEndLine
	return $aOutput
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: s_readData
; Description ...: Simply read data from 2 lines stored in 2DArray
; Syntax ........: s_readData($aLines)
; Parameters ....: $aLines              - A 2DArray where [0][0] => LineWhereStartToRead [0][1] => LineWhereStopToRead
; Return values .: String with the data.
; 				 : False & @error = 0 & @extended = @error => Look FileReadLine @error code
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func s_readData($aLines)
	Local $sOutput = ""
	For $i = 2 To ($aLines[0][1] - $aLines[0][0]) - 2
 		$sOutput = $sOutput & FileReadLine($sFile,$aLines[0][0]+$i) & @CRLF
		if @error Then
			SetError( 0 , @error)
			Return False
		EndIf
	Next
	Return $sOutput
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: a_dataToArray
; Description ...: Make 2D Array with the good structure by reading a String value of the data.
; Syntax ........: a_dataToArray($sData)
; Parameters ....: $sData               - A string value. Who store all the data for one group's name of function
; Return values .: 2D Array Where [$i][0] = VariableName [$i][1] = Value
; 				 : False & @error = 0 & @extended = @error => Look StringRegExpReplace @error code 	|Error line $sData = StringRegExpReplace($sData, "\R;\s{2,}", "")
; 				 : False & @error = 1 & @extended = @error => Look StringRegExp @error code 		|Error line Local $aOutput = StringRegExp($sData, "([A-Za-z_ ]+)(?: = )(.+)", 3)
; 				 : False & @error = 2 & @extended = @error => Look StringRegExpReplace @error code 	|Error line $aResult[$i][0] = StringRegExpReplace($aResult[$i][0], " ", "_", 0)
; Remarks .......: Thanks you @jchd for the help :)
; Example .......: a_dataToArray("; extension = bfb")
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
func a_dataToArray($sData)
	$sData = StringRegExpReplace($sData, "\R;\s{2,}", "")
		if @error Then
			SetError( 0 , @error)
			Return False
		EndIf

	Local $aOutput = StringRegExp($sData, "([A-Za-z_ ]+)(?: = )(.+)", 3)
	If Not @error Then
		Local $aResult[UBound($aOutput) / 2][2]
		For $i = 0 To UBound($aResult) - 1
			$aResult[$i][0] = StringTrimLeft($aOutput[2 * $i],1)
			$aResult[$i][0] = StringRegExpReplace($aResult[$i][0], " ", "_", 0)
				if @error Then
					SetError( 2 , @error)
					Return False
				EndIf
			$aResult[$i][1] = $aOutput[2 * $i + 1]
		Next
		Return $aResult
	Else
		SetError( 1 , @error)
		Return False
	EndIf
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: n_arrayToVariable
; Description ...: Translate 2D Array into a variable with his value
; Syntax ........: n_arrayToVariable($aData[, $prefix = ""])
; Parameters ....: $aData               - An 2D array where [0][0] = VariableName AND [0][1] = Value
;                  $prefix              - [optional] A string value. Default is "". A prefix added into final variableName.
; Return values .: None
; Remarks .......: THE MOST IMPORTANT FUNCTION IN THIS FILE !!!! Lolz :D
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func n_arrayToVariable($aData,$sPrefix = "")
	For $i = 0 To UBound($aData) - 1
		Assign($sPrefix&$aData[$i][0],$aData[$i][1],2)
	Next
EndFunc


