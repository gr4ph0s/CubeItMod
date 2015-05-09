#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.12.0
 Auteur:         Gr4ph0s

 Script function:
	Function To read Data and calculated final XYZF value with the main content of a BFB File from KISSlicer - PRO

#ce ----------------------------------------------------------------------------

;Some options used for calculated the final value.
Dim $iExtruderID, $iTemperature, $fLayerObject, $sWorkingMethod, $fRPM, $fHeadmm_s, $bIsBeforeExtruderOn, $bIsCurrentlyPrinting, $fMx08RPM
Dim $bIsFirstM108 = True, $bIsFirstM542 = True

; #FUNCTION# ====================================================================================================================
; Name ..........: a_GenerateFinalArray
; Description ...: Generate the final Data
; Syntax ........: a_GenerateFinalArray($sLine)
; Parameters ....: $sLine               - A string value.
; Return values .: 1D Array. Return an array contening the data to be write.
; Author ........: Gr4ph0s
; Remarks .......: $aOutput is a buffer who store data it will be write in the same order as you order for exemple $aOutput[0] will be write before $aOutput[1]
;				 : By default it will return the current line excepted in some case ;)
;				 : I was pretty lazy to do all the check during this function... So if you want to do it do it plz... :D
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func a_GenerateFinalArray($sLine)
	Local $aOutput[0],$aBuffer
	If StringInStr ($sLine,"M"&$iExtruderID&"04") <> 0 And $iTemperature <> 0 Then
		If $iTemperature == 0 Then
			_ArrayAdd($aOutput,$sLine)
		Else
			$bIsFirstM108 = True
			_ArrayAdd($aOutput,$sLine) ; We add the current line to the file.
			; Look into CubeItMod_Calcul for this function ;)
				_ArrayAdd($aOutput,s_GenerateM227())
			; Look into CubeItMod_Calcul for this function ;)
			;$aVersion[0] = Version and $aVersion[1] = Beta Version ;)
			If $aVersion[0] = 1.5 AND $aVersion[1] = 1.17 Then
				_ArrayAdd($aOutput,s_GenerateM228V15B117())
			Else
				_ArrayAdd($aOutput,s_GenerateM228())
			EndIf
		EndIf
		return $aOutput
	EndIf

;~ 	If StringInStr ($sLine,"M542") <> 0 Then
;~ 		If $bIsFirstM542 Then
;~ 			$bIsFirstM542 = False
;~ 			Return $aOutput
;~ 		Else
;~ 			_ArrayAdd($aOutput,"M542")
;~ 			$bIsFirstM108 = True
;~ 			Return $aOutput
;~ 		EndIf
;~ 	EndIf


	If StringInStr ($sLine,"M103") <> 0 Then
		$bIsBeforeExtruderOn = 1
		_ArrayAdd($aOutput,$sLine)
		Return $aOutput
	EndIf

	If StringInStr ($sLine,"M227") <> 0 Then
		Return $aOutput
	EndIf

	If StringInStr ($sLine, "M"&$iExtruderID&"01") <> 0 Then
		$bIsCurrentlyPrinting = 1
		_ArrayAdd($aOutput,$sLine)
		Return $aOutput
	EndIf

	If StringInStr ($sLine, "M"&$iExtruderID&"08") <> 0 Then
		$aBuffer = StringRegExp($sLine, "(?:M"&$iExtruderID&"08 S)([\-0-9.]+)", 3)
		$fMx08RPM = number($aBuffer[0])
		_ArrayAdd($aOutput,"M"&$iExtruderID&"08 S"&string(Round($fMx08RPM)))
		If $bIsFirstM108 Then
			_ArrayAdd($aOutput,"M103")
			$bIsFirstM108 = False
		EndIf
		Return $aOutput
	EndIf

	If StringInStr ($sLine,"G1") <> 0 Then
		;in some case G1 lines Don't change.After M103 then Dont change And if is not printing Dont change.
		If $bIsBeforeExtruderOn == 1 Then
			$bIsBeforeExtruderOn = 0
			$bIsCurrentlyPrinting = 0
		EndIf
		If $bIsCurrentlyPrinting == 0 Then
			_ArrayAdd($aOutput,$sLine)
		Else
			_ArrayAdd($aOutput,$sLine)
