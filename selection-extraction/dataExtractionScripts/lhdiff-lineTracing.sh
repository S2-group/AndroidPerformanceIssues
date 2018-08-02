#!/bin/bash
outaddress='./result.csv'
inputaddress='./input.csv'
OLDFILE='./old'
FileId=0
lastline=''
NotPresent="NA"
#num=1
while IFS=, read col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12
do
     yes=$(awk -F"," 'BEGIN { OFS = "," } ($2 == "'$col2'") && ($4 == "'$col4'") && ($8 == "'$col8'") {print $8}' ./input_file.csv)
     if [[ ! -z "$yes" ]]; then
          echo "already2exist" 
     else
          echo "$col2"    #repo name column
          echo "$col4"    #commit id
          echo "filename: $col8"    #filename
          echo "$col9" 
          echo "$col8"   #line number
          #pushd "./$col1"
          FileId=$(expr $FileId + 1)
          #rename=$(git log --follow --name-status --format='%H' -- ./$col6 | grep -E '\bC+[[:digit:]]+\b|\bR+[[:digit:]]+\b' | awk '{ print $2 }')
          #modified=$(git log --follow --name-status --pretty=format:%h -- ./$col6)
          IssueLines=$(awk -F"," 'BEGIN { OFS = "," } ($2 == "'$col2'") && ($4=="'$col4'") && ($8 == "'$col8'") {print}' ./result_file.csv)
          last_part="${col8##*$'/'}"
               if [[ "$col11" != "$lastline" ]]; then
                    echo "$IssueLines"
                    echo "$IssueLines" | while IFS=, read Perfline
                    do
                        line=$( echo "$Perfline" |cut -d\, -f9 )
                        num1=$(expr $line + 1)
                        ToolResult=$(java -jar ./lhdiff.jar -ob ./"$col2"/"$last_part"/"$col4".java ./"$col2"/"$last_part"/"$col4".java | sed -n "$num1"p | tr -d ,)
                        echo "$ToolResult"
                        echo "run1"
                        echo "$Perfline","$ToolResult" >> ./input_file.csv
                    done
                    LastFile=./"$col2"/"$last_part"/"$col4".java
                    lastline=$col11
                    echo "LASTLINE: $lastline"
               else
                    echo "$IssueLines" | while IFS=, read Perfline
                    do
                        line=$( echo "$Perfline" |cut -d\, -f9 )
                        num=$(expr $line + 1)
                        NewFile=./"$col2"/"$last_part"/"$col4".java
                        ToolResult=$(java -jar ./lhdiff.jar -ob $NewFile $LastFile | sed -n "$num"p | tr -d ,)
                        echo "$ToolResult"
                        echo "$Perfline","$ToolResult" >> ./input_file.csv
                        echo "run4"
                        echo "$LastFile"
                        echo "$NewFile"
                    done
                    LastFile=./rawfilesgradle/"$col2"/"$last_part"/"$col4".java
                    lastline=$col11
                    echo "LASTLINE2: $lastline"
               fi
                    #LastFile=../zzzz/"$col1"/"$last_part"/"$commit".java
          #popd

     fi
done < "$1"