# Project Title

This project contains scripts for building Docker images, extracting layers from Docker images, and printing versions of specific packages in a Docker image.

## Scripts

### `build-extract-layer.bat`

This script builds a Docker image from a specified Dockerfile and then extracts a layer from the built image using the `extract-layer.bat` script below.

Usage:
```bat
build-extract-layer.bat [Docker Image Name] [Path to Dockerfile]
```

### `extract-layer.bat`

This script extracts a layer from a specified Docker image. The extracted layer is saved as a zip file in the `layers-zipped`

Usage:
```bat
extract-layer.bat [Docker Image Name]
```

### `print-versions.bat`

This script prints the versions of `boto3` and `langchain` in a specified Docker image. The versions are saved in a `versions.log` file.

Usage:
```bat
print-versions.bat [Docker Image Name]
```

## Logs

The logs for the `build-extract-layer.bat` and `extract-layer.bat` scripts are saved in the `logs`

## Dockerfiles

The Dockerfiles used to build the Docker images are located in the `dockerfiles` directory

## Requirements

- Docker
- Windows Command Prompt

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.