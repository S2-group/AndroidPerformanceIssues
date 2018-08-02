#!/bin/bash

# Shell Script to run Andriod Lint on all tne targeted apps.

outaddress='./result.csv'
outaddresses='./summary.csv'
abc=""
function keywords()
{
    printf '%s\n' "$App" | while IFS= read -r reds
    do
        if [[ "$reds" == "app" ]] || [[ "$reds" == "handheld" ]] || [[ "$reds" == "lukkari" ]] || [[ "$reds" == "widget" ]] || [[ "$reds" == "HatebuView" ]] || [[ "$reds" == "wearable" ]] || [[ "$reds" == "SecretCodes" ]] || [[ "$reds" == "mobile" ]] || [[ "$reds" == "beetleescape" ]] || [[ "$reds" == "plasma" ]] || [[ "$reds" == "scp" ]] || [[ "$reds" == "RingMyPhone" ]] || [[ "$reds" == "android" ]] || [[ "$reds" == "SGit" ]] || [[ "$reds" == "schedule" ]] || [[ "$reds" == "PreferencesManager" ]] || [[ "$reds" == "Flashback" ]] || [[ "$reds" == "AudioGuide" ]] || [[ "$reds" == "tripDiary" ]] || [[ "$reds" == "NetLive" ]] || [[ "$reds" == "focus" ]] || [[ "$reds" == "AutoAP" ]] || [[ "$reds" == "writeily" ]] || [[ "$reds" == "awesomeAppCore" ]] || [[ "$reds" == "showcase" ]] || [[ "$reds" == "hermes" ]]  || [[ "$reds" == "yaaic" ]] || [[ "$reds" == "BravuraBrowser" ]] || [[ "$reds" == "Application" ]]; then
            abc=$reds
            echo "$abc"
        fi
    done
}