;~ 			$aOutput = a_GenerateG1($sLine,$aOutput)
			Return $aOutput
		EndIf
		Return $aOutput
	EndIf

	_ArrayAdd($aOutput,$sLine)
	Return $aOutput
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: b_GetOption
; Description ...: Generate option based on Line started ;
; Syntax ........: b_GetOption($sLine)
; Parameters ....: $sLine               - A string value. The current line readed. Normally it's start by a ;
; Return values .: boolean, True if data are generated.
; 				 : boolean, False if no data updated but that can happend
; Remarks .......: Pretty easy function. Plz keep the same format and use Regex if you don't know what is it send me a mail ;)
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func b_GetOption($sLine)
	Local $aBuffer

	If StringInStr ($sLine,"Warming Extruder") <> 0 Then
		$aBuffer = StringRegExp($sLine, "(\d+)", 3)
		$iExtruderID = $aBuffer[0]
		$iTemperature = $aBuffer[1]
		Return True
	EndIf

	If StringInStr ($sLine,"Cooling Extruder") <> 0 Then
		$aBuffer = StringRegExp($sLine, "(\d+)", 3)
		$iExtruderID = $aBuffer[0]
		$iTemperature = $aBuffer[1]
		Return True
	EndIf

	If StringInStr ($sLine,"BEGIN_LAYER_OBJECT") <> 0 Then
		$aBuffer = StringRegExp($sLine, "(\d+.\d+)", 3)
		$aBuffer = Number($aBuffer[0])
		$fLayerObject = $aBuffer
		Return True
	EndIf

	If StringInStr ($sLine,"[head mm/s]") <> 0 Then
		$aBuffer = StringRegExp($sLine, "(?:\')(.+)(?:\', )(\d+.\d+)(?: \[RPM\]\, )(\d+.\d+)", 3)
		$sWorkingMethod = $aBuffer[0]
		$fRPM = $aBuffer[1]
		$fHeadmm_s = $aBuffer[2]
		Return True
	EndIf

	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: a_GenerateG1
