#!/usr/bin/env bash

CURRENT_BINARY_NAME=$1
chmod +x vc3_new
rm "$CURRENT_BINARY_NAME" || true
mv vc3_new "$CURRENT_BINARY_NAME"