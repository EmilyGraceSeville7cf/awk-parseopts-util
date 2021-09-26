@include "parseopts.awk"
@include "colors.awk"

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

  result = parseopts::checkArguments(arguments, specifications)
  if (result !~ /^ERROR:/)
    print result
  else {
    printf "%s%s%s\n", ERROR_COLOR, result, COLORS["reset"]
    exit CHECK_FAILED_CODE
  }
}
