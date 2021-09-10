@include "utils.awk"
@include "errors.awk"

@namespace "parseopts"

# Converts bool string to integer.
#
# Arguments:
# - value - value
function __toInteger(value) {
  return (value == "true") ? utils::true() : utils::false()
}

# Validates option specification.
#
# Arguments:
# - opts - options array containing option specification (all indecies must be zero-based sequentially continue over entire array)
# - i - index to start scanning opts from (must point to item with option name before opening curly brace)
function __validateOpt(opts, i) {
  if (!length(opts[i]) || opts[i] == "{")
    return errors::NO_OPTION_NAME_ERROR
  
  i++
  if (opts[i] != "{")
    return errors::NO_OPENING_CURLY_BRACE_ERROR
  
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

    option = option "="

    switch (option) {
      case /^(-t|--type)=/:
        if (typeDefined)
          return errors::DUPLICATED_TYPE_ERROR option

        if (value !~ /^integer|float|bool|string$/)
          return errors::UNKNOWN_TYPE_VALUE_ERROR option

        typeDefined = utils::true()
        break
      
      case /^(-a|--alias)=/:
        if (aliasDefined)
          return errors::DUPLICATED_ALIAS_ERROR option

        if (value == "")
          return errors::NO_ALIAS_VALUE_ERROR option

        aliasDefined = utils::true()
        break
      
      case /^(-ia|--is-assignable)=/:
        if (isAssignableDefined)
          return errors::DUPLICATED_IS_ASSIGNABLE_ERROR option
        
        if (value !~ /^true|false$/)
          return errors::UNKNOWN_ASSIGNABLE_VALUE_ERROR option

        isAssignableDefined = utils::true()
        isAssignableEqualTrue = __toInteger(value)
        break
      
      case /^(-ab|--allow-bundle)=/:
        if (allowBundleDefined)
          return errors::DUPLICATED_ALLOW_BUNDLE_ERROR option
        
        if (value !~ /^true|false$/)
          return errors::UNKNOWN_ALLOW_BUNDLE_VALUE_ERROR option
        
        allowBundleDefined = utils::true()
        allowBundleEqualTrue = __toInteger(value)
        break

      case /^(--ac|--assignment-char)=/:
        if (assignmentCharDefined)
          return errors::DUPLICATED_ASSIGNMENT_CHAR_ERROR option
        
        assignmentCharDefined = utils::true()
        break
      
      case "}=":
        if (isAssignableEqualTrue && !typeDefined)
          return errors::MISSING_TYPE_WHEN_IS_ASSIGNABLE_ERROR
        if (isAssignableEqualTrue && !allowBundleDefined)
          return errors::MISSING_ALLOW_BUNDLE_WHEN_IS_ASSIGNABLE_ERROR
        if (isAssignableEqualTrue && allowBundleEqualTrue &&
          !assignmentCharDefined)
          return errors::MISSING_ASSIGNMENT_CHAR_WHEN_ALLOW_BUNDLE_ERROR

        return ++i

      default:
        return errors::UNKNOWN_OPTION_ERROR option
    }

    i++
  }

  len = length(opts)
  if (i = len && opts[len - 1] != "}")
    return errors::NO_CLOSING_CURLY_BRACE_ERROR
}

# Validates option specifications.
#
# Arguments:
# - opts - option array containing option specifications (all indecies must be zero-based sequentially continue over entire array)
function __validateOpts(opts) {
  i = 0
  while (i < length(opts)) {
    i = __validateOpt(opts, i)

    if (i ~ /^ERROR:/) # If error text returned instead of index than throw error.
      return i
  }
}

# Saves option specification as several associative arrays.
#
# Arguments:
# - opts options array containing option specification (all indecies must be zero-based sequentially continue over entire array)
# - i - index to start scanning opts from (must point to item with option name before opening curly brace)
# - outExists - array for marking option as defined
# - outType - array with -t|--type values
# - outAlias - array with -a|--alias values
# - outIsAssignable - array with -ia|--is-assignable values
# - outAllowBundle - array with -ab|--allow-bundle values
# - outAssignmentChar - array with -ac|--assignment-char values
function __parseOpt(opts, i, outExists, outType, outAlias, outIsAssignable, outAllowBundle, outAssignmentChar) {
  optionName = opts[i++]
  outExists[optionName] = utils::true()
  i++

  while (i < length(opts) && opts[i] != "}") {
    option = opts[i]
    value = opts[i]

    sub(/=.*/, "", option)
    sub(/^.*=/, "", value)

    optionWithEqualSign = option "="

    switch (optionWithEqualSign) {
      case /^(-t|--type)=/:
        outType[optionName] = value
        break
      
      case /^(-a|--alias)=/:
        outAlias[optionName] = value
        break
      
      case /^(-ia|--is-assignable)=/:
        outIsAssignable[optionName] = __toInteger(value)
        break
      
      case /^(-ab|--allow-bundle)=/:
        outAllowBundle[optionName] = __toInteger(value)
        break

      case /^(--ac|--assignment-char)=/:
        outAssignmentChar[optionName] = value
        break
    }

    i++
  }

  return ++i
}

# Saves option specification as several associative arrays.
#
# Arguments:
# - opts options array containing option specifications (all indecies must be zero-based sequentially continue over entire array)
# - outExists - array for marking option as defined
# - outType - array with -t|--type values
# - outAlias - array with -a|--alias values
# - outIsAssignable - array with -ia|--is-assignable values
# - outAllowBundle - array with -ab|--allow-bundle values
# - outAssignmentChar - array with -ac|--assignment-char values
function __parseOpts(opts, outExists, outType, outAlias, outIsAssignable, outAllowBundle, outAssignmentChar) {
  utils::clearArray(outExists)
  utils::clearArray(outType)
  utils::clearArray(outAlias)
  utils::clearArray(outIsAssignable)
  utils::clearArray(outAllowBundle)
  utils::clearArray(outAssignmentChar)

  i = 0
  while (i < length(opts))
    i = __parseOpt(opts, i, outExists, outType, outAlias, outIsAssignable, outAllowBundle, outAssignmentChar)
}


# Checks whether argument conforms specified option specification.
#
# Arguments:
# - arg - argument
# - value - possible argument value
# - outExists - array for marking option as defined
# - outType - array with -t|--type values
# - outAlias - array with -a|--alias values
# - outIsAssignable - array with -ia|--is-assignable values
# - outAllowBundle - array with -ab|--allow-bundle values
# - outAssignmentChar - array with -ac|--assignment-char values
function __checkArgumentConformsSpecification(arg, value, outExists, outType, outAlias, outIsAssignable, outAllowBundle, outAssignmentChar) {
  optionExists = utils::false()
  if (arg in outExists)
    optionExists = utils::true()

  for (option in outAlias) {
    alias = outAlias[option]
    split(alias, aliasList, ",")

    if (utils::containsValue(aliasList, arg)) {
      optionExists = utils::true()
      break
    }
  }

  if (optionExists && !outIsAssignable[option])
    return utils::true()
  return utils::false()
}