while IFS=, read col1 col2 col3 col4 col5 col6 col7 col8
do
    echo "$col2"
    pushd "$col2"
    mkdir -p ./output/$col2
    #com=$(git log --pretty=format:"%h")
    com=$col4
    printf '%s\n' "$com" | while IFS=, read -r i
    do 
        git reset --hard $i
        #checking if the repo is based on gradle build system or not
        grad=$(find . -name "build.gradle")
        if [[ ! -z "$grad" ]]; then
            #git submodule update --init
        	#check if gradlew batch file and gradle folder is present or not.
        	gradbatfile=$(find . -name "gradlew.bat")
        	if [[ ! -z "$gradbatfile" ]]; then
        		echo "gradlew file is present"
                DIR=$(dirname "${gradbatfile}")
                #DIR=.
                echo "DIR: $DIR"
        	else
                sett=$(find . -name "settings.gradle")
                DIR=$(dirname "${sett}")
        		cp -R ../gradlew.bat "$DIR"/gradlew.bat
        		cp -R ../gradlew "$DIR"/gradlew
        		cp -R ../gradle-wrapper.jar "$DIR"/gradle/wrapper/gradle-wrapper.jar
        	fi

            #check if local.properties file containing path of SDK is present. If not present then add that file.
        	cp -R ../local.properties "$DIR"/local.properties
            # extracting the name of branch directory from settings.gradle file.
        	sett=$(find . -name "settings.gradle")
        	if [[ ! -z "$sett" ]]; then
                pushd "$DIR"
                sed -i 's/, /\ninclude /g' settings.gradle
        		App=$(awk '/include/{print $2}' settings.gradle | cut -d: -f 2 | cut -d"'" -f 1)
                xyz=$(keywords "$App")
                echo "DIR1: $xyz"
            #To check lintOptions present in build.gradle file
        		printf '%s\n' "$App" | while IFS= read -r red
        		do
        			if grep -q lintOptions ./"$red"/build.gradle; then
                    	if grep -q abortOnError ./"$red"/build.gradle; then
                        	echo "lintOptions and abortOnError is present"
                    	else
                        	sed -i '/lintOptions.*/a \ \      \ abortOnError false' ./"$red"/build.gradle
                    	fi
        			else
                    	echo "running2"
        				sed -i '/buildToolsVersion.*/a \\n \   \lintOptions {\n\       \ abortOnError false \n \   \}' ./"$red"/build.gradle
        			fi
        		done

        	#To check build tools version is avaialable
        		printf '%s\n' "$App" | while IFS= read -r red
        		do
        			CHECKBUILD=$(awk '/buildToolsVersion/{print}' ./"$red"/build.gradle | cut -d'"' -f 2)
        			SOURCE="rc"
        			if echo "$CHECKBUILD" | grep -q "$SOURCE"; then
        				sed -i -e 's/buildToolsVersion.*/buildToolsVersion "23.0.0"/g' ./"$red"/build.gradle
        			else
        				echo "do nothing"
        			fi
        		done
        	   #looking for any issue which is supressed by "@SuppressWarnings.*" and "tools:ignore=.*" and delete that if any.
                slint2=$(grep -r "@SuppressLint.*" --include=*.java .)
                slint1=$(echo "$slint2" | paste -d- -s)
                slint=$(echo "$slint1" | sed 's/,/ /g')
                swarning2=$(grep -r "@SuppressWarnings.*" --include=*.java .)
                swarning1=$(echo "$swarning2" | paste -d- -s)
                swarning=$(echo "$swarning1" | sed 's/,/ /g')
                toolig2=$(grep -r "tools:ignore=.*" --include=*.java .)
                toolig1=$(echo "$toolig2" | paste -d- -s)
                toolig=$(echo "$toolig1" | sed 's/,/ /g')
                chcklint=$(find . -name "lint.xml*")
                countlint=$(echo "$chcklint" | wc -l)
                if [[ ! -z "$chcklint" ]]; then
                    echo "$col1","$i","$countlint","$slint","$swarning","$toolig" >> $outaddresses
                else
                    echo "$col1","$i","0","$slint","$swarning","$toolig" >> $outaddresses
                fi
                find . -name "*.java" -print0 | xargs -0 sed -i'' -e 's/@SuppressLint(".*")//'
                find . -name "*.java" -print0 | xargs -0 sed -i'' -e 's/@SuppressWarnings(".*")//'
                find . -name "*.java" -print0 | xargs -0 sed -i'' -e 's/@SuppressWarnings({.*})//'
                find . -name "*.xml" -print0 | xargs -0 sed -i'' -e 's/tools:ignore=.*/ /g'
                find . -type f -name '*lint.xml' -delete

                #running the lint tool on projects with gradle build system
        		./gradlew clean
        		./gradlew lint
        		if [ $? -eq 0 ]; then
        			echo "$col1","$i","workinggradle" >> $outaddress
                    echo "path: $abc"
        			cp -v ./"$xyz"/build/outputs/lint*.html ../output/$col2/$i.html
        			cp -v ./"$xyz"/build/lint*.html ../output/$col2/$i.html
                    rm -r ./"$xyz"/build
                    rm -r ./build
        		else
        			echo "$col1","$i","error" >> $outaddress
        		fi
                popd

        	#if the setting.gradle file is not present.
        	else
                pushd "$DIR"
                if grep -q lintOptions ./build.gradle; then
                    if grep -q abortOnError ./build.gradle; then
                        echo "lintOptions and abortOnError is present"
                    else
                        sed -i '/lintOptions.*/a \ \      \ abortOnError false' ./build.gradle
                    fi
                else
                    echo "running2"
                    sed -i '/buildToolsVersion.*/a \\n \   \lintOptions {\n\       \ abortOnError false \n \   \}' ./build.gradle
                fi
        		git submodule update --init
        		./gradlew clean
        		./gradlew lint
        		if [ $? -eq 0 ]; then
        			echo "$col1","$i","workinggradle" >> $outaddress
        			cp -v ./build/outputs/lint*.html ./output/$col2/$i.html
                    rm -r ./build/outputs/*
                    rm -r ./build
        		else
        			echo "$col1","$i","error" >> $outaddress
        		fi
                popd
        	fi

        else
        	#running the lint tool on project other than gradle build system
            echo "gradle not section"
            slint2=$(grep -r "@SuppressLint.*" --include=*.java .)
            slint1=$(echo "$slint2" | paste -d- -s)
            slint=$(echo "$slint1" | sed 's/,/ /g')
            swarning2=$(grep -r "@SuppressWarnings.*" --include=*.java .)
            swarning1=$(echo "$swarning2" | paste -d- -s)
            swarning=$(echo "$swarning1" | sed 's/,/ /g')
            toolig2=$(grep -r "tools:ignore=.*" --include=*.java .)
            toolig1=$(echo "$toolig2" | paste -d- -s)
            toolig=$(echo "$toolig1" | sed 's/,/ /g')
            chcklint=$(find . -name "lint.xml*")
            countlint=$(echo "$chcklint" | wc -l)
            if [[ ! -z "$chcklint" ]]; then
                echo "$col1","$i","$countlint","$slint","$swarning","$toolig" >> $outaddresses
            else
                echo "$col1","$i","0","$slint","$swarning","$toolig" >> $outaddresses
            fi
            find . -name "*.java" -print0 | xargs -0 sed -i'' -e 's/@SuppressLint(".*")//'
            find . -name "*.java" -print0 | xargs -0 sed -i'' -e 's/@SuppressWarnings(".*")//'
            find . -name "*.java" -print0 | xargs -0 sed -i'' -e 's/@SuppressWarnings({.*})//'
            find . -name "*.xml" -print0 | xargs -0 sed -i'' -e 's/tools:ignore=.*/ /g'
            find . -type f -name '*lint.xml' -delete
        	./lint.bat --html ../output/$col2/$i.html ../$col1
        	echo "$col1","$i","workingother" >> $outaddress
        fi
    done
    popd
done < "$1"
