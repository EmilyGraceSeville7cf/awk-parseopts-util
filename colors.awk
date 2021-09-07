@namespace "colors"

BEGIN {
  FG_COLORS["black"] = "\033[30m"
  FG_COLORS["red"] = "\033[31m"
  FG_COLORS["green"] = "\033[32m"
  FG_COLORS["yellow"] = "\033[33m"
  FG_COLORS["blue"] = "\033[34m"
  FG_COLORS["purple"] = "\033[35m"
  FG_COLORS["cyan"] = "\033[36m"
  FG_COLORS["gray"] = "\033[37m"

  BG_COLORS["black"] = "\033[40m"
  BG_COLORS["red"] = "\033[41m"
  BG_COLORS["green"] = "\033[42m"
  BG_COLORS["yellow"] = "\033[43m"
  BG_COLORS["blue"] = "\033[44m"
  BG_COLORS["purple"] = "\033[45m"
  BG_COLORS["cyan"] = "\033[46m"
  BG_COLORS["gray"] = "\033[47m"

  COLORS["reset"] = "\033[0m"
}
