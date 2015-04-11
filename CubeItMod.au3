#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=test.exe
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.12.0
 Auteur:         Gr4ph0s

 Script function:
	Converter BFB File from KISSlicer - PRO To Cubex 3D printer

#ce ----------------------------------------------------------------------------

#include <Array.au3>
#include <File.au3>
#include "CubeItMod_header.au3" ;All functions concerning the header file.
#include "CubeItMod_content.au3" ;All functions concerning the header file.
#include "CubeItMod_misc.au3" ;All miscellaneous functions.


Global $sFile = @ScriptDir&'/'&"testV15B117.bfb"
Global $fFile
Global $iFileLinesNumber = _FileCountLines ($sFile)
Global $aVersion = a_readVersion()

;~ b_createBackup($sFile)
;~ f_createFile($sFile)


if b_getHeaderData() Then
;~ 	MsgBox(0,"",$suppSet_support_inflate_mm)
Else
	MsgBox(0,@extended,@error)
EndIf

;All code bellow this line are temporary....

;~ Global $aDataToGet[0][3] ; Array for store.[0][0] = sFirstSetting. [0][1] = $sLastSetting. [0][2] = $sLastSetting. Look b_getSettings() for know the use of these variables.
;~ 	_ArrayAdd($aDataToGet, "; *** G-code Prefix ***|; *** Main G-code ***|contentHeader_")
;~ $test = a_getContentDataByName($aDataToGet)
;~ $test = a_readContentData($test)
;~ $test = a_setContentArrayData($test)
;~ $test2 = b_WriteData($sFile,$test)



;$aOption[0] = Extruder ID
;$aOption[1] = Temperature
;$aOption[2] = LayerObject
;$aOption[3] = WorkingMethod
;$aOption[4] = RPM
;$aOption[5] = head mm/s
;$aOption[6] = isFirstLayer
;$aOption[7] = isCurrentlyPrinting





$test = a_getContentDataBySearch()
$test = a_readContentData($test)
$test = a_setContentArrayData($test)
_ArrayDisplay($test)


