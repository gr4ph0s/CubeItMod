#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.12.0
 Auteur:         Gr4ph0s

 Script function:
	Function To read Data and calculated final XYZF value with the main content of a BFB File from KISSlicer - PRO

#ce ----------------------------------------------------------------------------

; #FUNCTION# ====================================================================================================================
; Name ..........: f_CalculFForPerimeter
; Description ...: Calculate Speed in Perimeter mode.
; Syntax ........: f_CalculFForPerimeter()
; Return values .: return a float of the calculated speed
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func f_CalculFForPerimeter()
	Local $F
	Local $bed_roughness_mm = 	Eval("Pri_bed_roughness_mm")
	Local $bed_offset_z_mm = 	Eval("Pri_bed_offset_z_mm")
	Local $gain = 				Eval("Pri_ext_gain_"&$iExtruderID)
	Local $layer_thickness_mm = Eval("Sty_layer_thickness_mm")
	Local $extrusion_width_mm = Eval("Sty_extrusion_width_mm")
	Local $fiber_dia_mm = 		Eval("Mat"&$iExtruderID&"_fiber_dia_mm")
	Local $flowrate_tweak = 	Eval("Mat"&$iExtruderID&"_flowrate_tweak")

	If $fLayerObject == $layer_thickness_mm + $bed_roughness_mm + $bed_offset_z_mm Then
		$F = Round(Round($fMx08RPM) * ($fiber_dia_mm) ^ 2 / (11.82 * $extrusion_width_mm * $layer_thickness_mm * $flowrate_tweak * $gain),1 )
	Else
		$F = Round((Round($fMx08RPM) * $layer_thickness_mm/($layer_thickness_mm + $bed_roughness_mm)) * ($fiber_dia_mm)^2 / (11.82 * $extrusion_width_mm * $layer_thickness_mm * $flowrate_tweak  * $gain),1)
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
	Local $F
	Local $bed_roughness_mm = 	Eval("Pri_bed_roughness_mm")
	Local $bed_offset_z_mm = 	Eval("Pri_bed_offset_z_mm")
	Local $gain = 				Eval("Pri_ext_gain_"&$iExtruderID)
	Local $layer_thickness_mm = Eval("Sty_layer_thickness_mm")
	Local $extrusion_width_mm = Eval("Sty_extrusion_width_mm")
	Local $fiber_dia_mm = 		Eval("Mat"&$iExtruderID&"_fiber_dia_mm")
	Local $flowrate_tweak = 	Eval("Mat"&$iExtruderID&"_flowrate_tweak")

	If $fLayerObject == $layer_thickness_mm + $bed_roughness_mm + $bed_offset_z_mm Then
		$F = Round(Round($fMx08RPM) * ($fiber_dia_mm) ^ 2 / (11.82 * $extrusion_width_mm * $layer_thickness_mm * $flowrate_tweak * $gain),1 )
	Else
		$F = Round((Round($fMx08RPM) * $layer_thickness_mm/($layer_thickness_mm + $bed_roughness_mm)) * ($fiber_dia_mm)^2 / (11.82 * $extrusion_width_mm * $layer_thickness_mm * $flowrate_tweak  * $gain),1)
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
	Local $F
	Local $bed_roughness_mm = 	Eval("Pri_bed_roughness_mm")
	Local $bed_offset_z_mm = 	Eval("Pri_bed_offset_z_mm")
	Local $gain = 				Eval("Pri_ext_gain_"&$iExtruderID)
	Local $layer_thickness_mm = Eval("Sty_layer_thickness_mm")
	Local $extrusion_width_mm = Eval("Sty_extrusion_width_mm")
	Local $fiber_dia_mm = 		Eval("Mat"&$iExtruderID&"_fiber_dia_mm")
	Local $flowrate_tweak = 	Eval("Mat"&$iExtruderID&"_flowrate_tweak")

	If $fLayerObject == $layer_thickness_mm + $bed_roughness_mm + $bed_offset_z_mm Then
		$F = Round(Round($fMx08RPM) * ($fiber_dia_mm) ^ 2 / (11.82 * $extrusion_width_mm * $layer_thickness_mm * $flowrate_tweak * $gain),1 )
	Else
		$F = Round((Round($fMx08RPM) * $layer_thickness_mm/($layer_thickness_mm + $bed_roughness_mm)) * ($fiber_dia_mm)^2 / (11.82 * $extrusion_width_mm * $layer_thickness_mm * $flowrate_tweak  * $gain),1)
	EndIf
	Return Number($F)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: f_CalculFForPerimeterV15B117
; Description ...: Calculate Speed in Loop mode for ; version 1.5 Beta 1.17 Win64
; Syntax ........: f_CalculFForPerimeterV15B117()
; Return values .: return a float of the calculated speed
; Author ........: Gr4ph0s
; Link ..........: http://gr4ph0s.free.fr/
; ===============================================================================================================================
Func f_CalculFForPerimeterV15B117()
	Local $F
	Local $bed_roughness_mm = 	Eval("Pri_bed_roughness_mm")
	Local $bed_offset_z_mm = 	Eval("Pri_bed_offset_z_mm")
	Local $gain = 				Eval("Pri_ext_gain_"&$iExtruderID)
	Local $layer_thickness_mm = Eval("Sty_layer_thickness_mm")
	Local $extrusion_width_mm = Eval("Sty_extrusion_width_mm")
	Local $fiber_dia_mm = 		Eval("Mat"&$iExtruderID&"_fiber_dia_mm")
	Local $flowrate_tweak = 	Eval("Mat"&$iExtruderID&"_flowrate_tweak")

	If $fLayerObject == $layer_thickness_mm + $bed_roughness_mm + $bed_offset_z_mm Then
		$F = Round(Round($fMx08RPM) * ($fiber_dia_mm) ^ 2 / (11.82 * $extrusion_width_mm * $layer_thickness_mm * $flowrate_tweak * $gain),1 )
	Else
		$F = Round((Round($fMx08RPM) * $layer_thickness_mm/($layer_thickness_mm + $bed_roughness_mm)) * ($fiber_dia_mm)^2 / (11.82 * $extrusion_width_mm * $layer_thickness_mm * $flowrate_tweak  * $gain),1)
	EndIf
	Return Number($F)
EndFunc

Func s_GenerateM227()
	If $Sty_use_destring = 1 Then
		Local $iP = int(Eval("Mat"&$iExtruderID&"_destring_prime")*2962)
		Local $iS = int(Eval("Mat"&$iExtruderID&"_destring_suck")*2962)
		;We check all data is different of 0
		If $iP <> 0 And $iS <> 0 Then
			Return "M227 P"& $iP &" S" & $iS
		Else
			SetError(0,0,False)
		EndIf
	EndIf
EndFunc

Func s_GenerateM228()
	If $Pri_fan_pwm = 1 Then
		Local $iP = int(Eval("Mat"&$iExtruderID&"_sec_per_C_per_C")*2962)
		Local $iS = int(Eval("Mat"&$iExtruderID&"_cost_per_cm3")*2962)

		Return "M228 P"& $iP &" S" & $iS
	EndIf
EndFunc

Func s_GenerateM228V15B117()
	If $Pri_fan_pwm = 1 Then
		Local $iP = int(Eval("Mat"&$iExtruderID&"_destring_speed_mm_per_s")*2962)
		Local $iS = int(Eval("Mat"&$iExtruderID&"_cost_per_cm3")*2962)

		;We check all data is different of 0
		If $iP <> 0 And $iS <> 0 Then
			Return "M228 P"& $iP &" S" & $iS
		Else
			SetError(0,0,False)
		EndIf
	EndIf
EndFunc