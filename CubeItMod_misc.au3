#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.12.0
 Auteur:         Gr4ph0s

 Script function:
	Miscellaneous Function used for convert BFB File from KISSlicer - PRO to Cubex 3D printer

#ce ----------------------------------------------------------------------------

Local $sFile

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

Func b_createBackup($sFile)
	Return FileMove($sFile, $sFile & ".bak", 1)
EndFunc

Func f_createFile($sFile)
	Return FileOpen($sFile,9)
EndFunc
