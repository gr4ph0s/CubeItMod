#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.12.0
 Auteur:         Gr4ph0s

 Script function:
	Miscellaneous Function used for convert BFB File from KISSlicer - PRO to Cubex 3D printer

#ce ----------------------------------------------------------------------------
Local $sFile
Func b_createBackup($sFile)
	Return FileMove($sFile, $sFile & ".bak", 1)
EndFunc

Func f_createFile($sFile)
	Return FileOpen($sFile,9)
EndFunc
