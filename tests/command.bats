#!/usr/bin/env bats

setup() {
  load "${BATS_PLUGIN_PATH}/load.bash"

  # Uncomment to enable stub debugging
  # export CURL_STUB_DEBUG=/dev/tty

  # you can set variables common to all tests here
  export BUILDKITE_PLUGIN_COMMIT_BRANCH_MODE='warn'
}

@test "Missing mandatory option fails" {
  unset BUILDKITE_PLUGIN_COMMIT_BRANCH_MODE

  run "$PWD"/hooks/command

  assert_failure
  assert_output --partial 'Missing mode option'
  refute_output --partial 'Running plugin'
}

@test "Normal basic operations" {

  run "$PWD"/hooks/command

  assert_success
  assert_output --partial 'Running plugin with options'
  assert_output --partial '- mode: warn'
}

@test "Strict mode set" {
  export BUILDKITE_PLUGIN_COMMIT_BRANCH_MODE='strict'
  export BUILDKITE_BRANCH=foobar

  run "$PWD"/hooks/command

  assert_failure
  assert_output --partial 'Build failing due to mode'
  assert_output --partial '- mode: strict'
}
