ARG VERSION
FROM --platform=${BUILDPLATFORM} golang:1.20 AS alrie-builder

ARG TARGETARCH
ENV GOARCH=$TARGETARCH
ENV CGO_ENABLED=0
WORKDIR /source
COPY alrie/ .
RUN go build -o /app/alrie -ldflags "-s -w" ./cmd/aws-lambda-rie

FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/dotnet/sdk:${VERSION}-bullseye-slim AS alric-builder
ARG TARGETARCH
ARG VERSION

WORKDIR /src
COPY ["aws-lambda-dotnet/Libraries/src/Amazon.Lambda.RuntimeSupport", "Repo/Libraries/src/Amazon.Lambda.RuntimeSupport/"]
COPY ["aws-lambda-dotnet/Libraries/src/Amazon.Lambda.Core", "Repo/Libraries/src/Amazon.Lambda.Core/"]
COPY ["aws-lambda-dotnet/buildtools/", "Repo/buildtools/"]
RUN dotnet restore "Repo/Libraries/src/Amazon.Lambda.RuntimeSupport/Amazon.Lambda.RuntimeSupport.csproj" \
    /p:TargetFrameworks=net${VERSION}
WORKDIR "Repo/Libraries/src/Amazon.Lambda.RuntimeSupport"
RUN if [ "x$TARGETARCH" = "xamd64" ]; then ARCH=x64; else ARCH=$TARGETARCH; fi; \
    dotnet publish "Amazon.Lambda.RuntimeSupport.csproj" /p:ExecutableOutputType=true \
    /p:GenerateDocumentationFile=false /p:TargetFrameworks=net${VERSION} \
    -f net${VERSION} --runtime linux-${ARCH} --self-contained false \
    -p:PublishReadyToRun=true -c Release -o /app


FROM mcr.microsoft.com/dotnet/runtime:${VERSION}-bullseye-slim
ENV LAMBDA_RUNTIME_DIR=/var/runtime
ENV LAMBDA_TASK_ROOT=/var/task

WORKDIR /var/task

COPY --from=alrie-builder /app/alrie /usr/bin/
COPY --from=alric-builder /app ${LAMBDA_RUNTIME_DIR}
COPY scripts/bootstrap.sh ${LAMBDA_RUNTIME_DIR}
COPY scripts/lambda-entrypoint.sh /

ENTRYPOINT [ "/lambda-entrypoint.sh" ]
