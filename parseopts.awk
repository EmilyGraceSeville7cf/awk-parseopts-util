# Description: 
#   Library for parsing command line options.
#
# Rule syntax:
#   option { [-a|--alias=comma-separated-list] [-ia|--is-assignable=true|false] [-ab|--allow-bundle=true|false] [-ac|--assignment-char=char] }
#
#   Example:
#   -h { --alias=--help --is-assignable=false }

@include "utils.awk"

@namespace "parseopts"

BEGIN	{
  __NO_OPTION_NAME_ERROR = "ERROR: option name expected before {."
  __NO_OPENING_CURLY_BRACE_ERROR = "ERROR: { expected after option name."
  __NO_CLOSING_CURLY_BRACE_ERROR = "ERROR: } expected after option description."
  __UNKNOWN_OPTION = "ERROR: -a|--alias, -ia|--is-assignable, -ab|--allow-bundle, -ac|--assignment-char expected."
}

# Note: array must be indexed from 0.
function __validateOpt(opts, i) {
  if (length(opts[i]) == 0 || opts[i] == "{")
    return __NO_OPTION_NAME_ERROR
  
  i++
  if (opts[i] != "{")
    return __NO_OPENING_CURLY_BRACE_ERROR
  
  i++
  while (i < length(opts)) {
    switch (opts[i]) {
      case /^-a|--alias=/:
      case /^-ia|--is-assignable=/:
      case /^-ab|--allow-bundle=/:
      case /^--ac|--assignment-char=/:
        i++
        break
      
      case "}":
        return ++i

      default:
        return __UNKNOWN_OPTION
    }
  }

  len = length(opts)
  print opts[len - 1]
  if (i = len && opts[len - 1] != "}")
    return __NO_CLOSING_CURLY_BRACE_ERROR
}

# Note: array must be indexed from 0.
function __validateOpts(opts) {
  if (!awk::isarray(opts))
    return "ERROR: opts must be an array"

  i = 0
  while (i < length(opts)) {
    i = __validateOpt(opts, i)

    if (i ~ /^ERROR:/) # If error text returned instead of index than throw error.
      return i
  }
}
