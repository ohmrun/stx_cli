package stx.fail;

import stx.sys.Cli;

enum CliFailure{
  E_NoImplementation;
  E_NoHandler;
  E_ErrorCode(int:Int);
  E_CannotFindClass(string:String);
  E_CommandShouldBeAccessor(cmd:CliToken);
}