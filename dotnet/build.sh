#!/bin/bash
set -ex

DOCKER_REPO="docker.io/mikucat0309"

RUNTIMES=("dotnet" "aspnet")
VERSIONS=("6.0" "7.0")
PLATFORMS="linux/amd64,linux/arm64"

for RUNTIME in "${RUNTIMES[@]}"; do
for VERSION in "${VERSIONS[@]}"; do
    docker buildx build . -f $RUNTIME/alpine/Dockerfile --platform $PLATFORMS \
        --build-arg "VERSION=$VERSION" \
        -t "$DOCKER_REPO/lambda-$RUNTIME:$VERSION-alpine" \
        --push
    
    docker buildx build . -f $RUNTIME/bullseye-slim/Dockerfile --platform $PLATFORMS \
        --build-arg "VERSION=$VERSION" \
        -t "$DOCKER_REPO/lambda-$RUNTIME:$VERSION-bullseye-slim" \
        --push
done
done