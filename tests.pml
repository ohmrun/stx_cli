(indeces "stx.sys.cli.Test")
(
  "cli" 
    include (
      ("stx.sys.cli.test.CliTest" include "test_two_level_spec")
    )
)
(
  "parser"
    include (
      "stx.sys.cli.test.ParserTest"
    )
)
(
  "sys_parser"
    include (
      "stx.sys.cli.test.SysCliParserTest"
    )
)
(
  "readme"
    include (
      "stx.sys.cli.test.ReadmeTest"
    )
)