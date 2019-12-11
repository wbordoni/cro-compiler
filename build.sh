#!/bin/bash

bison -d language.y && flex language.lex && gcc language.tab.c lex.yy.c -lfl -o language
