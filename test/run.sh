#!/bin/bash

# Static type analysis
results=$(dartanalyzer test/mainpage_test.dart 2>&1)
echo "$results"
if [[ "$results" != *"No issues found"* ]]
then
    exit 1
fi
echo "Looks good!"
echo

# Install content_shell if not already present
which content_shell
if [[ $? -ne 0 ]]; then
  Chromium/../chromium/download_contentshell.sh
  unzip content_shell-linux-x64-release.zip

  cs_path=$(ls -d drt-*)
  PATH=$cs_path:$PATH
fi

# Start pub serve
pub serve &
pub_pid=$!

# Wait for server to build elements and spin up...
sleep 15

# Run a set of Dart Unit tests
results=$(content_shell --dump-render-tree http://localhost:8080/mainpage_test.html)
echo -e "$results"

kill $pub_pid

# check to see if DumpRenderTree tests
# failed, since it always returns 0
if [[ "$results" == *"Some tests failed"* ]]
then
    exit 1
fi

if [[ "$results" == *"Exception: "* ]]
then
    exit 1
fi
