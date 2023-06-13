@ECHO OFF
; Fallout3 speedcripple animation hardlink script - zlice
;
; Usage:
; put the kf files below in your Fallout3\Data directory with
; this script
; make sure you can access your USB drive
; set 'usbdir' to the drive letter of your drive
;

set meshdir=meshes\characters\_male\locomotion\hurt
set usbdir=PUT_YOUR_USB_DRIVE_LETTER_HERE:\speedcripple
echo %cd% | findstr "Fallout3\Data"
if errorlevel 1 (
  echo NOT IN Fallout3\Data DIRECTORY!!!
  GOTO:END
)
if not exist %usbdir%\ (
  echo CANNOT ACCESS USB %usbdir%
  echo IS DRIVE LETTER RIGHT?
  GOTO:END
)
mkdir %cd%\%meshdir%
mkdir %usbdir%
FOR %%x IN (mtfastbackward_hurt.kf mtfastleft_hurt.kf mtfastforward_hurt.kf mtfastright_hurt.kf) DO (
  move %%x %meshdir%\%%x >/nul
  mklink /h %usbdir%\%%x %cd%\%meshdir%\%%x >/nul
)
echo Complete
:END
