@echo off
setlocal

@REM WORK IN PROGRESS. Last time I ran it did not work, and gave Python errors internal to the Docker container. 
@REM    When I uploaded the Lambda Layers to AWS however they worked correctly with the most up to date version.


REM Check if the docker image name is passed as an argument
if "%~1"=="" (
    echo Error: Docker image name not provided.
    echo Usage: %0 [Docker Image Name]
    exit /b 1
)

REM Set variables
set DOCKER_IMAGE_NAME=%~1
set OUTPUT_FILE=versions.log

REM Check if the Docker image exists
docker image inspect %DOCKER_IMAGE_NAME% >nul 2>&1
if not %ERRORLEVEL% == 0 (
    echo Error: Docker image "%DOCKER_IMAGE_NAME%" does not exist.
    exit /b 1
)

REM Run a command in the Docker container to print the versions of boto3 and langchain
docker run --rm %DOCKER_IMAGE_NAME% python -c "import boto3; import langchain; print(f'boto3 version: {boto3.__version__}'); print(f'langchain version: {langchain.__version__}')" > %OUTPUT_FILE%

echo Versions logged to %OUTPUT_FILE%.

:end
endlocal
