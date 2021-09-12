# ParseOpt

## Description

Library for parsing command line options.

## Requirenments

- `GNU Awk 5.0.1`

## Options

No options are supported now.

## Option specification

Option specification is command-line argument descriptions bundled together in some code place. It has the following syntax:

```sh
option { [-t|--type=integer|float|bool|string] [-a|--alias=<comma-separated-list>] [-ia|--is-assignable=true|false] [-ab|--allow-bundle=true|false] [-ac|--assignment-char=<char>] }
```

where:

- `option` - main command-line option name to be described within curly braces
  - `-t`|`--type` - `option` value type one of `integer`|`float`|`bool`|`string` (required when `-ia`|`--is-assignable` equals to `true`)
  - `-a`|`--alias` - `option` aliases
  - `-ia`|`--is-assignable` - specifies whether `option` accepts value
  - `-ab`|`--allow-bundle` - specifies whether `option` acceptable value can be assigned via delimiting `option` and it via `-ac`|`--assignment-char` (required when `-ia`|`--is-assignable` equals to `true`)
  - `-ac`|`--assignment-char` - assignment char used to specify `option` value  (required when `-ia`|`--is-assignable` and `-ab`|`--allow-bundle` equal to `true`)

Example:

```sh
-h { --alias=--help --is-assignable=false } -v { --alias=--version --is-assignable=false }
```

This option specification means that `-h`|`--help` and `-v`|`--version` options doesn't accept any values.

You can create option specifications via arrays:

```awk
options[0] = "-h"
options[1] = "{"
options[2] = "--alias=--help"
options[3] = "--is-assignable=false"
options[4] = "}"

options[5] = "-v"
options[6] = "{"
options[7] = "--alias=--version"
options[8] = "--is-assignable=false"
options[9] = "}"
```

## Examples

Checking whether user-written arguments (`arguments` array) conforms described option specification (`options` array):

```awk
@include "parseopts.awk"
@include "utils.awk"
@include "colors.awk"

function shiftItems(from, to, source, target) {
  i = from
  j = to
  while (i <= from + length(source) - 1) {
    target[j] = source[i]
    i++
    j++
  }
}

BEGIN {
  split("-f { -a=--first -ia=true -t=bool -ab=true -ac=: } -s { -a=--second -ia=true -t=bool -ab=true -ac=: }", __options, " ")
  shiftItems(1, 0, __options, options)
  utils::clearArray(__options)

  printf "options = "
  utils::printlnArray(options)

  result = parseopts::__validateOpts(options)
  if (result ~ /^ERROR:/) {
    print result
    exit
  }

  result = parseopts::__parseOpts(options, outExists, outType, outAlias, outIsAssignable, outAllowBundle, outAssignmentChar)
  if (result ~ /^ERROR:/) {
    print result
    exit
  }

  split("--first false -s true", __arguments, " ")
  shiftItems(1, 0, __arguments, arguments)
  utils::clearArray(__arguments)

  printf "arguments = "
  utils::printlnArray(arguments, ", ")

  result = parseopts::__checkArgumentsConformSpecifications(arguments, outExists, outType, outAlias, outIsAssignable, outAllowBundle, outAssignmentChar)
  if (result ~ /^ERROR:/) {
    print result
    exit
  }
}
```
