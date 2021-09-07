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
option { [-a|--alias=comma-separated-list] [-ia|--is-assignable=true|false] [-ab|--allow-bundle=true|false] [-ac|--assignment-char=char] }
```

where:

- `option` - main command-line option name to be described within curly braces
  - `-a`|`--alias` - `option` aliases
  - `-ia`|`--is-assignable` - specifies whether `option` accepts value
  - `-ab`|`--allow-bundle` - specifies whether `option` acceptable value can be assigned via delimiting `option` and it via `-ac`|`--assignment-char`
  - `-ac`|`--assignment-char` - assignment char used to specify `option` value

Example:

```sh
-h { --alias=--help --is-assignable=false } -v { --alias=--version --is-assignable=false }
```

This option specification means that `-h`|`--help` and `-v`|`--version` options doesn't accept any values.
