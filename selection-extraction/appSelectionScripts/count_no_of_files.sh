#!/bin/bash
outaddress='./no_of_files_in_repos.csv'
while IFS='' read  line || [[ -n "$line" ]]; do
    cd /c/Users/Teerath/cloned_apps/$line		
    find . -name "*.java" > java_files
    find . -name "*.xml" > xml_files
    find . -name "*.c" > C_files
    find . -name "*.js" > JS_files
    find . -name "*.py" > P_files
    find . -name "*.h" > H_files
    pwd >> $outaddress 
    wc -l java_files >> $outaddress
    wc -l xml_files >> $outaddress
    wc -l C_files >> $outaddress
    wc -l JS_files >> $outaddress
    wc -l P_files >> $outaddress
    wc -l H_files >> $outaddress
done < "$1"