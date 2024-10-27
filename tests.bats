#!/usr/bin/env bats

function test_case() {
	. "tests/${2:-$1}.setup.env"
	# sort and remove `meta` before comparison with expected output
	bash-env-json "tests/$1.env" | jq --sort-keys 'del(.meta)' | diff -w - "tests/${2:-$1}.json"
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
	test_case "Ming's menu of (merciless) monstrosities" ming-the-merciless
}
