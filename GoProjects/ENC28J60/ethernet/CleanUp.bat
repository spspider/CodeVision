@echo off
REM Remove files generated by compiler
echo Removing *.$$$ files...

del *.$$$ /f /q

echo Removing *.bkx files...
del *.bkx /f /q
echo.

echo Removing *.cod files...
del *.cod /f /q
echo.

echo Removing *.hex files...
del *.hex /f /q
echo.

echo Removing .\Source\*.err files...
del .\source\*.err /f /q
echo.

echo Removing *.i files...
del *.i /f /q
echo.

echo Removing *.obj files...
del .\Source\*.obj /f /q
echo.

echo Removing .\Source\*.o files...
del .\Source\*.o /f /q
echo.

echo Removing *.rlf files...
del .\Source\*.rlf /f /q
echo.

echo Removing *.sym files...
del *.sym /f /q
echo.

echo Removing *.sdb files...
del .\Source\*.sdb /f /q
echo.

echo Removing *.lst files...
del .\Source\*.lst /f /q
echo.

echo Removing *.wat files...
del *.wat /f /q
echo.

echo Removing *.cce files...
del .\Source\*.cce /f /q
echo .

echo Removing *.lde files...
del *.lde /f /q
echo.

echo Removing *.hxl files...
del *.hxl /f /q
echo.

echo Removing *.i files...
del .\Source\*.i /f /q
echo.

echo Removing untitled.mcw file...
del untitled.mcw /f /q
echo.

echo Cleaning up Microchip Ethernet Discoverer files...
rmdir ".\Microchip Ethernet Discoverer\publish" /s /q
rmdir ".\Microchip Ethernet Discoverer\obj" /s /q
rmdir ".\Microchip Ethernet Discoverer\bin\Debug" /s /q
echo.

echo Removing *.map files...
del *.map /f /q
echo.

echo Done.