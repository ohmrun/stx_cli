package stx.sys.cli.application.term;

class Anon extends Base{
  public function new(delegate){
    this.delegate = delegate;
  }
  private final delegate : (ctx:CliContext) -> Upshot<ProgramApi,CliFailure>;
  public function apply(ctx:CliContext):Upshot<ProgramApi,CliFailure>{ 
    return delegate(ctx);
  }
}