package stx.sys.cli;

class Executor{
  public var context(default,null) : Context;

  public function new(?context){
    this.context = context == null ? Context.unit() : context;
  }
  public function execute():Execute<CliFailure>{
    for (handler in stx.sys.Cli.handlers){
      handler.handle(context);
    }
    var values          = Iter.lift(context.handlers).map(fn -> fn(context));

    var implementations : Array<ImplementationApi> = values.toIter().lfold(
      (next,memo:Array<ImplementationApi>) -> switch next{
        case Accept(impl)  : memo.snoc(impl);
        case Reject(_)     : memo;
      },
      []
    );
    return implementations.is_defined().if_else(
      () -> implementations[0].reply(),
      () -> 
        Execute.fromOption(Some((values.toIter()).lfold(
          (next,memo:Rejection<CliFailure>) -> switch next
          {
            case Reject(impl)    : impl.concat(memo);
            default              : memo;
          },
          __.fault().of(E_NoHandler)
        )))
    );
  }
}