#!/bin/bash
cd /home/snujoob/SNUJoobServer/fetch
ruby fetch.rb 2015 2
sqlite3 ../db/development.sqlite3 < dbupdate
echo 'db update'
