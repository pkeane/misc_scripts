#!/bin/bash

#mencoder $1 -ovc lavc -ffourcc DX50 -o $2 -oac mp3lame -lameopts abr:br=128 -srate 8000
#mencoder $1 -ovc lavc -lavcopts vcodec=mpeg4 -of mpeg -o $2 -oac mp3lame -lameopts abr:br=128 -srate 8000 -ofps 30000/1001
mencoder $1 -ovc lavc -lavcopts vcodec=mpeg4 -of mpeg -o $2 -oac mp3lame -lameopts abr:br=128 -srate 8000 -ofps 25 

