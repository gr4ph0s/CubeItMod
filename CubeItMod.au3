#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=test.exe
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;!Achete Boite cc maitre 200k/u Appro +1 2,5M/u au vivi :)

#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.12.0
 Auteur:         Gr4ph0s

 Script function:
	Converter BFB File from KISSlicer - PRO To Cubex 3D printer

#ce ----------------------------------------------------------------------------
$timer = TimerInit()
#include <Array.au3>
#include <File.au3>
#include "CubeItMod_header.au3" ;All functions concerning the header file.
#include "CubeItMod_content.au3" ;All functions concerning the header file.
#include "CubeItMod_calcul.au3" ;All functions concerning the header file.
#include "CubeItMod_misc.au3" ;All miscellaneous functions.


Global $sFile = FileOpenDialog("Select your bfb File",@ScriptDir & "\","BFB Files (*.bfb)",3)
If @error Then
	MsgBox(48, "", "No file(s) were selected.")
	Exit
EndIf
Global $iFileLinesNumber = _FileCountLines ($sFile)
Global $aVersion = a_readVersion()
b_createBackup($sFile)


if b_getHeaderData() Then
	if a_getAndWriteData() Then
		MsgBox(0,"Succes","File created")
	Else
		MsgBox(0,@extended,@error)
	EndIf
Else
	MsgBox(0,@extended,@error)
EndIf





