#!/bin/bash
REPOURL="https://github.com/ytdl-org/youtube-dl"

error() {
    tput setaf 1; echo "Error: $1"
    exit 1
}

fail() {
    tput setaf 1; echo "FAIL: $1 returned non-zero value"
}

pass() {
    tput setaf 2; echo "PASS: $1"
}

runpython() {
    python3 "../tests/$1" && \
        pass $1 || \
        fail $1
}

runbash() {
    sh "../tests/$1" && \
        pass $1 || \
        fail $1
}

# Source TESTTAGS env variable if declared in tests.sh file
[ -e "tests.sh" ] && source tests.sh

[ -z $TESTTAGS ] && error "TESTTAGS env variable is empty"

IFS="AND" read -ra TESTS <<< "$TESTTAGS"

#mkdir repo && cd repo
#git clone $REPOURL

for i in "${TESTS[@]}"
do
    [ ! -e "../tests/$i" ] && \
        tput setaf 1 && echo "Could not find test file $i" && \
        tput setaf continue

    egrep -q ".*\.py" <<< $i && \
        runpython $i

    egrep -q ".*\.sh" <<< $i && \
        runbash $i
done

