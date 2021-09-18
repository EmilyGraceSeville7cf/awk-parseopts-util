@include "parseopts.awk"

BEGIN	{
  NO_OPTION_SPECIFICATIONS_ERROR = "ERROR: no option specifications provided"

  NO_OPTION_SPECIFICATIONS_CODE = 2
  CHECK_FAILED_CODE = 1

  i = 1
  while (i < ARGC && ARGV[i] != "::") {
    arguments[i - 1] = ARGV[i]
    i++
  }

  i++
  if (!length(ARGV[i])) {
    print "ERROR: no option specifications provided"
    exit NO_OPTION_SPECIFICATIONS_CODE
  }

  j = i
  while (i < ARGC) {
    specifications[i - j] = ARGV[i]
    i++
  }

  result = parseopts::checkArguments(arguments, specifications)
  print result

  if (result ~ /^ERROR:/)
    exit CHECK_FAILED_CODE
}
