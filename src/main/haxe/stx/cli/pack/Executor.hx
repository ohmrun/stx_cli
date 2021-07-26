package stx.cli.pack;

class Executor{
  public var context(default,null) : Context;

  public function new(?context){
    this.context = context == null ? Context.unit() : context;
  }
  public function execute():Execute<CliFailure>{
    for (handler in stx.Cli.handlers){
      handler.handle(context);
    }
    var iter            = stx.Ext.LiftIterableToIter.toIter;
    var values          = iter(context.handlers).map(fn -> fn(context));

    var implementations = values.toIter().lfold(
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
          (next,memo:Err<CliFailure>) -> switch next
          {
            case Reject(impl)    : impl.next(memo);
            default               : memo;
          },
          __.fault().of(E_NoHandler)
        )))
    );
  }
}