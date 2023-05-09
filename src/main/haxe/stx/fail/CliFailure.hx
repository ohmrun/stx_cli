package stx.fail;

using stx.Nano;
using stx.sys.Cli;

import stx.Io;
import stx.fail.ProcessFailure;

enum CliFailureSum{
  /**
   * RYO error
   */
  E_Cli(reason:String);
  /**
   * Empty `Sys.args(`
   */
  E_Cli_NoInput;
  /**
   * 
   */
  E_Cli_UnknownOption(v:CliToken);
  E_Cli_ExpectingArg(v:CliToken);
  E_Cli_NoSectionNamed(name:String);
  E_Cli_NoImplementation;
  E_Cli_NoSpec;
  E_Cli_NoSpecValue;
  E_Cli_Options(opts:Cluster<stx.sys.cli.application.spec.OptionSpec.OptionSpecApi>);
  E_Cli_NoHandler;
  E_Cli_ErrorCode(int:Int);
  E_Cli_CannotFindClass(string:String);
  E_Cli_CommandShouldBeAccessor(cmd:CliToken);
  E_Cli_Io(f:IoFailure);
  E_Cli_ProcessFailure(e:ProcessFailure);
  E_Cli_Spec(spec:stx.sys.cli.application.Spec);
  E_Cli_ArgumentSpec(spec:stx.sys.cli.application.spec.term.ArgumentSpec);
  /**
   * Annotate existing error
   */
  E_Cli_Reason(f:CliFailure,reason:String);
  E_Cli_OptionExcludedBy(opt:stx.sys.cli.application.spec.OptionSpec.OptionSpecApi,v:stx.sys.cli.application.spec.OptionValue.OptionValueApi,tk:CliToken);
  E_Cli_NoValueFor(p:stx.sys.cli.application.spec.OptionSpec.OptionSpecApi);
  E_Cli_Parse(e:ParseFailure);
  /**
   * To avoid enforcing an explicit generic and passing it about.
   */
  E_Cli_Embed(block:Void->Void);//Use the oppurtunity to throw an Error of a supersystem
}
abstract CliFailure(CliFailureSum) from CliFailureSum to CliFailureSum{
  public function new(self) this = self;
  @:noUsing static public function lift(self:CliFailureSum):CliFailure return new CliFailure(self);

  public function prj():CliFailureSum return this;
  private var self(get,never):CliFailure;
  private function get_self():CliFailure return lift(this);

  @:from static public function fromParseFailure(self:ParseFailure){
    return lift(E_Cli_Parse(self));
  }
}