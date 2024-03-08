@echo off
setlocal

REM Set the log directory and file
set LOG_DIR=logs
set LOG_FILE=%LOG_DIR%\extract_layer_log.txt

REM Check and create log directory if it does not exist
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

REM Set the output directory for extracted AWS Layers
set OUTPUT_LAYERS_DIR=extracted_layers

REM Check and create the output directory if it does not exist
if not exist "%OUTPUT_LAYERS_DIR%" mkdir "%OUTPUT_LAYERS_DIR%"

set "DOCKER_DESKTOP_EXE=C:\Program Files\Docker\Docker\Docker Desktop.exe"

REM Check if Docker is already running
@REM docker version >nul 2>&1
docker version > temp.tmp 2>&1
if %ERRORLEVEL% neq 0 (
    echo Docker is not running. Starting Docker Desktop... >> %LOG_FILE%
    echo Docker is not running. Starting Docker Desktop...
    start "" "%DOCKER_DESKTOP_EXE%"
    timeout /T 10 >nul
)

REM Check if Docker is already running
docker version > temp.tmp 2>&1
if %ERRORLEVEL% neq 0 (
    echo Docker is still not running after trying to start Docker Desktop located at !DOCKER_DESKTOP_EXE!... >> %LOG_FILE%
    echo Docker is still not running after trying to start Docker Desktop located at !DOCKER_DESKTOP_EXE!...
    exit /b 1
)

del "temp.tmp"

REM Log Invocation Separator and Start Time
echo ------------------------------------------------------------------------------- >> %LOG_FILE%
echo New Invocation: [%date% %time%] >> %LOG_FILE%
echo ------------------------------------------------------------------------------- >> %LOG_FILE%

REM Check if the docker image name is passed as an argument
if "%~1"=="" (
    echo Error: Docker image name not provided. >> %LOG_FILE%
    echo Usage: %0 [Docker Image Name] >> %LOG_FILE%
    exit /b 1
)

REM Set variables
set DOCKER_IMAGE_NAME=%~1
set TEMP_CONTAINER_NAME=temp-container-%RANDOM%

echo Checking if Docker image "%DOCKER_IMAGE_NAME%" exists... >> %LOG_FILE%
REM Check if the Docker image exists
docker image inspect %DOCKER_IMAGE_NAME% >nul 2>&1
if not %ERRORLEVEL% == 0 (
    echo Error: Docker image "%DOCKER_IMAGE_NAME%" does not exist. >> %LOG_FILE%
    exit /b 1
)

echo Creating a temporary container "%TEMP_CONTAINER_NAME%" from image "%DOCKER_IMAGE_NAME%"... >> %LOG_FILE%
REM Create a temporary container from the specified Docker image
docker create --name %TEMP_CONTAINER_NAME% %DOCKER_IMAGE_NAME% >> %LOG_FILE% 2>&1

echo Copying lambda-layer.zip file from the temporary container to the current directory... >> %LOG_FILE%
REM Copy the lambda-layer.zip file from the temporary container to the current directory
docker cp %TEMP_CONTAINER_NAME%:/package/lambda-layer.zip %OUTPUT_LAYERS_DIR%/%DOCKER_IMAGE_NAME%.zip >> %LOG_FILE% 2>&1

echo Removing temporary container "%TEMP_CONTAINER_NAME%"... >> %LOG_FILE%
REM Remove the temporary container
docker rm %TEMP_CONTAINER_NAME% >> %LOG_FILE% 2>&1

echo Zip file extracted successfully. >> %LOG_FILE%

:end
endlocal
