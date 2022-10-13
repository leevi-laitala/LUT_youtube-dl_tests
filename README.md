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

$$
\begin{array}{l|l}

\text{Name} & \text{Description} \\

\hline

\text{Normal run} & \text{Downloads video, and checks if downloaded video exists} \\

\hline

\text{Recode video} & \text{Check if downloaded video is encoded to correct format} \\

\hline

\text{Resize} & \text{Check if resizing the terminal emulator window to a small size will bork the output} \\

\end{array}
$$



