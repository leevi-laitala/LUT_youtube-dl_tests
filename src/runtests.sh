#!/bin/bash
REPOURL="https://github.com/ytdl-org/youtube-dl"

# First 
FAILED=0
PASSED=0

error() {
    tput setaf 1; echo "Error: $1"
    exit 1
}

fail() {
    MSG="\nFAIL: $1 returned non-zero value\n"
    tput setaf 1; echo -e $MSG; tput setaf 7
    FAILED=$(( $FAILED + 1 ))
}

pass() {
    MSG="\nPASS: $1\n"
    tput setaf 2; echo -e $MSG; tput setaf 7
    PASSED=$(( $PASSED + 1 ))
}

runpython() {
    python3 "../test/$1" && \
        pass $1 || \
        fail $1
}

runbash() {
    sh "../test/$1" && \
        pass $1 || \
        fail $1
}

# Source TESTTAGS env variable if declared in tests.sh file
[ -e "tags.sh" ] && source tags.sh

[ -z $TESTTAGS ] && error "TESTTAGS env variable is empty"

IFS="AND" read -ra TESTS <<< "$TESTTAGS"

#mkdir repo && cd repo
#git clone $REPOURL


for i in "${TESTS[@]}"
do
    [ ! -e "../test/$i" ] && \
        tput setaf 1 && echo "Could not find test file $i" && \
        tput setaf continue

    egrep -q ".*\.py" <<< $i && \
        runpython $i

    egrep -q ".*\.sh" <<< $i && \
        runbash $i
done

tput setaf 2; echo -e "Test results: $FAILED FAILED and $PASSED PASSED"

