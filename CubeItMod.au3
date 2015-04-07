#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=test.exe
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.12.0
 Auteur:         Gr4ph0s

 Fonction du Script :
	Modèle de Script AutoIt.

#ce ----------------------------------------------------------------------------

; Début du script - Ajouter votre code ci-dessous.
#include <Array.au3>
#include <File.au3>
#include "CubeItMod_header.au3" ;All function concerning the header file.
#include "CubeItMod_misc.au3" ;All miscellaneous function.


Global $sFile = "testV15B117.bfb"
Global $iFileLinesNumber = _FileCountLines ($sFile)
Global $aVersion = a_readVersion()


if b_getHeaderData() Then
	MsgBox(0,"",$suppSet_support_inflate_mm)
Else
	MsgBox(0,@extended,@error)
EndIf


Func bed_roughness_mm

EndFunc
