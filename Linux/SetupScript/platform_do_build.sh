#!/bin/bash

export GO111MODULE=on
cd src/src/cegame
go build -o ../../../env/platform/linux/api/api.out 				platform/api/main.go
go build -o ../../../env/platform/linux/backend/backend.out		 	platform/backend/main.go
go build -o ../../../env/platform/linux/frontend/frontend.out 		platform/frontend/main.go
go build -o ../../../env/platform/linux/log/log.out 				platform/log/main.go
