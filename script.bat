@echo off

REM Step 1: List folders with numbers
setlocal enabledelayedexpansion
set "folderIndex=0"
for /d %%d in (*) do (
    set /a "folderIndex+=1"
    echo !folderIndex! - "%%d"
)

REM Step 2: Pick content folder for the next command
set /p "folder=Enter the folder number: "

REM Step 3: Retrieve the selected folder name
set "selectedFolder="
set "folderIndex=0"
for /d %%d in (*) do (
    set /a "folderIndex+=1"
    if !folderIndex! equ %folder% (
        set "selectedFolder=%%d"
        goto :next
    )
)
echo Invalid folder number selected.
exit /b

:next
REM Step 4: Get frame rate
set /p "frameRate=Enter the frame rate (default is 2): "
if "%frameRate%"=="" set "frameRate=2"

REM Step 5: Get output name
set /p "outputName=Enter the output name (default is output): "
if "%outputName%"=="" set "outputName=output"

REM Step 6: Get scale input
set /p "scaleInput=Enter the scale input (default is 1000): "
if "%scaleInput%"=="" set "scaleInput=1000"

REM Step 7: Get pixelize input
set /p "pixelizeInput=Enter the pixelize input (default is 15): "
if "%pixelizeInput%"=="" set "pixelizeInput=15"

REM Step 8: Get noise input
set /p "noiseInput=Enter the noise input (default is 10): "
if "%noiseInput%"=="" set "noiseInput=10"

REM Step 9: Generate list.txt with all image file types
PowerShell -Command "Get-ChildItem -Path '%selectedFolder%' -Recurse -Include *.png,*.jpg,*.jpeg,*.gif,*.webp,*.bmp,*.tif,*.tiff,*.ico | ForEach-Object { 'file ''{0}''' -f $_.FullName } | Out-File -Encoding UTF8 list.txt"

REM Step 10: Convert list.txt from UTF-8 with BOM to UTF-8
powershell -Command "$content = Get-Content -Encoding UTF8 list.txt; Set-Content -Path list.txt -Value $content"

REM Step 11: Count the lines in list.txt
for /f %%a in ('type list.txt ^| find /c /v ""') do set "lineCount=%%a"

REM Step 12: Display selectable numeric list for output format
echo Available Output Formats:
echo 1 - GIF
echo 2 - H264
echo 3 - H265
echo 4 - H264NVIDIA
echo 5 - H265NVIDIA
echo 6 - VP8
echo 7 - VP9
echo 8 - AV1
set "outputFormat=1"
set /p "outputFormat=Enter the output format number (default is 1): "

REM Step 13: Map output format number to corresponding codec and output extension
if "%outputFormat%"=="2" (
    set "codec=libx264"
    set "outputExtension=mp4"
) else if "%outputFormat%"=="3" (
    set "codec=libx265"
    set "outputExtension=mp4"
) else if "%outputFormat%"=="4" (
    set "codec=h264_nvenc"
    set "outputExtension=mp4"
) else if "%outputFormat%"=="5" (
    set "codec=hevc_nvenc"
    set "outputExtension=mp4"
) else if "%outputFormat%"=="6" (
    set "codec=libvpx"
    set "outputExtension=webm"
) else if "%outputFormat%"=="7" (
    set "codec=libvpx-vp9"
    set "outputExtension=webm"
) else if "%outputFormat%"=="8" (
    set "codec=libaom-av1"
    set "outputExtension=webm"
) else (
    echo Invalid output format number selected. Defaulting to GIF.
    set "codec=gif"
    set "outputExtension=gif"
)

REM Step 14: Calculate the duration based on line count and frame rate
set /a "duration=lineCount / frameRate"

REM Step 15: Generate output file name
set "outputName=%outputName%.%outputExtension%"

REM Step 16: Generate output using ffmpeg with variables
ffmpeg -stream_loop -1 -f concat -safe 0 -i list.txt -loop 1 -i overlay.png -filter_complex "[0:v]scale=-1:%scaleInput%:force_original_aspect_ratio=decrease,pixelize=%pixelizeInput%:%pixelizeInput%,noise=alls=%noiseInput%:allf=t+u[bg];[bg][1:v]overlay=(W-w)/2:(H-h)/2:enable='between(t,0,%duration%)':shortest=1" -c:v %codec% -r %frameRate% -t %duration% %outputName%

REM Cleanup: Remove list.txt file
del list.txt

echo Conversion completed!
pause
