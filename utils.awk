@include "errors.awk"

@namespace "utils"

# Returns true value.
function true() {
  return 1
}

# Returns false value.
function false() {
  return 0
}

# Prints passed array via specified separator.
#
# Arguments:
# - taget - array
# - separator - separator [default value: ", "]
function printArray(target, separator) {
  if (!awk::isarray(target))
    return errors::ARRAY_EXPECTED "target"
  if (!length(separator))
    separator = ", "
  
  targetLength = length(target)
  enumeratedCount = 1

  for (key in target) {
    printf target[key]
    if (enumeratedCount < targetLength)
      printf separator

    enumeratedCount++
  }
}

# Prints passed array via specified separator and jumps to the new line.
#
# Arguments:
# - taget - array
# - separator - separator [default value: ", "]
function printlnArray(target, separator) {
  printArray(target, separator)
  print
}

# Cleares array.
#
# Arguments:
# - taget - array
function clearArray(target) {
  if (!awk::isarray(target))
    return errors::ARRAY_EXPECTED "target"
  
  for (key in target)
    delete target[key]
}

# Checkes whether array contains specified value.
#
# Arguments:
# - taget - array
# - value - value to look for
function containsValue(target, value) {
  if (!awk::isarray(target))
    return errors::ARRAY_EXPECTED "target"
  
  for (key in target)
    if (target[key] == value)
      return true()
  return false()
}

# Checks whether value is a positive integer.
#
# Arguments:
# - value - value to check
function isPositiveInteger(value) {
  if (awk::isarray(value))
    return errors::PRIMITIVE_EXPECTED "value"
  
  return value ~ /^+?[[:digit:]]+$/
}

# Checks whether value is a negative integer.
#
# Arguments:
# - value - value to check
function isNegativeInteger(value) {
  if (awk::isarray(value))
    return errors::PRIMITIVE_EXPECTED "value"
  
  return value ~ /^-?[[:digit:]]+$/
}

# Checks whether value is an integer.
#
# Arguments:
# - value - value to check
function isInteger(value) {
  if (awk::isarray(value))
    return errors::PRIMITIVE_EXPECTED "value"
  
  return value ~ /^[-+]?[[:digit:]]+$/
}

# Checks whether value is a positive float.
#
# Arguments:
# - value - value to check
function isPositiveFloat(value) {
  if (awk::isarray(value))
    return errors::PRIMITIVE_EXPECTED "value"
  
  return value ~ /^+?[[:digit:]]+\.[[:digit:]]*$/
}

# Checks whether value is a negative float.
#
# Arguments:
# - value - value to check
function isNegativeFloat(value) {
  if (awk::isarray(value))
    return errors::PRIMITIVE_EXPECTED "value"
  
  return value ~ /^-?[[:digit:]]+\.[[:digit:]]*$/
}

# Checks whether value is a float.
#
# Arguments:
# - value - value to check
function isFloat(value) {
  if (awk::isarray(value))
    return errors::PRIMITIVE_EXPECTED "value"
  
  return value ~ /^[-+]?[[:digit:]]+\.[[:digit:]]*$/
}

# Checks whether value is a bool.
#
# Arguments:
# - value - value to check
function isBool(value) {
  if (awk::isarray(value))
    return errors::PRIMITIVE_EXPECTED "value"
  
  return value ~ /^true|false$/
}
