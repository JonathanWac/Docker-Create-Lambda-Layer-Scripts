@echo off
setlocal

REM Set the log file directory and name
set LOG_DIR=logs
set LOG_FILE=%LOG_DIR%\docker_build_extract_log.txt

REM Check if the logs directory exists, if not, create it
if not exist "%LOG_DIR%" (
    mkdir "%LOG_DIR%"
)

REM Log Invocation Separator and Start Time
echo ------------------------------------------------------------------------------- >> %LOG_FILE%
echo New Invocation: [%date% %time%] >> %LOG_FILE%
echo ------------------------------------------------------------------------------- >> %LOG_FILE%

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

REM Log start time
echo [%date% %time%] Starting build and extract process >> %LOG_FILE%

REM Check if the docker image name and Dockerfile path are provided as arguments
if "%~1"=="" (
    echo Error: Docker image name not provided. >> %LOG_FILE%
    echo Usage: %0 [Docker Image Name] [Path to Dockerfile] >> %LOG_FILE%
    echo Usage: %0 [Docker Image Name] [Path to Dockerfile]
    goto end
)

if "%~2"=="" (
    echo Error: Path to Dockerfile not provided. >> %LOG_FILE%
    echo Usage: %0 [Docker Image Name] [Path to Dockerfile] >> %LOG_FILE%
    echo Usage: %0 [Docker Image Name] [Path to Dockerfile]
    goto end
)

REM Set variables
set DOCKER_IMAGE_NAME=%~1
set DOCKERFILE_PATH=%~2

REM Build the Docker image from the Dockerfile and log output
echo Building Docker image "%DOCKER_IMAGE_NAME%" from "%DOCKERFILE_PATH%"... >> %LOG_FILE%
docker build -t %DOCKER_IMAGE_NAME% -f %DOCKERFILE_PATH% . >> %LOG_FILE% 2>&1

REM Check if docker build was successful and log output
if not %ERRORLEVEL% == 0 (
    echo Error: Docker image "%DOCKER_IMAGE_NAME%" failed to build. >> %LOG_FILE%
    goto end
)

REM Call the extract-layer.bat script with the name of the built docker image and log output
echo Extracting zip file from Docker image "%DOCKER_IMAGE_NAME%"... >> %LOG_FILE%
call extract-layer.bat %DOCKER_IMAGE_NAME% >> %LOG_FILE% 2>&1

if not %ERRORLEVEL% == 0 (
    echo Error: Failed to extract zip file from Docker image "%DOCKER_IMAGE_NAME%". >> %LOG_FILE%
    goto end
)

echo Successfully built and extracted zip file from "%DOCKER_IMAGE_NAME%". >> %LOG_FILE%
echo [%date% %time%] Build and extract process completed successfully. >> %LOG_FILE%

:end
endlocal
