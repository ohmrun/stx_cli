package stx.sys.cli;

class Executor{
  public var context(default,null) : Context;

  public function new(?context){
    this.context = context == null ? Context.unit() : context;
  }
  public function execute():Execute<CliFailure>{
    return @:privateAccess stx.sys.Cli.handlers.toArray().lfold(
      (next:Program,memo:Produce<stx.io.Process,CliFailure>) -> memo.fold_flat_map(
        (res:Res<Process,CliFailure>) -> res.fold(
          ok -> Produce.pure(ok),
          no -> switch(no.val){
          case Some(EXCEPT(E_NoImplementation))   : (Cascade.fromApi(next).provide(context));
            default                               : (Produce.reject(no));
          }
        )
      ),
      Produce.reject(__.fault().of(E_NoImplementation))
    ).point(
      (o:Process) -> Server._.next(o.prj(),
        function rec(y:ProcessResponse) : Proxy<ProcessRequest,ProcessResponse,Noise,Closed,Noise,CliFailure>{
          return switch(y){
            case PResState({ exit_code : Some(0) }) : 
              __.ended(Tap);
            case PResState({ exit_code : Some(i) }) : 
              __.ended(End(__.fault().of(E_ErrorCode(i))));
            case PResState({ exit_code : None }) :
              null;
            case PResValue(res)   : 
              function pull(output,val){
                return Belay.lift(
                  Effect.lift(
                    Output._.relate(
                      e.toOutputRequest().fold(
                        v   -> output.provide(val),
                        ()  -> output
                      )).derive()
                        .errate(E_Cli_Io)
                  ).toFiber()
                   .then(
                      Provide.fromFunXR(
                        () -> __.await(PReqIdle,rec)
                      )
                   )
                );
              }
              switch(res){
                case Failure(er) : pull(__.asys().stderr(),er);
                case Success(ok) : pull(__.asys().stderr(),ok);
              }
              //:Outcome<InputResponse,InputResponse>
            case PResError(raw) :
              //:Rejection<ProcessFailure>
              null;
            case PResReady : 
              null;
          }
        }
      ) 
    );
  }
}