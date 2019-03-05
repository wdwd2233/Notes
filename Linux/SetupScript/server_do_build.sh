#!/bin/bash

export GO111MODULE=on
cd src/src/cegame
go build -o ../../../env/server/linux/log_server/logserver.out server/logserver/main.go
go build -o ../../../env/server/linux/data_server/dataserver.out server/dataserver/main.go
go build -o ../../../env/server/linux/login_server/loginserver.out server/loginserver/main.go
go build -o ../../../env/server/linux/lobby_server/lobbyserver.out server/lobbyserver/main.go
go build -o ../../../env/server/linux/game_server/gameserver.out server/gameserver/main.go
go build -o ../../../env/server/linux/api_server/apiserver.out server/apiserver/main.go
