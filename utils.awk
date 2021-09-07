@namespace "utils"

# Prints passed array via specified separator (without separator all items are joined).
function printArray(target, separator) {
  if (!awk::isarray(target))
    return "ERROR: target must be an array"
  
  targetLength = length(target)
  enumeratedCount = 1

  for (key in target) {
    printf target[key]
    if (enumeratedCount < targetLength)
      printf separator

    enumeratedCount++
  }
}

# Prints passed array via specified separator (without separator all items are joined)
# and jumps to the new line.
function printlnArray(target, separator) {
  printArray(target, separator)
  print
}
