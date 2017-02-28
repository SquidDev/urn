#!/usr/bin/env sh

set -euf

mkdir -p "$LUA_HOME_DIR"

# Fetch the Lua download
echo "Fetching $LUA"
curl "http://www.lua.org/ftp/$LUA.tar.gz" | tar xz
cd "$LUA"

# Build it
perl -i -pe 's/-DLUA_COMPAT_(ALL|5_2)//' src/Makefile
make linux
make INSTALL_TOP="$LUA_HOME_DIR" install

# Clean up
cd $TRAVIS_BUILD_DIR
rm -rf "$LUA"
