#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.12.0
 Auteur:         Gr4ph0s

 Script function:
	Function To read Data and Assign value with the main content of a BFB File from KISSlicer - PRO

#ce ----------------------------------------------------------------------------

;I will comment all the functions when I will finnish the managment of the main content
;So dont worry it will coming and sory if you understand nothing ^^'

;$aOption[0] = Extruder ID
;$aOption[1] = Temperature
;$aOption[2] = LayerObject
;$aOption[3] = WorkingMethod
;$aOption[4] = RPM
;$aOption[5] = head mm/s
;$aOption[6] = isFirstLayer
;$aOption[7] = isCurrentlyPrinting
;$aOption[8] = Mx08 RPM


; #FUNCTION# ====================================================================================================================
; Name ..........: f_CalculFForPerimeter
; Description ...: Calculate Speed in Perimeter mode.
; Syntax ........: f_CalculFForPerimeter()
; Return values .: return a float of the calculated speed
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func f_CalculFForPerimeter()
	Local $bed_roughness_mm,$bed_offset_z_mm,$layer_thickness_mm,$fiber_dia_mm,$extrusion_width_mm,$flowrate_tweak,$gain,$F
		$bed_roughness_mm = 	Eval("Pri_bed_roughness_mm")
		$bed_offset_z_mm = 		Eval("Pri_bed_offset_z_mm")
		$gain = 				Eval("Pri_ext_gain_"&$aOption[0])
		$layer_thickness_mm = 	Eval("Sty_layer_thickness_mm")
		$extrusion_width_mm = 	Eval("Sty_extrusion_width_mm")
		$fiber_dia_mm = 		Eval("Mat"&$aOption[0]&"_fiber_dia_mm")
		$flowrate_tweak = 		Eval("Mat"&$aOption[0]&"_flowrate_tweak")

		If $aOption[2] == $layer_thickness_mm + $bed_roughness_mm + $bed_offset_z_mm Then
			$F= Round(Round($aOption[8]) * ($fiber_dia_mm) ^ 2 / (11.82 * $extrusion_width_mm * $layer_thickness_mm * $flowrate_tweak * $gain),1 )
		Else
			$F = Round((Round($aOption[8]) * $layer_thickness_mm/($layer_thickness_mm + $bed_roughness_mm)) * ($fiber_dia_mm)^2 / (11.82 * $extrusion_width_mm * $layer_thickness_mm * $flowrate_tweak  * $gain),1)
		EndIf
		Return Number($F)
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: f_CalculFForSolid
; Description ...: Calculate Speed in Solid mode.
; Syntax ........: f_CalculFForSolid()
; Return values .: return a float of the calculated speed
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func f_CalculFForSolid()
	Local $bed_roughness_mm,$bed_offset_z_mm,$layer_thickness_mm,$fiber_dia_mm,$extrusion_width_mm,$flowrate_tweak,$gain,$F
		$bed_roughness_mm = 	Eval("Pri_bed_roughness_mm")
		$bed_offset_z_mm = 		Eval("Pri_bed_offset_z_mm")
		$gain = 				Eval("Pri_ext_gain_"&$aOption[0])
		$layer_thickness_mm = 	Eval("Sty_layer_thickness_mm")
		$extrusion_width_mm = 	Eval("Sty_extrusion_width_mm")
		$fiber_dia_mm = 		Eval("Mat"&$aOption[0]&"_fiber_dia_mm")
		$flowrate_tweak = 		Eval("Mat"&$aOption[0]&"_flowrate_tweak")

		If $aOption[2] == $layer_thickness_mm + $bed_roughness_mm + $bed_offset_z_mm Then
			$F= Round(Round($aOption[8]) * ($fiber_dia_mm) ^ 2 / (11.82 * $extrusion_width_mm * $layer_thickness_mm * $flowrate_tweak * $gain),1 )
		Else
			$F = Round((Round($aOption[8]) * $layer_thickness_mm/($layer_thickness_mm + $bed_roughness_mm)) * ($fiber_dia_mm)^2 / (11.82 * $extrusion_width_mm * $layer_thickness_mm * $flowrate_tweak  * $gain),1)
		EndIf
		Return Number($F)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: f_CalculFForLoop
; Description ...: Calculate Speed in Loop mode.
; Syntax ........: f_CalculFForLoop()
; Return values .: return a float of the calculated speed
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func f_CalculFForLoop()
	Local $bed_roughness_mm,$bed_offset_z_mm,$layer_thickness_mm,$fiber_dia_mm,$extrusion_width_mm,$flowrate_tweak,$gain,$F
		$bed_roughness_mm = 	Eval("Pri_bed_roughness_mm")
		$bed_offset_z_mm = 		Eval("Pri_bed_offset_z_mm")
		$gain = 				Eval("Pri_ext_gain_"&$aOption[0])
		$layer_thickness_mm = 	Eval("Sty_layer_thickness_mm")
		$extrusion_width_mm = 	Eval("Sty_extrusion_width_mm")
		$fiber_dia_mm = 		Eval("Mat"&$aOption[0]&"_fiber_dia_mm")
		$flowrate_tweak = 		Eval("Mat"&$aOption[0]&"_flowrate_tweak")

		If $aOption[2] == $layer_thickness_mm + $bed_roughness_mm + $bed_offset_z_mm Then
			$F= Round(Round($aOption[8]) * ($fiber_dia_mm) ^ 2 / (11.82 * $extrusion_width_mm * $layer_thickness_mm * $flowrate_tweak * $gain),1 )
		Else
			$F = Round((Round($aOption[8]) * $layer_thickness_mm/($layer_thickness_mm + $bed_roughness_mm)) * ($fiber_dia_mm)^2 / (11.82 * $extrusion_width_mm * $layer_thickness_mm * $flowrate_tweak  * $gain),1)
		EndIf
		Return Number($F)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: f_CalculFForLoop
