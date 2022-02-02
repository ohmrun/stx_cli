package stx.sys.cli.term;

class Command implements ProgramApi extends eu.ohmrun.fletcher.term.Sync<Res<Context,CliFailure>,Res<stx.io.Process,CliFailure>,Noise>{
  
  public var command(default,null)    : String;

  public function new(command,?arguments){
    this.command    = command; 
  }
  public function apply(i:Res<Context,CliFailure>):ArwOut<Res<Process,CliFailure>,Noise>{
    return __.success(
      i.map(
        ok -> stx.io.Process.make0(
          Cluster.lift(
            [command].concat(ok.args.args_without_specials().map(Std.string))
          )
        )
      )
    ); 
  }
}