#!/bin/bash
cd /home/glglgozz/practice/snupick/fetch
ruby fetch.rb 2015 S
sqlite3 ../db/development.sqlite3 < dbupdate
echo 'db update'