; Description ...: Calculate the new XYZF and add it to the final output array.
; Syntax ........: a_GenerateG1($sLine, $aOutput)
; Parameters ....: $sLine               - A string value. Corresponding to the G1 Lines.
;                  $aOutput             - An array contening the data converted.
; Return values .: return an array with the current lines with the correct value
; 				 : False & @error = 0 & @extended = 0 => Working Method is null.
; 				 : False & @error = 1 & @extended = Error & Extended of StringRegExp
; 				 : False & @error = 2 & @extended = Current line processed => X = 0
; 				 : False & @error = 3 & @extended = Current line processed => Y = 0
; 				 : False & @error = 4 & @extended = Current line processed => Z = 0
; 				 : False & @error = 5 & @extended = Current line processed => F = 0
; 				 : False & @error = 6 & @extended = look _ArrayAdd error
; Remarks .......: Keep it simple ;) If you add new WorkingMethod then Add a function for calculed ;)
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func a_GenerateG1($sLine,$aOutput)
	;We check if the working method isn't null if yes you got a problem ! :p
	If StringLen($sWorkingMethod) == 0 Then SetError(0,0,False)

	Local $aBuffer,$iX,$Y,$iZ,$iF
	$aBuffer = StringRegExp($sLine, "(?:G1 X)([\-0-9.]+)(?: Y)([\-0-9.]+)(?: Z)([\-0-9.]+)(?: F)([\-0-9.]+)", 3) ;get X Y Z F
	If @error Then SetError(1,"Error code : "&@error&" & Extended : "&@extended,False)
	$iX = Number($aBuffer[0])
	$iY = Number($aBuffer[1])
	$iZ = Number($aBuffer[2])
	$iF = Number($aBuffer[3])

	If b_getWorkingMethod("Perimeter Path") Or b_getWorkingMethod("Perimeter") Then
		;Just an exemple for make different calcul based on the version of the file.
		;$aVersion[0] = Version and $aVersion[1] = Beta Version ;)
		If $aVersion[0] = 1.5 AND $aVersion[1] = 1.17 Then
			$iF = f_CalculFForPerimeterV15B117()
		Else
			$iF = f_CalculFForPerimeter()
		EndIf

	ElseIf b_getWorkingMethod("Solid Path") Or b_getWorkingMethod("Solid") Then
		$iF = f_CalculFForSolid()

	ElseIf b_getWorkingMethod("Loop Path") Or b_getWorkingMethod("Loop") Then
		$iF = f_CalculFForLoop()

	EndIf

	;check if not 0, For Z don't make an error if first Layer Object = 0
	If $iX == 0 Then SetError(2,$sLine,False)
	If $iY == 0 Then SetError(3,$sLine,False)
	If $iZ == 0 And $fLayerObject <> 0 Then SetError(4,$sLine,False)
	If $iF == 0 Then SetError(5,$sLine,False)

	_ArrayAdd($aOutput,"G1 X"&$iX&" Y"&$iY&" Z"&$iZ&" F"&$iF)
	If @error Then SetError(6,@error,False)
	Return $aOutput
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: b_getWorkingMethod
; Description ...: A Simple function for check the working method
; Syntax ........: b_getWorkingMethod($sToSearch)
; Parameters ....: $sToSearch           - A string value to search into the working method
; Return values .: Boolean, True if it's matching
; 				 : False if not matching
; Remarks .......: I Did it for clean a_GenerateG1 and don't have each time an iF line who do 3km ;)
; Related .......: a_GenerateG1()
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func b_getWorkingMethod($sToSearch)
	If StringInStr($sWorkingMethod,$sToSearch) Then
		Return True
	Else
		Return False
	EndIf
EndFunc

Func a_getAndWriteData()
	Local $aLines,$aReadedData
	$aLines = a_getLinesDataBySearch()
	If Not IsArray($aLines) Then SetError(0,@error,False)
	For $i = 0 to UBound($aLines)-1
		$aReadedData = a_readContentData($aLines[$i][0],$aLines[$i][1])
		If Not IsArray($aReadedData) Then SetError(1,@error,False)
		$aFinalData = a_setContentArrayData($aReadedData)
		If Not IsArray($aFinalData) Then SetError(2,@error,False)
		$bfinal = b_WriteData($aFinalData)
		If Not $bfinal Then SetError(3,@error,False)
	Next
		Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: a_getLinesDataBySearch
; Description ...: Get The lines of each Layer.
; Syntax ........: a_getLinesDataBySearch()
; Return values .: Array, contening each layer [x][0] Start of Layer [x][1] End of layer
; 				 : False & @error = 0 & @extended = 0 => Can't open the file
; 				 : False & @error = 1 & @extended = @error of FileReadLine
; 				 : False & @error = 2 & @extended = @error of _ArrayAdd
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func a_getLinesDataBySearch()
	Local $aDataToGet[0][2],$sLine,$iStartLine,$iEndLineLine,$i = 0
