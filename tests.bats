#!/usr/bin/env bats

function test_case() {
	local _setup_file="tests/$1.setup.env"
	local _test_file="tests/$1.env"
	local _expected_output="tests/$1.json"

	# setup cleans the environment of the unexpected
	. "$_setup_file"

	# args after the first two are passed through verbatim
	shift
	echo "$@"

	# sort and remove `meta` before comparison with expected output
	./bash-env-json "$@" "$_test_file" | jq --sort-keys 'del(.meta)' | diff -w - "$_expected_output"
}

@test "empty" {
	test_case empty
}

@test "shell-functions" {
	test_case shell-functions
}

@test "shell-variables" {
	test_case shell-variables
}

@test "simple" {
	test_case simple
}

@test "single" {
	test_case single
}

@test "ming-the-merciless" {
	test_case "Ming's menu of (merciless) monstrosities"
}

@test "multiline-string" {
	test_case multiline-string
}

@test "error" {
	test_case error
}

@test "shell-function-error" {
	test_case shell-function-error --shellfns f
}
