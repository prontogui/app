# Copyright 2024 ProntoGUI, LLC.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Makefile to generate all code for .proto files.

# Define the protobuf compiler and the grpc plugin
PROTOC = protoc

all: 
	if [ ! -d "proto" ]; then git clone -b v0.0.2 https://andyhjoseph@github.com/prontogui/proto.git; fi
	mkdir -p lib/proto
	$(PROTOC) --dart_out=grpc:lib proto/pg.proto

.PHONY: all

clean:
	rm -Rf proto
	rm -f lib/proto/*.dart
