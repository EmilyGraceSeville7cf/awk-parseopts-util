@include "parseopts.awk"
@include "colors.awk"

function __printlnInputArguments(target,    DELIMITER_COLOR, OPTION_COLOR,
  BRACE_COLOR, SEPARATOR, targetLength, i, color) {
  DELIMITER_COLOR = colors::FG_COLORS["purple"]
  OPTION_COLOR = colors::FG_COLORS["cyan"]
  BRACE_COLOR = colors::FG_COLORS["blue"]

  SEPARATOR = " "
  
  targetLength = length(target)

  for (i = 1; i < targetLength; i++) {
    switch (target[i]) {
      case /^::$/:
        color = DELIMITER_COLOR
        break
      
      case /^{|}$/:
        color = BRACE_COLOR
        break

      default:
        color = OPTION_COLOR
    }

    printf "%s%s%s", color, target[i], COLORS["reset"]
    if (i < targetLength)
      printf SEPARATOR
  }
  print
}

BEGIN	{
  NO_OPTION_SPECIFICATIONS_ERROR = "ERROR: no option specifications provided"

  NO_OPTION_SPECIFICATIONS_CODE = 2
  CHECK_FAILED_CODE = 1

  ERROR_COLOR = colors::FG_COLORS["red"]

  i = 1
  while (i < ARGC && ARGV[i] != "::") {
    arguments[i - 1] = ARGV[i]
    i++
  }

  i++
  if (!length(ARGV[i])) {
    printf "%sERROR: no option specifications provided%s\n", ERROR_COLOR, COLORS["reset"]
    exit NO_OPTION_SPECIFICATIONS_CODE
  }

  j = i
  while (i < ARGC) {
    specifications[i - j] = ARGV[i]
    i++
  }

  __printlnInputArguments(ARGV)

  result = parseopts::checkArguments(arguments, specifications)
  if (result !~ /^ERROR:/)
    print result
  else {
    printf "%s%s%s\n", ERROR_COLOR, result, COLORS["reset"]
    exit CHECK_FAILED_CODE
  }
}
