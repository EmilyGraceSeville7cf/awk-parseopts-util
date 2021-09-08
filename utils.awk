@namespace "utils"

# Prints passed array via specified separator.
#
# Arguments:
# - taget - array
# - separator - separator [default value: ", "]
function printArray(target, separator) {
  if (!awk::isarray(target))
    return "ERROR: target must be an array"
  if (length(separator) == 0)
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

# Checks whether value is a positive integer.
#
# Arguments:
# - value - value to check
function isPositiveInteger(value) {
  return value ~ /^+?[[:digit:]]+$/
}

# Checks whether value is a negative integer.
#
# Arguments:
# - value - value to check
function isNegativeInteger(value) {
  return value ~ /^-?[[:digit:]]+$/
}

# Checks whether value is an integer.
#
# Arguments:
# - value - value to check
function isInteger(value) {
  return value ~ /^[-+]?[[:digit:]]+$/
}

# Checks whether value is a positive float.
#
# Arguments:
# - value - value to check
function isPositiveFloat(value) {
  return value ~ /^+?[[:digit:]]+\.[[:digit:]]*$/
}

# Checks whether value is a negative float.
#
# Arguments:
# - value - value to check
function isNegativeFloat(value) {
  return value ~ /^-?[[:digit:]]+\.[[:digit:]]*$/
}

# Checks whether value is a float.
#
# Arguments:
# - value - value to check
function isFloat(value) {
  return value ~ /^[-+]?[[:digit:]]+\.[[:digit:]]*$/
}

# Checks whether value is a bool.
#
# Arguments:
# - value - value to check
function isBool(value) {
  return value ~ /^true|false$/
}

# Returns true value.
function true() {
  return 1
}

# Returns false value.
function false() {
  return 0
}
