@echo off

echo ========================================
echo    Michelle1574's Downloader Creator
echo ========================================

echo Please wait. Checking for updates.

set "url=https://raw.githubusercontent.com/michelle1574/downloader-maker/main/version-downloader.txt"
set "batfileversion=public-1.1"
set "temp_file=temp.txt"

curl "%url%" -o "%temp_file%"

set /p content=<"%temp_file%"

rem Remove leading and trailing spaces from both strings before comparison
for /f "tokens=* delims= " %%a in ("!content!") do set "content=%%a"
for /f "tokens=* delims= " %%b in ("%batfileversion%") do set "batfileversion=%%b"

if "!batfileversion!"=="!content!" (
    echo Is up to date, continuing.
    goto main
) else (
    echo Is out of date, would you like to update from GitHub?
    choice /c YN /m "Enter Y for Yes or N for No: "
    if errorlevel 2 (
        echo You chose not to update. Continuing with the current version.
        goto main
    ) else (
        echo You chose to update. Proceeding with the update.
        curl "https://github.com/michelle1574/downloader-maker/raw/main/downloader.bat" -o "downloader-updated.bat" > nul
        if errorlevel 1 (
            echo Failed to download the updated executable. Please try again later.
            pause
            exit
        ) else (
            echo Update complete. Please wait as the new version opens.
            cls
            set "variablefortemp=%random%-temp.bat"
            echo @echo off >> "%variablefortemp%"
            echo del downloader.bat >> "%variablefortemp%"
            echo ren downloader-updated.bat downloader.bat >> "%variablefortemp%"
            echo call downloader.bat >> "%variablefortemp%"
            del "%temp_file%"
            call "%variablefortemp%"
        )
    )
)


del "%temp_file%"

:main

set /p "initialbatfilename=Please enter the name for the downloader: "
set /p "outputfolder=Please enter the output folder name (for the script-downloaded files): "
set /p "afterdownloadnote=If you want any notes then please enter them here (they will be displayed after download): "

set "batfilename=%initialbatfilename%.bat"
echo @echo off > "%batfilename%"
echo echo ======================================== >> "%batfilename%"
echo echo        Michelle1574's Downloader >> "%batfilename%"
echo echo ======================================== >> "%batfilename%"
echo md "%outputfolder%" 2>nul >> "%batfilename%"
echo cd /d %%~dp0 >> "%batfilename%"
echo echo Downloading files >> "%batfilename%"

:start
cls

echo Please select an option:
echo 1. Add an URL
echo 2. Compile your .bat file
choice /c 12

if errorlevel 2 (
    goto compile
) else if errorlevel 1 (
    goto addurl
) else (
    goto EOF
)

:addurl
set "urltoadd="
set /p "urltoadd=Enter URL to download (leave empty to finish): "
if not "%urltoadd%"=="" (
    for /f "tokens=*" %%F in ("%urltoadd%") do (
        set "filename=%%~nxF"
        echo curl -o "%outputfolder%\%%~nxF" "%%F" >> "%batfilename%"
    )
    goto addurl
)

:compile
echo echo Files downloaded. >> "%batfilename%"
echo echo Note: "%afterdownloadnote%" >> "%batfilename%"
echo pause >> "%batfilename%"
echo exit >> "%batfilename%"
echo Your batch file is complete!
pause
goto EOF

:EOF
