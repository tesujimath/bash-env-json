# bash-env-json

This is a Bash script `bash-env-json` for export of Bash environment as JSON, suitable for consumption by modern shells such as Elvish and Nushell.

Everyone needs Bash format environment support.  Being able to export this as JSON makes it readily available for import into any modern shell.

Adapters for [Elvish](https://github.com/tesujimath/bash-env-elvish), [Nushell](https://github.com/tesujimath/bash-env-nushell), and [Fish](https://github.com/tesujimath/bash-env-fish) are provided for ease of use from those shells.

Source files may be arbitrarily complex Bash, including conditionals, etc.

Besides environment variables, shell variables and functions may also be exported, useful for supporting e.g. Python virtualenv activation/deactivation and Node version manager (nvm).

Any suggestions for improvements are gladly received as issues.

## Environment and Shell Variables

```
$ export C="bad value"

$ cat tests/simple.env
export A=a
export B=b
unset C
d="I am a shell variable"


$ ./bash-env-json tests/simple.env | jq
{
  "env": {
    "B": "b",
    "A": "a",
    "C": null
  },
  "shellvars": {
    "d": "I am a shell variable"
  }
}
```

## Shell Functions

The shell function per se cannot be exported.  Rather what is exported is the *result* of invoking the shell function.

```
$ cat ./tests/shell-functions.env
export A=1
export B=1

function f2() {
        export A=2
        export B=2
        C2="I am shell variable C2"
}

function f3() {
        export A=3
        export B=3
        C3="I am shell variable C3"
}

$ ./bash-env-json --shellfns f2,f3 ./tests/shell-functions.env | jq

{
  "env": {
    "B": "1",
    "A": "1"
  },
  "shellvars": {},
  "fn": {
    "f2": {
      "env": {
        "B": "2",
        "A": "2"
      },
      "shellvars": {
        "C2": "I am shell variable C2"
      }
    },
    "f3": {
      "env": {
        "B": "3",
        "A": "3"
      },
      "shellvars": {
        "C3": "I am shell variable C3"
      }
    }
  }
}
```

## Exit Status

Any error is returned in the JSON `error` field, and `bash-env-json` returns an exit code of `1` in the usual way.

## Tests

The tests use [bats-core](https://github.com/bats-core/bats-core).

For each `$test`, `$test.setup.env` is used to clear the environment, and `$test.json` is the expected output.

Expected output was created by running `bash-env-json` offline, so these are only regression tests.

## History

This started life as the [`nu_plugin_bash_env`](https://github.com/tesujimath/nu_plugin_bash_env) plugin for Nushell.  It was [forked for Elvish](https://github.com/tesujimath/bash-env-elvish), and then later made generic using JSON.
