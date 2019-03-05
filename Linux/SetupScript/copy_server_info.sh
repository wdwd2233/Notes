#!/bin/bash

pushd $PWD
cd ../Server
cp env/server/windows/ServerInfos.json env/server/linux/ServerInfos.json
cp env/server/windows/data_server/DerivedSetting.json env/server/linux/data_server/DerivedSetting.json
cp env/server/windows/data_server/seelog.xml env/server/linux/data_server/seelog.xml
cp env/server/windows/game_server/DerivedSetting.json env/server/linux/game_server/DerivedSetting.json
cp env/server/windows/game_server/seelog.xml env/server/linux/game_server/seelog.xml
cp env/server/windows/game_server/Game1.json env/server/linux/game_server/Game1.json
cp env/server/windows/lobby_server/DerivedSetting.json env/server/linux/lobby_server/DerivedSetting.json
cp env/server/windows/lobby_server/seelog.xml env/server/linux/lobby_server/seelog.xml
cp env/server/windows/log_server/DerivedSetting.json env/server/linux/log_server/DerivedSetting.json
cp env/server/windows/log_server/seelog.xml env/server/linux/log_server/seelog.xml
cp env/server/windows/login_server/DerivedSetting.json env/server/linux/login_server/DerivedSetting.json
cp env/server/windows/login_server/seelog.xml env/server/linux/login_server/seelog.xml
popd
