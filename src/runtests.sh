#!/bin/bash
REPOURL="https://github.com/ytdl-org/youtube-dl"
export YTEXEC="youtube-dl"

# Keep track of tests status'
FAILED=0
PASSED=0
SKIPPED=0

# Boolean
EXITONFAILURE=0
CLONEREPO=1

# Print usage function
usage() {
    USAGE="usage: $0 <flags>\n"
    USAGE+="\n"
    USAGE+="$0 will run automatically tests that are set in TESTTAGS environment variable.\n"
    USAGE+="TESTTAGS contain the filenames of the tests that are conducted, separated by 'AND'\n"
    USAGE+="Available tests are found under 'test' directory inside the repo. Don't include paths\n"
    USAGE+="in TESTTAGS. The script will return the number of failed tests as a exit code, but only\n"
    USAGE+="the testing can be conducted to the end, and the runner script does not need to exit.\n"
    USAGE+="\n\tExample: TESTTAGS='test.shANDothertest.shANDevenmoretests.sh'\n"
    USAGE+="\nAvailable flags:\n"
    USAGE+="\t-h | --help               Print help.\n"
    USAGE+="\t-e | --exit-on-failure    When set, all tests will skip after first failure.\n"
    USAGE+="\t-p | --path-to-executable Set custom youtube-dl executable, otherwise will clone git repo\n"
    USAGE+="\t                          and use the youtube-dl version from there.\n"
    echo -e "$USAGE"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    KEY="$1"

    case $KEY in
        -h | --help)
            usage
            exit
            shift
            ;;
        -e | --exit-on-failure)
            EXITONFAILURE=1
            shift
            ;;
        -p | --path-to-executable)
            CLONEREPO=0
            YTEXEC="$2"
            shift
            shift
            ;;
        *)
            echo "Unknown option $1"
            exit 1
            ;;
    esac
done

if [ "$CLONEREPO" -eq "1" ]; then
    if [ -d "/tmp/repo" ]; then
        read -r -p "youtube-dl repository already cloned, delete it? [y/N]: "
        [[ $REPLY =~ ^[Yy] ]] && \
            rm -rf "/tmp/repo" && { git clone "$REPOURL" "/tmp/repo" ; }
    else
        git clone "$REPOURL" "/tmp/repo"
    fi
    
    YTPATH="/tmp/repo/youtube_dl/__main__.py"
    python --version &> /dev/null && \
        export YTEXEC="python $YTPATH" || \
        export YTEXEC="python3 $YTPATH"
fi

echo -e "\n\nRunning tests with: $YTEXEC \n"

# Error function, print message in red, and exit with 1
error() {
    tput setaf 1; echo "Error: $1"
    exit 1
}

# Source TESTTAGS env variable if declared in tests.sh file
# shellcheck disable=SC1091
[ -e "tags.sh" ] && source ./tags.sh

[ -z "$TESTTAGS" ] && error "TESTTAGS env variable is empty"

IFS="AND" read -ra TESTS <<< "$TESTTAGS"

# Run the test itself. Supports either python or bash files.
# If the test passes, meaning exits with 0 as exit code, one is added to the PASSED env var.
# If the test skips, meaning exits with 2 as exit code, SKIPPED env var is incremented.
# If exits with something else, the test fails and FAILED env var is incremented by one.
#
# If however EXITONFAILURE is enabled, and one test is already failed. Skip all tests.
runtest() {
    [ $EXITONFAILURE -eq 1 ] && [ $FAILED -gt 0 ] && { SKIPPED=$(( SKIPPED + 1 )) && return ; }
    
    # Check if python or bash file, and execute accordingly
    if [ "$2" = "python" ]; then
        python "../test/$1"
    elif [ "$2" = "bash" ]; then
        bash "../test/$1"
    fi

    # Save exit code
    CODE=$?

    # Compare exit code, and increment correct env var. And print result with correct color:
    # FAILED = red, SKIPPED = yellow, PASSED = green
    if [ $CODE -eq 0 ]; then
        MSG="\nPASS: $1\n"
        tput setaf 2; echo -e "$MSG"; tput setaf 7
        PASSED=$(( PASSED + 1 ))
    elif [ $CODE -eq 2 ]; then
        MSG="\nSKIP: $1\n"
        tput setaf 3; echo -e "$MSG"; tput setaf 7
        SKIPPED=$(( SKIPPED + 1 ))
    else
        MSG="\nFAIL: $1 returned non-zero value\n"
        tput setaf 1; echo -e "$MSG"; tput setaf 7
        FAILED=$(( FAILED + 1 ))
    fi
}

# Iterate through test files
for i in "${TESTS[@]}"
do
    # First check if the file even exists
    [ ! -e "../test/$i" ] && \
        tput setaf 1 && echo "Could not find test file $i" && \
        tput setaf 7 && continue

    # Check by file extension is the test a python or a bash file
    grep -q -E ".*\.py" <<< "$i" && \
        runtest "$i" "python"

    grep -q -E ".*\.sh" <<< "$i" && \
        runtest "$i" "bash"
done


# Print results
COLOR=2 # Green if no fails, otherwise red
[ ! $FAILED -eq 0 ] && COLOR=1

# Print amount of failed, skipped and passed tests. Text is red if even one test
# failed. And green if no tests failed.
RESULT="Test results, in total $(( FAILED + SKIPPED + PASSED )) tests were ran:\n"
RESULT+="\t$FAILED FAILED | $SKIPPED SKIPPED | $PASSED PASSED"

tput setaf $COLOR; echo -e "$RESULT"

# Exit with the amount of failed tests as a exit code
exit $FAILED
