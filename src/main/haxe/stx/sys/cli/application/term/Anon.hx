package stx.sys.cli.application.term;

class Anon extends Base{
  public function new(delegate){
    this.delegate = delegate;
  }
  private final delegate : (ctx:CliContext) -> Res<ProgramApi,CliFailure>;
  public function apply(ctx:CliContext):Res<ProgramApi,CliFailure>{ 
    return delegate(ctx);
  }
}