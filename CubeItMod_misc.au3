#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.12.0
 Auteur:         Gr4ph0s

 Fonction du Script :
	Modèle de Script AutoIt.

#ce ----------------------------------------------------------------------------
Local $sFile
func i_createBackup($sFile)
	return FileMove($sFile, $sFile & ".bak", 1)
EndFunc

