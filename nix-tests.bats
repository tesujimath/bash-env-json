#!/usr/bin/env bats
#
# simple tests for the Nix packaging

@test "simple" {
	actual=$(echo 'export SOME_VARIABLE=some_value' | ./bash-env-json | jq -r '.env.SOME_VARIABLE')
	expected='some_value'
	test "$actual" == "$expected"
}

@test "path" {
	actual=$(echo 'export PATH=/oops' | ./bash-env-json | jq -r '.env.PATH')
	expected='/oops'
	test "$actual" == "$expected"
}
