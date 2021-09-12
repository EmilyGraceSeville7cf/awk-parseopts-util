@namespace "errors"

BEGIN	{
  # General errors
  ARRAY_EXPECTED = "ERROR: array expected. Wrong argument: "
  PRIMITIVE_EXPECTED = "ERROR: primitive expected. Wrong argument: "

  # Option specification errors
  NO_OPTION_NAME_ERROR = "ERROR: option name expected before {. Wrong value is: "
  NO_OPENING_CURLY_BRACE_ERROR = "ERROR: { expected after option name. Wrong value is: "
  NO_CLOSING_CURLY_BRACE_ERROR = "ERROR: } expected after option description. Wrong value is: "
  UNKNOWN_OPTION_ERROR = "ERROR: -t|--type, -a|--alias, -ia|--is-assignable, -ab|--allow-bundle, -ac|--assignment-char expected. Wrong value is: "

  DUPLICATED_TYPE_ERROR = "ERROR: -t|--type duplicated. Wrong value is: "
  DUPLICATED_ALIAS_ERROR = "ERROR: -a|--alias duplicated. Wrong value is: "
  DUPLICATED_IS_ASSIGNABLE_ERROR = "ERROR: -ia|--is-assignable duplicated. Wrong value is: "
  DUPLICATED_ALLOW_BUNDLE_ERROR = "ERROR: -ab|--allow-bundle duplicated. Wrong value is: "
  DUPLICATED_ASSIGNMENT_CHAR_ERROR = "ERROR: -ac|--assignment-char duplicated. Wrong value is: "

  UNKNOWN_TYPE_VALUE_ERROR = "ERROR: integer|float|bool|string expected for -t|--type. Wrong value is: "
  NO_ALIAS_VALUE_ERROR = "ERROR: alias expected after assignment for -a|--alias. Wrong value is: "
  UNKNOWN_ASSIGNABLE_VALUE_ERROR = "ERROR: true|false expected for -ia|--is-assignable. Wrong value is: "
  UNKNOWN_ALLOW_BUNDLE_VALUE_ERROR = "ERROR: true|false expected for -ab|--allow-bundle. Wrong value is: "

  MISSING_TYPE_WHEN_IS_ASSIGNABLE_ERROR = "ERROR: expected -t|--type to be specified when -ia|--is-assignable equals to true."
  MISSING_ALLOW_BUNDLE_WHEN_IS_ASSIGNABLE_ERROR = "ERROR: expected -ab|--allow-bundle to be specified when -ia|--is-assignable equals to true."
  MISSING_ASSIGNMENT_CHAR_WHEN_ALLOW_BUNDLE_ERROR = "ERROR: expected -ac|--assignment-char to be specified when -ia|--is-assignable and -ab|--allow-bundle equal to true."

  # Argument errors
  USER_UNKNOWN_OPTION_ERROR = "ERROR: unknown option used. Wrong value is: "
  USER_OPTION_BUNDLED_ASSIGNMENT_NOT_SUPPORTED_ERROR = "ERROR: unexpected bundled assignment for option without assignment support. Wrong value is: "
  USER_NO_OPTION_VALUE_PROVIDED_ERROR = "ERROR: missing value for option mandating assignment. Wrong value is: "
  USER_NO_OPTION_PROVIDED_ERROR = "ERROR: missing option. Wrong value is: "

  USER_INTEGER_OPTION_VALUE_EXPECTED = "ERROR: integer option value expected. Possible reasons: multiple +/- signs used. Wrong argument: "
  USER_FLOAT_OPTION_VALUE_EXPECTED = "ERROR: float option value expected. Possible reasons: multiple +/- signs used; comma used instead of dot; missing integer part. Wrong argument: "
  USER_BOOL_OPTION_VALUE_EXPECTED = "ERROR: bool option value expected. Possible reasons: wrong char case used; 0/1 literal used as false/true. Wrong argument: "
}
