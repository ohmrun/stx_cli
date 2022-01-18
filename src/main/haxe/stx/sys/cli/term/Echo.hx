package stx.sys.cli.term;

class Echo extends eu.ohmrun.cascade.term.Sync<Context,Process,CliFailure> implements CascadeApi<Context,Process,CliFailure>{
  public function new(){}
  public function apply(x:Res<Context,CliFailure>){
    return __.success(
      x.map(
        ctx -> Process.grow(['echo',ctx.info()])
      )
    );
  }
}