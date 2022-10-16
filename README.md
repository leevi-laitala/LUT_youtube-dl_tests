# Tests for youtube-dl

Contains various tests for youtube-dl. For a school project.

## How to run the tests

All tests are located in `test/` directory. The tests can be ran manually inside bash,
or ran automatically using the `runtests.sh` script, which automatically clones the
youtube repo for tests and handles cleanup.

`src/runtests.sh` script runs all tests that are specified in `TESTTAGS` environment
variable. By default it sources the env vars from `src/tags.sh` file. The formatting for
the env variable is the filename of the test. If multiple tests need to be ran they
are separated by AND.

For example `TESTTAGS="test.shANDothertest.shANDmoretests.sh"`


## List of tests 

Tests that are currently implemented:

<br>

##### 1. Normal run

Try to download video, and check if the video exists in filesystem.

##### 2. Recode video

Download video, and convert it to specific format. Check if format is changed in filesystem.

##### 3. Resize terminal window

Download video, and resize terminal window to different sizes and check if the application
crashes between resizes.

##### 4. Date parameter

Download video with specific upload date, and check if the dates match.

