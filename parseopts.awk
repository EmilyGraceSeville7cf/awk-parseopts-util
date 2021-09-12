@include "utils.awk"

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
# - duplicates - defined options to exclude duplcates
function __validateOpt(opts, i, duplicates) {
  optionName = opts[i]

  if (!length(optionName) || optionName == "{")
    return errors::NO_OPTION_NAME_ERROR
  
  optionName = opts[i]

  if (optionName in duplicates)
    return errors::DUPLICATED_OPTION_ERROR optionName

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

      case /^(-ac|--assignment-char)=/:
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

        duplicates[optionName] = utils::true()
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
  split("", duplicates)

  i = 0
  while (i < length(opts)) {
    i = __validateOpt(opts, i, duplicates)
    
    for (key in duplicates)
      printf key " | "
    print

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

      case /^(-ac|--assignment-char)=/:
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
# - args - array containing arguments (all indecies must be zero-based sequentially continue over entire array)
# - i - index to start scanning arguments from (must point to item with option name before opening curly brace)
# - possibleValue - possible argument value (argument value can be bundled with it in arg)
# - outExists - array for marking option as defined
# - outType - array with -t|--type values
# - outAlias - array with -a|--alias values
# - outIsAssignable - array with -ia|--is-assignable values
# - outAllowBundle - array with -ab|--allow-bundle values
# - outAssignmentChar - array with -ac|--assignment-char values
function __checkArgumentConformsSpecification(args, i, possibleValue, outExists, outType, outAlias, outIsAssignable, outAllowBundle, outAssignmentChar) {
  rawArg = args[i]
  arg = args[i]

  if (!length(arg))
    return errors::USER_NO_OPTION_PROVIDED_ERROR "arg"

  optionExists = utils::false()
  bundledAssignmentUsed = utils::false()

  step = 2
  if (arg in outExists)
    optionExists = utils::true()

  for (option in outAlias) {
    alias = outAlias[option]
    split(alias, aliasList, ",")

    if (utils::containsValue(aliasList, arg)) {
      optionExists = utils::true()
      arg = option
      break
    }
  }

  if (!optionExists) {
    if (utils::containsMatchingKey(outExists, "^" arg)) {
      optionExists = utils::true()
      bundledAssignmentUsed = utils::true()
    }

    for (option in outAlias) {
      alias = outAlias[option]
      split(alias, aliasList, ",")
      
      for (key in aliasList) {
        if (arg ~ "^" aliasList[key]) {
          optionExists = utils::true()
          bundledAssignmentUsed = utils::true()
          arg = option
          break
        }
      }
    }
    
    step = 1
  }

  if (!optionExists)
    return errors::USER_UNKNOWN_OPTION_ERROR arg

  if (!outIsAssignable[arg] && bundledAssignmentUsed)
    return errors::USER_OPTION_BUNDLED_ASSIGNMENT_NOT_SUPPORTED_ERROR arg
  if (outIsAssignable[arg] && !bundledAssignmentUsed && !length(possibleValue))
    return errors::USER_NO_OPTION_VALUE_PROVIDED_ERROR arg
  
  if (!outIsAssignable[arg])
    step = 1

  if (!bundledAssignmentUsed)
    value = possibleValue
  else {
    j = index(rawArg, outAssignmentChar[arg])
    value = substr(rawArg, j + 1)
    if (!length(value))
      return errors::USER_NO_OPTION_VALUE_PROVIDED_ERROR arg
  }

  if (!length(value))
    return errors::USER_NO_OPTION_VALUE_PROVIDED_ERROR arg

  switch (outType[arg]) {
    case "integer":
      if (!utils::isInteger(value))
        return errors::USER_INTEGER_OPTION_VALUE_EXPECTED value
      break
    case "float":
      if (!utils::isFloat(value))
        return errors::USER_FLOAT_OPTION_VALUE_EXPECTED value
      break
    case "bool":
      if (!utils::isBool(value))
        return errors::USER_BOOL_OPTION_VALUE_EXPECTED value
      break
  }

  return i + step
}

# Checks whether arguments conform specified option specifications.
#
# Arguments:
# - args - array containing arguments (all indecies must be zero-based sequentially continue over entire array)
# - outExists - array for marking option as defined
# - outType - array with -t|--type values
# - outAlias - array with -a|--alias values
# - outIsAssignable - array with -ia|--is-assignable values
# - outAllowBundle - array with -ab|--allow-bundle values
# - outAssignmentChar - array with -ac|--assignment-char values
function __checkArgumentsConformSpecifications(args, outExists, outType, outAlias, outIsAssignable, outAllowBundle, outAssignmentChar) {
  i = 0

  while (i < length(args)) {
    if (length(args[i + 1]))
      i = __checkArgumentConformsSpecification(args, i, args[i + 1], outExists, outType, outAlias, outIsAssignable, outAllowBundle, outAssignmentChar)
    else {
      delete args[i + 1]
      i = __checkArgumentConformsSpecification(args, i, "", outExists, outType, outAlias, outIsAssignable, outAllowBundle, outAssignmentChar)
    }

    if (i ~ /^ERROR:/) # If error text returned instead of index than throw error.
      return i
  }
}

# Checks whether arguments conform specified option specifications and returns true when everything is fine.
#
# Arguments:
# - args - array containing arguments (all indecies must be zero-based sequentially continue over entire array)
# - opts - options array containing option specification (all indecies must be zero-based sequentially continue over entire array)
function checkArguments(args, opts) {
  result = parseopts::__validateOpts(opts)
  if (result ~ /^ERROR:/)
    return result

  result = parseopts::__parseOpts(opts, outExists, outType, outAlias, outIsAssignable, outAllowBundle, outAssignmentChar)
  if (result ~ /^ERROR:/)
    return result
  
  result = parseopts::__checkArgumentsConformSpecifications(args, outExists, outType, outAlias, outIsAssignable, outAllowBundle, outAssignmentChar)
  if (result ~ /^ERROR:/)
    return result
  return utils::true()
}
