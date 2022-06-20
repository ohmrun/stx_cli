package stx.fail;

import stx.Io;
import stx.sys.Cli;

enum CliFailure{
  E_Cli_NoImplementation;
  E_Cli_NoHandler;
  E_Cli_ErrorCode(int:Int);
  E_Cli_CannotFindClass(string:String);
  E_Cli_CommandShouldBeAccessor(cmd:CliToken);
  E_Cli_Io(f:IoFailure);
  E_Cli_ProcessFailure(e:ProcessFailure);
}