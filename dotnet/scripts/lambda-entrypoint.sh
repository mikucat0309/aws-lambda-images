#!/bin/sh
# Origin: https://github.com/aws/aws-lambda-base-images/tree/provided.al2/x86_64
# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.

if [ $# -ne 1 ]; then
  echo "entrypoint requires the handler name to be the first argument" 1>&2
  exit 142
fi
export _HANDLER="$1"

RUNTIME_ENTRYPOINT=/var/runtime/bootstrap.sh
if [ -z "${AWS_LAMBDA_RUNTIME_API}" ]; then
  exec /usr/bin/alrie $RUNTIME_ENTRYPOINT
else
  exec $RUNTIME_ENTRYPOINT
fi