; Description ...: Calculate Speed in Loop mode.
; Syntax ........: f_CalculFForLoop()
; Return values .: return a float of the calculated speed
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func a_GenerateG1($sLine,$aOutput)
	Local $aBuffer,$iX,$Y,$iZ,$iF
	$aBuffer = StringRegExp($sLine, "(?:G1 X)([\-0-9.]+)(?: Y)([\-0-9.]+)(?: Z)([\-0-9.]+)(?: F)([\-0-9.]+)", 3)
	$iX = Number($aBuffer[0])
	$iY = Number($aBuffer[1])
	$iZ = Number($aBuffer[2])
	$iF = Number($aBuffer[3])


	If StringInStr($aOption[3],"Perimeter Path") Or StringInStr($aOption[3],"Perimeter") Then
		$iF = i_CalculFForPerimeter()

	ElseIf StringInStr($aOption[3],"Solid Path") Or StringInStr($aOption[3],"Solid") Then
		$iF = i_CalculFForSolid()

	ElseIf $aOption[3] == StringInStr($aOption[3],"Loop Path") Or StringInStr($aOption[3],"Loop") Then
		$iF = i_CalculFForLoop()

	Else
		If Round($aOption[8]) == 1 Then
			$iF = Round ($iF/$aOption[8],1)
		Else
			$iF = Round (Round($aOption[8])*$iF/$aOption[8],1)
		EndIf
	EndIf

	_ArrayAdd($aOutput,"G1 X"&$iX&" Y"&$iY&"& Z"&$iZ&" F"&$iF)
	Return $aOutput
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: a_getContentDataBySearch
; Description ...:
; Syntax ........: a_getContentDataBySearch()
; Parameters ....:
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func a_getContentDataBySearch()
	Local $aDataToGet[0][2],$sLine,$iStartLine,$iEndLineLine,$i = 0
	Local $fFile = FileOpen($sFile)
	While $i <= $iFileLinesNumber
;~ 	While $y <= 1789
		$sLine = FileReadLine($sfile,$i)
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

	If StringInStr ($sLine,"BEGIN_LAYER_OBJECT") <> 0 Then
		$aBuffer = StringRegExp($sLine, "(\d+.\d+)", 3)
		$aBuffer = Number($aBuffer[0])
		$aOption[2] = $aBuffer
	EndIf

	If StringInStr ($sLine,"[head mm/s]") <> 0 Then
		$aBuffer = StringRegExp($sLine, "(?:\')(.+)(?:\', )(\d+.\d+)(?: \[RPM\]\, )(\d+.\d+)", 3)
		$aOption[3] = $aBuffer[0]
		$aOption[4] = $aBuffer[1]
		$aOption[5] = $aBuffer[2]
;~ 		_ArrayDisplay($aOption)
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

	If StringInStr ($sLine,"M103") <> 0 Then
		$aOption[6] = 1
		Return $aOutput
	EndIf

	If StringInStr ($sLine,"M227") <> 0 Then
		Return $aOutput
	EndIf

	If StringInStr ($sLine,"M227") <> 0 Then
		Return $aOutput
	EndIf

	If StringInStr ($sLine, "M"&$aOption[0]&"01") <> 0 Then
			$aOption[7] = 1
			_ArrayAdd($aOutput,$sLine)
			Return $aOutput
	EndIf

	If StringInStr ($sLine, "M"&$aOption[0]&"08") <> 0 Then
		$aBuffer = StringRegExp($sLine, "(?:M"&$aOption[0]&"08 S)([\-0-9.]+)", 3)
		$aOption[8] = number($aBuffer[0])

		_ArrayAdd($aOutput,"M"&$aOption[0]&"08 S"&string(Round($aOption[8])))
		Return $aOutput
	EndIf

	If StringInStr ($sLine,"G1") <> 0 Then
		If $aOption[6] == 1 Then
			_ArrayAdd($aOutput,"M103")
			$aOption[6] = 0
			$aOption[7] = 0
		EndIf
		If $aOption[7] == 0 Then
			_ArrayAdd($aOutput,$sLine)
		Else
			$aOutput = a_GenerateG1($sLine,$aOutput)
			Return $aOutput
		EndIf
		Return $aOutput
	EndIf



	_ArrayAdd($aOutput,$sLine)
	Return $aOutput
EndFunc


Func a_GenerateM227($aOutput)
	If $Sty_use_destring = 1 Then
		Local $P = int(Eval("Mat"&$aOption[0]&"_destring_prime")*2962)
		Local $S = int(Eval("Mat"&$aOption[0]&"_destring_suck")*2962)
		_ArrayAdd($aOutput,"M227 P"& $P &" S" & $S)
	EndIf
	Return $aOutput
EndFunc


Func a_GenerateM228($aOutput)
	If $Pri_fan_pwm = 1 Then
		Local $P = int(Eval("Mat"&$aOption[0]&"_sec_per_C_per_C")*2962)
		Local $S = int(Eval("Mat"&$aOption[0]&"_cost_per_cm3")*2962)
		_ArrayAdd($aOutput,"M228 P"& $P &" S" & $S)
	EndIf
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


func a_readContentData($iFirst,$iEnd)
	Local $aOutput[0], $sBuffer = ""
	For $i = 0 To ($iEnd - $iFirst) - 1
;~ 		$sBuffer = FileReadLine($sFile&".bak",$aLines[0][0]+$i) & @CRLF
		$sBuffer = FileReadLine($sFile,$iFirst+$i) & @CRLF
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