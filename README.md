# Tests for youtube-dl

Contains various tests for youtube-dl. For a school testing course project.

<br>

## Requirements

Any terminal emulator running bash will most probably work, but xterm compatible will
work best.

You can install youtube-dl from your favourite package manager, but is not required.
Since the runnerscript will clone the youtube-dl github repository by default.

`ffmpeg` should be installed to enable video recoding.

<br>

## How to run the tests

#### Configure the tests that you want to run

All tests are located in `test/` directory. The tests can be ran manually inside bash,
or ran automatically using the `runtests.sh` script, which automatically clones the
youtube repo for tests and handles cleanup.

`src/runtests.sh` script runs all tests that are specified in `TESTTAGS` environment
variable. By default it sources the env vars from `src/tags.sh` file. The formatting for
the env variable is the filename of the test. If multiple tests need to be ran they
are separated by AND.

For example: `TESTTAGS="test.shANDothertest.shANDmoretests.sh"`

You can also list the tests with `-t` or `--tags` flags. They will override the `tags.sh`
file, and the tests listed in the `TESTTAGS` environment variable.

For example: `./runtests.sh --tags "test.shANDothertest.shANDmoretests.sh"`

<br>

#### Running tests manually

Since the tests are bash or python scripts, you can easily run them manually. However the
tests use `YTEXEC` environment variable as the executable. So you need to specify that
before running. Same way as with the `-p` or `--path-to-executable` flags from the runnerscript.

This can be done `YTEXEC="yt-dlp" ./test.sh`

<br>

#### Specify the version of youtube-dl

By default the runnerscript will clone the latest youtube-dl repository from github. However if
you have installed already youtube-dl, or use some custom version, or old version, you can use it.

The custom version needs to be specified with `-p` or `--path-to-executable` flags.

For example: `./runtests.sh -p "python3 /path/to/youtube-dl.py"` or `./runtests.sh -p "yt-dlp"`

<br>

#### Exit on failure

If you are conducting a suite of tests, that depend of the success of previous. You can enable
exit on failure, which will skip all following tests, if an error occurs.

It can be enabled with `-e` or `--exit-on-failure` flags.

<br>

## List of tests 

##### 1. Normal run

Try to download video, and check if the video exists in filesystem.

##### 2. Recode video

Download video, and convert it to specific format. Check if format is changed in filesystem.

##### 3. Resize terminal window

Download video, and resize terminal window to different sizes and check if the application
crashes between resizes.

##### 4. Date parameter

Download video with specific upload date, and check if the dates match.

##### 5. Private video

Try to download a private video from YouTube. It should fail if the video can be downloaded, and
will pass if youtube-dl throws error.
