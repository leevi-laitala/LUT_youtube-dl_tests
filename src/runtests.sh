#!/bin/bash
REPOURL="https://github.com/ytdl-org/youtube-dl"

# First 
FAILED=0
PASSED=0
SKIPPED=0

# Source TESTTAGS env variable if declared in tests.sh file
[ -e "tags.sh" ] && source tags.sh

[ -z $TESTTAGS ] && error "TESTTAGS env variable is empty"

IFS="AND" read -ra TESTS <<< "$TESTTAGS"

error() {
    tput setaf 1; echo "Error: $1"
    exit 1
}

runtest() {
    if [ $2 = "python" ]; then
        python "../test/$1"
    elif [ $2 = "bash" ]; then
        bash "../test/$1"
    fi
    
    CODE=$?

    if [ $CODE -eq 0 ]; then
        MSG="\nPASS: $1\n"
        tput setaf 2; echo -e $MSG; tput setaf 7
        PASSED=$(( $PASSED + 1 ))
    elif [ $CODE -eq 2 ]; then
        MSG="\nSKIP: $1\n"
        tput setaf 3; echo -e $MSG; tput setaf 7
        SKIPPED=$(( $SKIPPED + 1 ))
    else
        MSG="\nFAIL: $1 returned non-zero value\n"
        tput setaf 1; echo -e $MSG; tput setaf 7
        FAILED=$(( $FAILED + 1 ))
    fi
}

for i in "${TESTS[@]}"
do
    [ ! -e "../test/$i" ] && \
        tput setaf 1 && echo "Could not find test file $i" && \
        tput setaf continue

    egrep -q ".*\.py" <<< $i && \
        runtest $i "python"

    egrep -q ".*\.sh" <<< $i && \
        runtest $i "bash"
done

COLOR=2 # Green if no fails, otherwise red
[ ! $FAILED -eq 0 ] && COLOR=1

RESULT="Test results, in total ${#TESTS[@]} tests were ran:\n"
RESULT+="\t$FAILED FAILED | $SKIPPED SKIPPED | $PASSED PASSED"

tput setaf $COLOR; echo -e "$RESULT"

