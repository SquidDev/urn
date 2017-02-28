#!/usr/bin/env sh

export LUA_HOME_DIR="$HOME/.lua"

.build/setup_lua.sh

export PATH="$LUA_HOME_DIR/bin:$PATH"
lua -v
