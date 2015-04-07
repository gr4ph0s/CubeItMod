#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.12.0
 Auteur:         Gr4ph0s

 Script function:
	Miscellaneous Function used for convert BFB File from KISSlicer - PRO to Cubex 3D printer

#ce ----------------------------------------------------------------------------
Local $sFile
func i_createBackup($sFile)
	return FileMove($sFile, $sFile & ".bak", 1)
EndFunc

