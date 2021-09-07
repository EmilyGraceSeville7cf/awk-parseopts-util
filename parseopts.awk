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
  __UNKNOWN_OPTION_ERROR = "ERROR: -a|--alias, -ia|--is-assignable, -ab|--allow-bundle, -ac|--assignment-char expected."

  __NO_ALIAS_VALUE_ERROR = "ERROR: alias expected after assignment for -a|--alias."
  __UNKNOWN_ASSIGNABLE_VALUE_ERROR = "ERROR: true|false expected for -ia|--is-assignable."
  __UNKNOWN_ALLOW_BUNDLE_VALUE_ERROR = "ERROR: true|false expected for -ab|--allow-bundle."
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
    option = opts[i]
    value = opts[i]
    
    sub(/=.*/, "", option)
    sub(/^.*=/, "", value)

    print option " => " value
    switch (option) {
      case /^-a|--alias=/:
        if (value == "")
          return __NO_ALIAS_VALUE_ERROR
        break
      
      case /^-ia|--is-assignable=/:
        if (value !~ /^true|false$/)
          return __UNKNOWN_ASSIGNABLE_VALUE_ERROR
        break
      
      case /^-ab|--allow-bundle=/:
        if (value !~ /^true|false$/)
          return __UNKNOWN_ALLOW_BUNDLE_VALUE_ERROR
        break

      case /^--ac|--assignment-char=/:
        break
      
      case "}":
        return ++i

      default:
        return __UNKNOWN_OPTION_ERROR
    }

    i++
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