;~ 	Local $fFile = FileOpen($sFile)
	Local $fFile = FileOpen($sFile&".bak")
	If $fFile == -1 Then SetError(0,0,False)
		;Begin Search for prefix
		While $i <= $iFileLinesNumber
		$sLine = FileReadLine($fFile)
			If @error Then SetError(1,@error,False)
			If StringInStr ($sLine,"; *** G-code Prefix ***") <> 0 Then
				$iStartLine = $i
			EndIf
			If StringInStr ($sLine,"; *** Main G-code ***") <> 0 Then
				$iEndLineLine = $i
				_ArrayAdd($aDataToGet,$iStartLine&"|"&$iEndLineLine)
				If @error Then SetError(2,@error,False)
				ExitLoop
			EndIf
			$i += 1
		WEnd
		;End Search for prefix

		;Begin Search for content
		While $i <= $iFileLinesNumber
		$sLine = FileReadLine($fFile)
			If @error Then SetError(1,@error,False)
			If StringInStr ($sLine,"; Guaranteed same extruder") <> 0 Then
					ExitLoop
			EndIf
			If StringInStr ($sLine,"; BEGIN_LAYER_OBJECT") <> 0 Then
				$iStartLine = $i
			EndIf
			If StringInStr ($sLine,"; END_LAYER_OBJECT ") <> 0 Then
				$iEndLineLine = $i
				_ArrayAdd($aDataToGet,$iStartLine&"|"&$iEndLineLine)
				If @error Then SetError(2,@error,False)
			EndIf
			$i += 1
		WEnd
		;End Search for content

		;Begin Search for suffix
		While $i <= $iFileLinesNumber
		$iStartLine = $iEndLineLine + 1
		$sLine = FileReadLine($fFile)
			If @error Then SetError(1,@error,False)
			If StringInStr ($sLine,"Estimated Build Time") <> 0 Then
				$iEndLineLine = $i
				_ArrayAdd($aDataToGet,$iStartLine&"|"&$iEndLineLine)
				If @error Then SetError(2,@error,False)
			EndIf
			$i += 1
		WEnd
		;End Search for suffix
	Return $aDataToGet
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: a_setContentArrayData
; Description ...: Read data from $aReadedData[0] to $aReadedData[1]
; Syntax ........: a_setContentArrayData($aReadedData)
; Parameters ....: $aReadedData         - An array of string contening the data to be read.
; 				 : False & @error = 1 & @extended = 0 => 0 Options get. But dat can be normal so don't worry about it ;)
; 				 : False & @error = 2 & @extended = 0 => The final Array is not an array...
; 				 : False & @error = 3 & @extended = 0 => Look _ArrayAdd Error
; Return values .: Array contening the data to write in the final file.
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func a_setContentArrayData($aReadedData)
	Local $aOutput[0],$aBuffer
	;We set data before first layer.
	$bIsBeforeExtruderOn = 1
	$bIsCurrentlyPrinting = 1



	For $i = 0 To UBound($aReadedData) - 1
		;Check if the line is starting by a ;
		If Asc($aReadedData[$i]) == 59 Then
			;If the line start by a ; that mean its only an option and we don't need it in the final file.
			If Not b_GetOption($aReadedData[$i]) Then SetError(1,0,False)
		Else
			;Generate the final array
			$aBuffer = a_GenerateFinalArray($aReadedData[$i])
			If Not IsArray($aBuffer) Then SetError(2,0,False)
			For $y = 0 To UBound($aBuffer)-1
				_ArrayAdd($aOutput,$aBuffer[$y])
				If @error Then SetError(3,@error,False)
			Next
		EndIf
	Next

	Return $aOutput
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: b_WriteData
; Description ...: Write data to the final file :)
; Syntax ........: b_WriteData($aData)
; Parameters ....: $aData               - An array of String corresponding to each line to write in the final file.
; Return values .: Boolean, True if success
; Return values .: Boolean, False if fail
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func b_WriteData($aData)
	$fFile = FileOpen($sFile,9)
	for $i = 0 to UBound($aData)-1
		FileWrite($fFile,StringRegExpReplace($aData[$i], "\r\n|\r|\n", "")&@CRLF)
		If @error Then SetError(0,@error&" line: "&$i,False)
	Next
	Return True
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: a_readContentData
; Description ...: Read Data between 2 lines
; Syntax ........: a_readContentData($iFirst, $iEnd)
; Parameters ....: $iFirst              - An integer value.
;                  $iEnd                - An integer value.
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func a_readContentData($iFirst,$iEnd)
	Local $aOutput[0], $sBuffer = ""
;~ 	Local $fFile = FileOpen($sFile)
	Local $fFile = FileOpen($sFile&".bak")
	FileReadLine($fFile,$iFirst)

	For $i = 0 To ($iEnd - $iFirst)
		$sBuffer = FileReadLine($fFile) & @CRLF
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