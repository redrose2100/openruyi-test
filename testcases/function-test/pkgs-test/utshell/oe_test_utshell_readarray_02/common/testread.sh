#!/bin/bash


inputfile="./alpha.log"
exec {fd}<"$inputfile"
readarray -u ${fd} -d',' abc
echo "${abc[*]}"
