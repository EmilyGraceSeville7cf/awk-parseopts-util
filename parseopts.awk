@include "utils.awk"

@namespace "parseopts"

BEGIN	{
  __NO_OPTION_NAME_ERROR = "ERROR: option name expected before {."
  __NO_OPENING_CURLY_BRACE_ERROR = "ERROR: { expected after option name."
  __NO_CLOSING_CURLY_BRACE_ERROR = "ERROR: } expected after option description."
  __UNKNOWN_OPTION_ERROR = "ERROR: -t|--type, -a|--alias, -ia|--is-assignable, -ab|--allow-bundle, -ac|--assignment-char expected."

  __DUPLICATED_TYPE_ERROR = "ERROR: -t|--type duplicated."
  __DUPLICATED_ALIAS_ERROR = "ERROR: -a|--alias duplicated."
  __DUPLICATED_IS_ASSIGNABLE_ERROR = "ERROR: -ia|--is-assignable duplicated."
  __DUPLICATED_ALLOW_BUNDLE_ERROR = "ERROR: -ab|--allow-bundle duplicated."
  __DUPLICATED_ASSIGNMENT_CHAR_ERROR = "ERROR: -ac|--assignment-char duplicated."

  __UNKNOWN_TYPE_VALUE_ERROR = "ERROR: integer|float|bool|string expected for -t|--type."
  __NO_ALIAS_VALUE_ERROR = "ERROR: alias expected after assignment for -a|--alias."
  __UNKNOWN_ASSIGNABLE_VALUE_ERROR = "ERROR: true|false expected for -ia|--is-assignable."
  __UNKNOWN_ALLOW_BUNDLE_VALUE_ERROR = "ERROR: true|false expected for -ab|--allow-bundle."

  __MISSING_TYPE_WHEN_IS_ASSIGNABLE_ERROR = "ERROR: expected -t|--type to be specified when -ia|--is-assignable equals to true."
  __MISSING_ALLOW_BUNDLE_WHEN_IS_ASSIGNABLE_ERROR = "ERROR: expected -ab|--allow-bundle to be specified when -ia|--is-assignable equals to true."
  __MISSING_ASSIGNMENT_CHAR_WHEN_ALLOW_BUNDLE_ERROR = "ERROR: expected -ac|--assignment-char to be specified when -ia|--is-assignable and -ab|--allow-bundle equal to true."
}

# Validates option specification.
#
# Arguments:
# - opts options array containing option specification (all indecies must be zero-based sequentially continue over entire array)
# - i index to start scanning opts from (must point to item with option name before opening curly brace)
function __validateOpt(opts, i) {
  if (length(opts[i]) == 0 || opts[i] == "{")
    return __NO_OPTION_NAME_ERROR
  
  i++
  if (opts[i] != "{")
    return __NO_OPENING_CURLY_BRACE_ERROR
  
  typeDefined = utils::false()
  aliasDefined = utils::false()
  isAssignableDefined = utils::false()
  allowBundleDefined = utils::false()
  assignmentCharDefined = utils::false()

  isAssignableEqualTrue = utils::false()
  allowBundleEqualTrue = utils::false()

  i++
  while (i < length(opts)) {
    option = opts[i]
    value = opts[i]
    
    sub(/=.*/, "", option)
    sub(/^.*=/, "", value)

    switch (option) {
      case /^(-t|--type)/:
        if (typeDefined == utils::true())
          return __DUPLICATED_TYPE_ERROR

        if (value !~ /^integer|float|bool|string$/)
          return __UNKNOWN_TYPE_VALUE_ERROR

        typeDefined = utils::true()
        break
      
      case /^(-a|--alias)/:
        if (aliasDefined == utils::true())
          return __DUPLICATED_ALIAS_ERROR

        if (value == "")
          return __NO_ALIAS_VALUE_ERROR

        aliasDefined = utils::true()
        break
      
      case /^(-ia|--is-assignable)/:
        if (isAssignableDefined == utils::true())
          return __DUPLICATED_IS_ASSIGNABLE_ERROR
        
        if (value !~ /^true|false$/)
          return __UNKNOWN_ASSIGNABLE_VALUE_ERROR

        isAssignableDefined = utils::true()
        isAssignableEqualTrue = (value == "true") ? utils::true() : utils::false()
        break
      
      case /^(-ab|--allow-bundle)/:
        if (allowBundleDefined == utils::true())
          return __DUPLICATED_ALLOW_BUNDLE_ERROR
        
        if (value !~ /^true|false$/)
          return __UNKNOWN_ALLOW_BUNDLE_VALUE_ERROR
        
        allowBundleDefined = utils::true()
        allowBundleEqualTrue = (value == "true") ? utils::true() : utils::false()
        break

      case /^(--ac|--assignment-char)/:
        if (assignmentCharDefined == utils::true())
          return __DUPLICATED_ASSIGNMENT_CHAR_ERROR
        
        assignmentCharDefined = utils::true()
        break
      
      case "}":
        if (isAssignableEqualTrue == utils::true() && typeDefined == utils::false())
          return __MISSING_TYPE_WHEN_IS_ASSIGNABLE_ERROR
        if (isAssignableEqualTrue == utils::true() && allowBundleDefined == utils::false())
          return __MISSING_ALLOW_BUNDLE_WHEN_IS_ASSIGNABLE_ERROR
        if (isAssignableEqualTrue == utils::true() && allowBundleDefined == utils::true() &&
          assignmentCharDefined == utils::false())
          return __MISSING_ASSIGNMENT_CHAR_WHEN_ALLOW_BUNDLE_ERROR

        return ++i

      default:
        return __UNKNOWN_OPTION_ERROR
    }

    i++
  }

  len = length(opts)
  if (i = len && opts[len - 1] != "}")
    return __NO_CLOSING_CURLY_BRACE_ERROR
}

# Validates option specifications.
#
# Arguments:
# - opts option array containing option specifications (all indecies must be zero-based sequentially continue over entire array)
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

